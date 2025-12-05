import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../utils/storage_helper.dart';
import '../../app/constants/api_constants.dart';

class ApiService {
  /// =============================
  /// Public endpoints (no token needed)
  /// =============================
  static final List<String> _publicEndpoints = [
    ApiConstants.signup,
    ApiConstants.login,
    ApiConstants.otpVerify,
    ApiConstants.forgotPassword,
    ApiConstants.resetPasswordVerify,
    ApiConstants.resetPasswordConfirm,
    ApiConstants.appleLogin,
    ApiConstants.googleLogin, // ✅ NEW
  ];

  /// =============================
  /// GET Request
  /// =============================
  static Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint")
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: _headers(token, endpoint),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  /// =============================
  /// POST Request
  /// =============================
  static Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      print("🚀 POST Request to: $uri");
      print("📤 Body: $body");

      final response = await http.post(
        uri,
        headers: _headers(token, endpoint),
        body: jsonEncode(body),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      return _processResponse(response);
    } catch (e) {
      throw Exception("POST request error: $e");
    }
  }

  /// =============================
  /// PUT Request
  /// =============================
  static Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      final response = await http.put(
        uri,
        headers: _headers(token, endpoint),
        body: jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("PUT request error: $e");
    }
  }

  /// =============================
  /// DELETE Request
  /// =============================
  static Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      final response = await http.delete(
        uri,
        headers: _headers(token, endpoint),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception("DELETE request error: $e");
    }
  }

  /// =============================
  /// Multipart PUT Request
  /// =============================
  static Future<dynamic> putMultipartRequest(
      String endpoint, {
        Map<String, String>? fields,
        Map<String, File>? files,
        Map<String, Uint8List>? webFiles,
      }) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      var request = http.MultipartRequest('PUT', uri);

      if (!_publicEndpoints.contains(endpoint)) {
        final cleaned = token?.trim() ?? "";
        if (cleaned.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $cleaned';
        }
      }

      if (fields != null) {
        request.fields.addAll(fields);
        print("📤 Fields being sent: $fields");
      }

      if (!kIsWeb && files != null) {
        for (var entry in files.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          );
          request.files.add(file);
          print("📱 Mobile file added: ${entry.key} -> ${entry.value.path}");
        }
      }

      if (kIsWeb && webFiles != null) {
        for (var entry in webFiles.entries) {
          final file = http.MultipartFile.fromBytes(
            entry.key,
            entry.value,
            filename: 'profile_image.jpg',
          );
          request.files.add(file);
          print("🌐 Web file added: ${entry.key} (${entry.value.length} bytes)");
        }
      }

      print("🚀 Sending multipart request to: $uri");
      print("📋 Request headers: ${request.headers}");
      print("📂 Files count: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return _processResponse(response);
    } catch (e) {
      print("❌ Multipart PUT error: $e");
      throw Exception("Multipart PUT request error: $e");
    }
  }

  /// =============================
  /// Headers with Token
  /// =============================
  static Map<String, String> _headers(String? token, String endpoint) {
    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    if (!_publicEndpoints.contains(endpoint)) {
      final cleaned = token?.trim() ?? "";
      if (cleaned.isNotEmpty) {
        headers["Authorization"] = "Bearer $cleaned";
      }
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
        try {
          return jsonDecode(response.body);
        } catch (e) {
          print("⚠️ JSON decode error: $e");
          return {"message": response.body};
        }
      } else {
        return {};
      }
    } else {
      print("❌ HTTP Error ${response.statusCode}: ${response.body}");
      throw Exception("${response.statusCode}: ${response.body}");
    }
  }
}