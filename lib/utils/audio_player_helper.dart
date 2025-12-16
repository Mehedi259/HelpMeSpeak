// lib/utils/audio_player_helper.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../app/utils/stub_html.dart' as html;

class AudioPlayerHelper {
  // Mobile player
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static var isPlaying = false.obs;
  static String _currentUrl = "";

  // Web player
  static dynamic _audioElement;

  /// ✅ Toggle Play/Pause functionality
  static Future<void> togglePlayPause(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "No audio URL available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Jodi already play hochhe SAME URL, tahole pause korbo
    if (isPlaying.value && _currentUrl == url) {
      await pauseAudio();
      debugPrint("⏸️ Pausing current audio");
      return;
    }

    // Jodi different URL, tahole purano stop kore notun play korbo
    if (isPlaying.value && _currentUrl != url) {
      await stopAudio();
      debugPrint("⏹️ Stopping previous audio, playing new one");
    }

    // Notun audio play korbo
    await playAudio(url);
  }

  /// Play audio (internal method)
  static Future<void> playAudio(String url) async {
    if (kIsWeb) {
      // ========================
      // Web Audio Implementation
      // ========================
      try {
        // Stop any existing audio
        if (_audioElement != null) {
          _audioElement.pause();
          _audioElement.remove();
          _audioElement = null;
        }

        _audioElement = html.AudioElement(url)
          ..autoplay = true;

        // Listen for audio end event
        _audioElement.onEnded.listen((event) {
          isPlaying.value = false;
          _currentUrl = "";
          debugPrint("⏹️ Web audio finished");
        });

        // Listen for pause event
        _audioElement.onPause.listen((event) {
          if (!_audioElement.ended) {
            isPlaying.value = false;
            debugPrint("⏸️ Web audio paused by user");
          }
        });

        // Listen for play event
        _audioElement.onPlay.listen((event) {
          isPlaying.value = true;
          debugPrint("▶️ Web audio playing");
        });

        html.document.body?.append(_audioElement);
        isPlaying.value = true;
        _currentUrl = url;
        debugPrint("✅ Web audio playing: $url");
      } catch (e) {
        isPlaying.value = false;
        _currentUrl = "";
        Get.snackbar(
          "Playback Error",
          "Failed to play audio: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        debugPrint("❌ Web audio error: $e");
      }
    } else {
      // ==========================
      // Mobile Audio Implementation
      // ==========================
      try {
        debugPrint("🎵 Attempting to play (mobile): $url");

        // Stop previous audio if playing
        await _audioPlayer.stop();

        // Play new audio
        await _audioPlayer.play(UrlSource(url));
        isPlaying.value = true;
        _currentUrl = url;

        // Listen for completion
        _audioPlayer.onPlayerComplete.listen((_) {
          isPlaying.value = false;
          _currentUrl = "";
          debugPrint("⏹️ Mobile audio finished");
        });

        // Listen for state changes
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (state == PlayerState.playing) {
            isPlaying.value = true;
          } else if (state == PlayerState.paused || state == PlayerState.stopped) {
            isPlaying.value = false;
          }
        });

        debugPrint("✅ Mobile audio started playing");
      } catch (e) {
        isPlaying.value = false;
        _currentUrl = "";
        Get.snackbar(
          "Playback Error",
          "Failed to play audio: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        debugPrint("❌ Mobile audio error: $e");
      }
    }
  }

  /// Pause audio (keeps position)
  static Future<void> pauseAudio() async {
    if (kIsWeb) {
      if (_audioElement != null) {
        _audioElement.pause();
        isPlaying.value = false;
        debugPrint("⏸️ Web audio paused");
      }
    } else {
      await _audioPlayer.pause();
      isPlaying.value = false;
      debugPrint("⏸️ Mobile audio paused");
    }
  }

  /// Resume paused audio
  static Future<void> resumeAudio() async {
    if (kIsWeb) {
      if (_audioElement != null) {
        _audioElement.play();
        isPlaying.value = true;
        debugPrint("▶️ Web audio resumed");
      }
    } else {
      await _audioPlayer.resume();
      isPlaying.value = true;
      debugPrint("▶️ Mobile audio resumed");
    }
  }

  /// Stop audio completely (resets position)
  static Future<void> stopAudio() async {
    if (kIsWeb) {
      if (_audioElement != null) {
        _audioElement.pause();
        _audioElement.remove();
        _audioElement = null;
      }
      isPlaying.value = false;
      _currentUrl = "";
      debugPrint("⏹️ Web audio stopped");
    } else {
      await _audioPlayer.stop();
      isPlaying.value = false;
      _currentUrl = "";
      debugPrint("⏹️ Mobile audio stopped");
    }
  }

  /// Get current playing URL
  static String getCurrentUrl() => _currentUrl;

  /// Check if specific URL is playing
  static bool isUrlPlaying(String url) {
    return isPlaying.value && _currentUrl == url;
  }

  /// Dispose and cleanup
  static void dispose() {
    if (!kIsWeb) {
      _audioPlayer.dispose();
    } else {
      if (_audioElement != null) {
        _audioElement.pause();
        _audioElement.remove();
        _audioElement = null;
      }
    }
    isPlaying.value = false;
    _currentUrl = "";
    debugPrint("🗑️ Audio player disposed");
  }
}