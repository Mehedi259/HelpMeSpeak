// lib/controllers/phrasebook_controller.dart
import 'package:get/get.dart';
import '../data/models/phrase_model.dart' hide Category;
import '../data/models/phrase_language_model.dart';
import '../data/models/category_model.dart';
import '../data/services/phrasebook_service.dart';

class PhrasebookController extends GetxController {
  var isLoading = false.obs;
  var isCategoriesLoading = false.obs;

  var phrases = <Phrase>[].obs;
  var phraseLanguages = <PhraseLanguage>[].obs;
  var categories = <Category>[].obs;

  var selectedCategory = Rxn<Category>();
  var sourceLanguage = "English".obs;
  var targetLanguage = "Spanish".obs;

  final List<String> availableLanguages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Bengali",
    "Arabic",
    "Hindi",
    "Japanese",
    "Korean",
    "Chinese",
    "Italian",
    "Russian",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final result = await PhrasebookService.getCategories();
      categories.assignAll(result as Iterable<Category>);

      // Set first category as default if available
      if (categories.isNotEmpty) {
        selectedCategory.value = categories.first;
        await fetchPhraseLanguages();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // Fetch phrases filtered by selected languages and category
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

      // If no filtered results, try fetching all phrases for the category
      if (result.isEmpty) {
        await fetchAllPhrasesForCategory();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load phrases: $e");
      // Fallback to all phrases
      await fetchAllPhrasesForCategory();
    } finally {
      isLoading.value = false;
    }
  }

  // Fallback method to fetch all phrases for category
  Future<void> fetchAllPhrasesForCategory() async {
    if (selectedCategory.value == null) return;

    try {
      final result = await PhrasebookService.getPhrases(selectedCategory.value!.id);
      phrases.assignAll(result);
    } catch (e) {
      print("Error fetching all phrases: $e");
    }
  }

  // Change category
  Future<void> changeCategory(Category category) async {
    selectedCategory.value = category;
    await fetchPhraseLanguages();
  }

  // Change source language
  Future<void> changeSourceLanguage(String language) async {
    sourceLanguage.value = language;
    await fetchPhraseLanguages();
  }

  // Change target language  
  Future<void> changeTargetLanguage(String language) async {
    targetLanguage.value = language;
    await fetchPhraseLanguages();
  }

  // Swap languages
  Future<void> swapLanguages() async {
    final temp = sourceLanguage.value;
    sourceLanguage.value = targetLanguage.value;
    targetLanguage.value = temp;
    await fetchPhraseLanguages();
  }
}