// lib/controllers/phrasebook_controller.dart
import 'package:get/get.dart';
import '../data/models/phrase_language_model.dart';
import '../data/models/category_model.dart';
import '../data/services/phrasebook_service.dart';

class PhrasebookController extends GetxController {
  var isLoading = false.obs;
  var isCategoriesLoading = false.obs;

  var phraseLanguages = <PhraseLanguage>[].obs;
  var categories = <Category>[].obs;

  var selectedCategory = Rxn<Category>();
  var sourceLanguage = "Arabic".obs;
  var targetLanguage = "Korean".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final result = await PhrasebookService.getCategories();
      categories.assignAll(result as Iterable<Category>);

      selectedCategory.value = null;
      phraseLanguages.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> fetchPhraseLanguages() async {
    if (selectedCategory.value == null) return;

    try {
      isLoading.value = true;
      final result = await PhrasebookService.getPhraseLanguages(
        sourceLanguage.value,
        targetLanguage.value,
        selectedCategory.value!.id,
      );
      phraseLanguages.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load phrases: $e");
      phraseLanguages.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeCategory(Category category) async {
    selectedCategory.value = category;
    await fetchPhraseLanguages();
  }

  Future<void> changeSourceLanguage(String language) async {
    sourceLanguage.value = language;
    if (selectedCategory.value != null) {
      await fetchPhraseLanguages();
    }
  }

  Future<void> changeTargetLanguage(String language) async {
    targetLanguage.value = language;
    if (selectedCategory.value != null) {
      await fetchPhraseLanguages();
    }
  }

  Future<void> swapLanguages() async {
    final temp = sourceLanguage.value;
    sourceLanguage.value = targetLanguage.value;
    targetLanguage.value = temp;
    if (selectedCategory.value != null) {
      await fetchPhraseLanguages();
    }
  }
}