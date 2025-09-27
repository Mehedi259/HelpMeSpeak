// ==========================================
// 2. lib/data/services/profile_service.dart
// ==========================================

import 'dart:io';
import '../../app/constants/api_constants.dart';
import '../services/api_service.dart';
import '../models/profile_model.dart';

class ProfileService {
  /// Get user profile
  static Future<ProfileModel> getProfile(String token) async {
    final response = await ApiService.getRequest(ApiConstants.profile);

    if (response is List && response.isNotEmpty) {
      return ProfileModel.fromJson(response[0]['user'] ?? response[0]);
    } else if (response is Map<String, dynamic>) {
      return ProfileModel.fromJson(response['user'] ?? response);
    } else {
      throw Exception("Invalid profile data format");
    }
  }

  /// Update user profile with multipart support
  static Future<ProfileModel> updateProfile({
    required String fullName,
    String? gender,
    File? profileImage, required String token,
  }) async {
    final fields = <String, String>{
      'full_name': fullName,
    };

    if (gender != null && gender.isNotEmpty) {
      fields['gender'] = gender;
    }

    final files = <String, File>{};
    if (profileImage != null) {
      files['profile_image'] = profileImage;
    }

    final response = await ApiService.putMultipartRequest(
      ApiConstants.profile,
      fields: fields,
      files: files.isNotEmpty ? files : null,
    );

    if (response is List && response.isNotEmpty) {
      return ProfileModel.fromJson(response[0]['user'] ?? response[0]);
    } else if (response is Map<String, dynamic>) {
      return ProfileModel.fromJson(response['user'] ?? response);
    } else {
      throw Exception("Invalid update response format");
    }
  }
}