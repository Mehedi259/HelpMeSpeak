// lib/data/services/phrasebook_service.dart
import '../models/phrase_language_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../../app/constants/api_constants.dart';

class PhrasebookService {
  // Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final response = await ApiService.getRequest(ApiConstants.categories);

      if (response is List) {
        return response.map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception("Invalid categories data");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }

  // Get phrases filtered by languages and category
  static Future<List<PhraseLanguage>> getPhraseLanguages(
      String lang1, String lang2, int categoryId) async {
    try {
      final response = await ApiService.getRequest(
        "/api/phrase-languages/",
        queryParams: {
          'lang1': lang1,
          'lang2': lang2,
          'category': categoryId.toString(),
        },
      );

      if (response is List && response.isNotEmpty) {
        return (response).map((e) => PhraseLanguage.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching phrase languages: $e");
      return [];
    }
  }
}