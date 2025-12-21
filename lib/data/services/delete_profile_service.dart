// lib/data/services/delete_profile_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/constants/api_constants.dart';
import '../../utils/storage_helper.dart';

class DeleteProfileService {
  /// Delete user profile
  Future<bool> deleteProfile() async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        print("❌ No token found");
        return false;
      }

      final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.deleteProfile));

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🔥 Delete Profile Status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ Profile deleted successfully");
        return true;
      } else {
        print("❌ Delete failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error deleting profile: $e");
      return false;
    }
  }
}