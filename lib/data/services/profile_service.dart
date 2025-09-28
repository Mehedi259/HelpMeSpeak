// // ==========================================
// // 2. lib/data/services/profile_service.dart
// // ==========================================
//
// import 'dart:io';
// import '../../app/constants/api_constants.dart';
// import '../services/api_service.dart';
// import '../models/profile_model.dart';
//
// class ProfileService {
//   /// Get user profile
//   static Future<ProfileModel> getProfile(String token) async {
//     final response = await ApiService.getRequest(ApiConstants.profile);
//
//     if (response is List && response.isNotEmpty) {
//       return ProfileModel.fromJson(response[0]['user'] ?? response[0]);
//     } else if (response is Map<String, dynamic>) {
//       return ProfileModel.fromJson(response['user'] ?? response);
//     } else {
//       throw Exception("Invalid profile data format");
//     }
//   }
//
//   /// Update user profile with multipart support
//   static Future<ProfileModel> updateProfile({
//     required String fullName,
//     String? gender,
//     File? profileImage, required String token,
//   }) async {
//     final fields = <String, String>{
//       'full_name': fullName,
//     };
//
//     if (gender != null && gender.isNotEmpty) {
//       fields['gender'] = gender;
//     }
//
//     final files = <String, File>{};
//     if (profileImage != null) {
//       files['profile_image'] = profileImage;
//     }
//
//     final response = await ApiService.putMultipartRequest(
//       ApiConstants.profile,
//       fields: fields,
//       files: files.isNotEmpty ? files : null,
//     );
//
//     if (response is List && response.isNotEmpty) {
//       return ProfileModel.fromJson(response[0]['user'] ?? response[0]);
//     } else if (response is Map<String, dynamic>) {
//       return ProfileModel.fromJson(response['user'] ?? response);
//     } else {
//       throw Exception("Invalid update response format");
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
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
    String? phone, // Add phone parameter
    File? profileImage,
    Uint8List? profileImageBytes,
    required String token,
  }) async {
    final fields = <String, String>{
      'full_name': fullName,
    };

    if (gender != null && gender.isNotEmpty) {
      fields['gender'] = gender;
    }

    // Add phone field (required by your API based on curl command)
    if (phone != null && phone.isNotEmpty) {
      fields['phone'] = phone;
    } else {
      // Provide a default phone number if none provided
      fields['phone'] = "+8801234567890";
    }

    // CRITICAL FIX: Use correct field name 'image' instead of 'profile_image'
    // Based on your curl command which uses 'image=@...'
    Map<String, File>? files;
    Map<String, Uint8List>? webFiles;

    if (kIsWeb && profileImageBytes != null) {
      // Web platform - use bytes
      webFiles = {'image': profileImageBytes}; // Changed from 'profile_image' to 'image'
      print("🌐 Web: Adding image bytes (${profileImageBytes.length} bytes)");
    } else if (!kIsWeb && profileImage != null) {
      // Mobile platform - use file
      files = {'image': profileImage}; // Changed from 'profile_image' to 'image'
      print("📱 Mobile: Adding image file (${profileImage.path})");
    }

    print("📤 Sending fields: $fields");
    print("📤 Has files: ${files?.isNotEmpty ?? false}");
    print("📤 Has webFiles: ${webFiles?.isNotEmpty ?? false}");

    final response = await ApiService.putMultipartRequest(
      ApiConstants.profile,
      fields: fields,
      files: files,
      webFiles: webFiles,
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