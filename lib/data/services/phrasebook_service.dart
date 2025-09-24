import '../services/api_service.dart';
import '../../app/constants/api_constants.dart';

class PhrasebookService {
  /// fetch categories
  static Future<List<dynamic>> fetchCategories() async {
    final response = await ApiService.getRequest(ApiConstants.categories);
    return response;
  }

  /// fetch phrases by category id
  static Future<List<dynamic>> fetchPhrases(int categoryId) async {
    final response = await ApiService.getRequest(
      ApiConstants.phrases,
      queryParams: {"category": categoryId.toString()},
    );
    return response;
  }
}
