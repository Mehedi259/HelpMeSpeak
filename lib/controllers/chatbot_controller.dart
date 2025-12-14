//lib/controllers/chatbot_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app/constants/api_constants.dart';
import '../../utils/storage_helper.dart';
import '../data/models/chat_message.dart';

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;

  Future<void> sendMessage(String input) async {
    messages.add(ChatMessage(
      id: DateTime.now().toString(),
      message: input,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.chatbot}");

    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({"input": input}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ FIX: Correct path to translated text
        final translated = data["translation"]?["translated_text"] ??
            data["translation_result"]?["translated_text"] ??
            "No translation";

        messages.add(ChatMessage(
          id: DateTime.now().toString(),
          message: translated,
          translatedText: translated,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else {
        messages.add(ChatMessage(
          id: DateTime.now().toString(),
          message: "Type this format - How are you in Spanish",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }

    } catch (e) {
      messages.add(ChatMessage(
        id: DateTime.now().toString(),
        message: "Error: $e",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }
}