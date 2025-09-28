// import 'package:HelpMeSpeak/data/services/api_service.dart';
// import '../../app/constants/api_constants.dart';
//
// class TranslationService {
//   /// Call Translate + TTS API
//   static Future<Map<String, dynamic>> translateText({
//     required String text,
//     required String targetLang,
//   }) async {
//     final body = {
//       "text": text,
//       "target_lang": targetLang.toLowerCase().substring(0, 2),
//     };
//
//     final response = await ApiService.postRequest(
//       ApiConstants.translate,
//       body: body,
//     );
//
//     if (response is Map<String, dynamic>) {
//       return response;
//     } else {
//       throw Exception("Invalid API response: $response");
//     }
//   }
// }
import 'package:HelpMeSpeak/data/services/api_service.dart';
import '../../app/constants/api_constants.dart';

class TranslationService {
  /// Call Translate + TTS API
  static Future<Map<String, dynamic>> translateText({
    required String text,
    required String targetLang,
  }) async {
    final body = {
      "text": text,
      "target_lang": targetLang.toLowerCase().substring(0, 2),
    };

    print("📤 Translation request body: $body");

    final response = await ApiService.postRequest(
      ApiConstants.translate,
      body: body,
    );

    print("📥 Translation API response: $response");

    if (response is Map<String, dynamic>) {
      // ✅ Extract the required fields with proper keys
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