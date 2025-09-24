import 'package:get/get.dart';
import '../data/services/phrasebook_service.dart';

class PhrasebookController extends GetxController {
  var categories = <dynamic>[].obs;
  var phrases = <dynamic>[].obs;

  var selectedCategoryId = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final cats = await PhrasebookService.fetchCategories();
      categories.value = cats;
      if (cats.isNotEmpty) {
        selectedCategoryId.value = cats[0]["id"];
        await loadPhrases(selectedCategoryId.value);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Load phrases by category id
  Future<void> loadPhrases(int categoryId) async {
    try {
      isLoading.value = true;
      final phs = await PhrasebookService.fetchPhrases(categoryId);
      phrases.value = phs;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Change category
  void changeCategory(int id) {
    selectedCategoryId.value = id;
    loadPhrases(id);
  }
}
