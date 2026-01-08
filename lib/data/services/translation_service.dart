// lib/data/services/translation_service.dart

import 'package:HelpMeSpeak/data/services/api_service.dart';
import '../../app/constants/api_constants.dart';

class TranslationService {
  /// Call Translate + TTS API
  static Future<Map<String, dynamic>> translateText({
    required String text,
    required String targetLang,
  }) async {
    // ✅ Handle Chinese (Traditional) language code properly
    String langCode = targetLang;

    // If it's Chinese Traditional, use the full code "zh-TW"
    if (targetLang.toLowerCase() == "zh-tw") {
      langCode = "zh-TW";
    } else {
      // For other languages, use first 2 characters
      langCode = targetLang.toLowerCase().substring(0, 2);
    }

    final body = {
      "text": text,
      "target_lang": langCode,
    };

    print("📤 Translation request body: $body");

    final response = await ApiService.postRequest(
      ApiConstants.translate,
      body: body,
    );

    print("📥 Translation API response: $response");

    if (response is Map<String, dynamic>) {
      return {
        "translated_text": response["translated_text"] ?? "",
        "audio_url": response["audio_url"] ?? "",
        "original_text": response["original_text"] ?? "",
      };
    } else {
      throw Exception("Invalid API response: $response");
    }
  }
}