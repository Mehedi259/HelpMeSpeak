import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../utils/storage_helper.dart';
import '../../app/constants/api_constants.dart';

class ApiService {
  /// =============================
  /// Generic GET request
  /// =============================
  static Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint")
          .replace(queryParameters: queryParams);

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
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

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
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

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
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

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
  /// Headers with Token (JSON APIs only)
  /// =============================
  static Map<String, String> _headers(String? token) {
    final cleaned = token?.trim() ?? "";
    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    if (cleaned.isNotEmpty) {
      headers["Authorization"] = "Bearer $cleaned";
    }

    return headers;
  }

  /// =============================
  /// Response Handler
  /// =============================
  static dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 305) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {};
      }
    } else {
      throw Exception(
          "Error ${response.statusCode}: ${response.body}");
    }
  }

  /// =============================
  /// Multipart PUT request for file uploads
  /// =============================
  static Future<dynamic> putMultipartRequest(
      String endpoint, {
        Map<String, String>? fields,
        Map<String, File>? files,
      }) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      var request = http.MultipartRequest('PUT', uri);

      // Add authorization header only (Content-Type auto handled)
      final cleaned = token?.trim() ?? "";
      if (cleaned.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $cleaned';
      }

      // Add text fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      throw Exception("Multipart PUT request error: $e");
    }
  }
}
