//lib/data/services/chatbot_service.dart
import '../../app/constants/api_constants.dart';
import 'api_service.dart';

class ChatbotService {
  static Future<Map<String, dynamic>> sendMessage(String input) async {
    final response = await ApiService.postRequest(ApiConstants.chatbot, body: {
      "input": input,
    });

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Unexpected chatbot response: $response");
    }
  }
}
