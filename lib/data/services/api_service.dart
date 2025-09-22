import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/storage_helper.dart';

class ApiService {
  static const String baseUrl = "https://helpmespeak.onrender.com/api";

  /// =============================
  /// Generic GET request
  /// =============================
  static Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("$baseUrl$endpoint").replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: _headers(token),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  /// =============================
  /// Generic POST request
  /// =============================
  static Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("$baseUrl$endpoint");

      final response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("POST request error: $e");
    }
  }

  /// =============================
  /// Generic PUT request
  /// =============================
  static Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("$baseUrl$endpoint");

      final response = await http.put(
        uri,
        headers: _headers(token),
        body: jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("PUT request error: $e");
    }
  }

  /// =============================
  /// Generic DELETE request
  /// =============================
  static Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("$baseUrl$endpoint");

      final response = await http.delete(
        uri,
        headers: _headers(token),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("DELETE request error: $e");
    }
  }

  /// =============================
  /// Headers with Token
  /// =============================
  static Map<String, String> _headers(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  /// =============================
  /// Response Handler
  /// =============================
  static dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 305) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Error ${response.statusCode}: ${response.body}");
    }
  }
}
