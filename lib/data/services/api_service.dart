import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../utils/storage_helper.dart';
import '../../app/constants/api_constants.dart';

class ApiService {
  static final List<String> _publicEndpoints = [
    ApiConstants.signup,
    ApiConstants.login,
    ApiConstants.otpVerify,
    ApiConstants.forgotPassword,
    ApiConstants.resetPasswordVerify,
    ApiConstants.resetPasswordConfirm,
    ApiConstants.appleLogin,
    ApiConstants.googleLogin,
  ];

  /// ✅ Token Refresh Method
  static Future<String?> _refreshToken() async {
    try {
      final refreshToken = await StorageHelper.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        print("❌ No refresh token available");
        return null;
      }

      print("🔄 Attempting to refresh token...");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/auth/token/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access']?.toString();

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await StorageHelper.saveToken(newAccessToken);
          print("✅ Token refreshed successfully");
          return newAccessToken;
        }
      }

      print("❌ Token refresh failed: ${response.statusCode}");
      return null;
    } catch (e) {
      print("❌ Token refresh error: $e");
      return null;
    }
  }

  /// ✅ Handle 401 and retry with refreshed token
  static Future<dynamic> _handleResponse(
      http.Response response,
      String endpoint,
      Future<http.Response> Function(String token) retryRequest,
      ) async {
    if (response.statusCode == 401 && !_publicEndpoints.contains(endpoint)) {
      print("⚠️ 401 Unauthorized - Attempting token refresh...");

      final newToken = await _refreshToken();
      if (newToken != null) {
        print("🔄 Retrying request with new token...");
        final retryResponse = await retryRequest(newToken);
        return _processResponse(retryResponse);
      } else {
        print("❌ Token refresh failed - User needs to login again");
        // Clear tokens and navigate to login
        await StorageHelper.clearToken();
        await StorageHelper.clearRefreshToken();
        throw Exception("Session expired. Please login again.");
      }
    }

    return _processResponse(response);
  }

  /// GET Request
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

      return await _handleResponse(response, endpoint, (newToken) async {
        return await http.get(uri, headers: _headers(newToken, endpoint));
      });
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  /// POST Request
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

      return await _handleResponse(response, endpoint, (newToken) async {
        return await http.post(
          uri,
          headers: _headers(newToken, endpoint),
          body: jsonEncode(body),
        );
      });
    } catch (e) {
      throw Exception("POST request error: $e");
    }
  }

  /// PUT Request
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

      return await _handleResponse(response, endpoint, (newToken) async {
        return await http.put(
          uri,
          headers: _headers(newToken, endpoint),
          body: jsonEncode(body),
        );
      });
    } catch (e) {
      throw Exception("PUT request error: $e");
    }
  }

  /// Multipart PUT Request with retry
  static Future<dynamic> putMultipartRequest(
      String endpoint, {
        Map<String, String>? fields,
        Map<String, File>? files,
        Map<String, Uint8List>? webFiles,
      }) async {
    try {
      final token = await StorageHelper.getToken();

      final response = await _sendMultipartRequest(
        endpoint,
        token,
        fields,
        files,
        webFiles,
      );

      // Handle 401 with token refresh
      if (response.statusCode == 401 && !_publicEndpoints.contains(endpoint)) {
        print("⚠️ 401 Unauthorized - Attempting token refresh...");

        final newToken = await _refreshToken();
        if (newToken != null) {
          print("🔄 Retrying multipart request with new token...");
          final retryResponse = await _sendMultipartRequest(
            endpoint,
            newToken,
            fields,
            files,
            webFiles,
          );
          return _processResponse(retryResponse);
        } else {
          await StorageHelper.clearToken();
          await StorageHelper.clearRefreshToken();
          throw Exception("Session expired. Please login again.");
        }
      }

      return _processResponse(response);
    } catch (e) {
      print("❌ Multipart PUT error: $e");
      throw Exception("Multipart PUT request error: $e");
    }
  }

  /// ✅ Internal method to send multipart request
  static Future<http.Response> _sendMultipartRequest(
      String endpoint,
      String? token,
      Map<String, String>? fields,
      Map<String, File>? files,
      Map<String, Uint8List>? webFiles,
      ) async {
    final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
    var request = http.MultipartRequest('PUT', uri);

    // Add auth header
    if (!_publicEndpoints.contains(endpoint)) {
      final cleaned = token?.trim() ?? "";
      if (cleaned.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $cleaned';
      }
    }

    // Add fields
    if (fields != null) {
      request.fields.addAll(fields);
      print("📤 Fields: $fields");
    }

    // Add files (mobile)
    if (!kIsWeb && files != null) {
      for (var entry in files.entries) {
        final file = await http.MultipartFile.fromPath(
          entry.key,
          entry.value.path,
        );
        request.files.add(file);
        print("📱 File: ${entry.key} -> ${entry.value.path}");
      }
    }

    // Add files (web)
    if (kIsWeb && webFiles != null) {
      for (var entry in webFiles.entries) {
        final file = http.MultipartFile.fromBytes(
          entry.key,
          entry.value,
          filename: 'profile_image.jpg',
        );
        request.files.add(file);
        print("🌐 File: ${entry.key} (${entry.value.length} bytes)");
      }
    }

    print("🚀 Sending multipart request to: $uri");
    print("📂 Files count: ${request.files.length}");

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  /// Headers
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

  /// Response Handler
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