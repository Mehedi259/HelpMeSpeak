// lib/controllers/translation_controller.dart

import 'package:get/get.dart';
import '../data/services/translation_service.dart';

class TranslationController extends GetxController {
  var isLoading = false.obs;
  var translatedText = "".obs;
  var audioUrl = "".obs;

  Future<void> translateText(String inputText, String targetLang) async {
    if (inputText.trim().isEmpty) return;

    try {
      isLoading.value = true;
      translatedText.value = ""; // Clear previous translation
      audioUrl.value = ""; // Clear previous audio

      final result = await TranslationService.translateText(
        text: inputText,
        targetLang: targetLang,
      );

      translatedText.value = result["translated_text"] ?? "";
      audioUrl.value = result["audio_url"] ?? "";

      print("✅ Translation successful:");
      print("   - Text: ${translatedText.value}");
      print("   - Audio: ${audioUrl.value}");
    } catch (e) {
      translatedText.value = "Error: $e";
      audioUrl.value = "";
      print("❌ Translation error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear translation results
  void clearTranslation() {
    translatedText.value = "";
    audioUrl.value = "";
  }

  @override
  void onClose() {
    clearTranslation();
    super.onClose();
  }
}