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
      final result = await TranslationService.translateText(
        text: inputText,
        targetLang: targetLang,
      );

      translatedText.value = result["translated_text"] ?? "";
      audioUrl.value = result["audio_url"] ?? "";
    } catch (e) {
      translatedText.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
