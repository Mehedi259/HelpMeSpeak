// lib/data/services/phrasebook_service.dart
import '../models/phrase_language_model.dart';
import '../models/phrase_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../../app/constants/api_constants.dart';

class PhrasebookService {
  // Get all categories
  static Future<List<Category>> getCategories() async {
    final response = await ApiService.getRequest(ApiConstants.categories);

    if (response is List) {
      return response.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Invalid categories data");
    }
  }

  // Get phrases filtered by languages and category
  static Future<List<PhraseLanguage>> getPhraseLanguages(
      String lang1, String lang2, int categoryId) async {
    final response = await ApiService.getRequest(
        "/api/phrase-languages/?lang1=$lang1&lang2=$lang2&category=$categoryId");

    if (response is List && response.isNotEmpty) {
      // The API returns nested array, so we need to handle it
      final data = response[0] is List ? response[0] : response;
      return (data as List).map((e) => PhraseLanguage.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // Get all phrases for a category (fallback method)
  static Future<List<Phrase>> getPhrases(int categoryId) async {
    final response = await ApiService.getRequest("${ApiConstants.phrases}?category=$categoryId");

    if (response is List) {
      return response.map((e) => Phrase.fromJson(e)).toList();
    } else {
      throw Exception("Invalid phrases data");
    }
  }
}