// lib/utils/audio_player_helper.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../app/utils/stub_html.dart' as html;

// ✅ Conditional import with correct path


class AudioPlayerHelper {
  // Mobile player
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static var isPlaying = false.obs;

  // Web player
  static dynamic _audioElement;

  static Future<void> playAudio(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "No audio URL available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (kIsWeb) {
      // Web Audio
      try {
        // Stop any existing audio
        if (_audioElement != null) {
          _audioElement.pause();
          _audioElement = null;
        }

        _audioElement = html.AudioElement(url)
          ..autoplay = true;

        // Listen for audio end event
        _audioElement.onEnded.listen((event) {
          isPlaying.value = false;
          debugPrint("⏹️ Web audio finished");
        });

        html.document.body?.append(_audioElement);
        isPlaying.value = true;
        debugPrint("✅ Web audio playing: $url");
      } catch (e) {
        isPlaying.value = false;
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
      // Mobile Audio
      try {
        debugPrint("🎵 Attempting to play (mobile): $url");
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url));
        isPlaying.value = true;

        _audioPlayer.onPlayerComplete.listen((_) {
          isPlaying.value = false;
          debugPrint("⏹️ Mobile audio finished");
        });
      } catch (e) {
        isPlaying.value = false;
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

  static Future<void> stopAudio() async {
    if (kIsWeb) {
      _audioElement?.pause();
      _audioElement?.remove();
      _audioElement = null;
      isPlaying.value = false;
    } else {
      await _audioPlayer.stop();
      isPlaying.value = false;
    }
  }

  static void dispose() {
    if (!kIsWeb) {
      _audioPlayer.dispose();
    } else {
      _audioElement?.pause();
      _audioElement?.remove();
      _audioElement = null;
    }
    isPlaying.value = false;
  }
}