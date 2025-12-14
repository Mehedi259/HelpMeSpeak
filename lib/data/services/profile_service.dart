import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../app/constants/api_constants.dart';
import '../services/api_service.dart';
import '../models/profile_model.dart';

class ProfileService {
  /// Get user profile
  static Future<ProfileModel> getProfile(String token) async {
    final response = await ApiService.getRequest(ApiConstants.profile);

    if (response is List && response.isNotEmpty) {
      final data = response[0];
      return ProfileModel.fromJson(data['user'] ?? data);
    } else if (response is Map<String, dynamic>) {
      return ProfileModel.fromJson(response['user'] ?? response);
    } else {
      throw Exception("Invalid profile data format");
    }
  }

  /// ✅ Compress image before upload
  static Future<Uint8List> _compressImage(dynamic imageSource) async {
    Uint8List? imageBytes;

    if (imageSource is File) {
      imageBytes = await imageSource.readAsBytes();
    } else if (imageSource is Uint8List) {
      imageBytes = imageSource;
    } else {
      throw Exception("Invalid image source");
    }

    // Check if image needs compression (if > 500KB)
    if (imageBytes.length > 500 * 1024) {
      print("📦 Compressing image from ${imageBytes.length} bytes...");

      final compressed = await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      print("✅ Compressed to ${compressed.length} bytes");
      return compressed;
    }

    return imageBytes;
  }

  /// Update user profile with multipart support
  static Future<ProfileModel> updateProfile({
    required String fullName,
    String? gender,
    String? phone,
    File? profileImage,
    Uint8List? profileImageBytes,
    required String token,
  }) async {
    try {
      final fields = <String, String>{
        'full_name': fullName,
      };

      // ✅ Add gender only if not empty
      if (gender != null && gender.isNotEmpty) {
        fields['gender'] = gender;
      }

      // ✅ Add phone only if not empty
      if (phone != null && phone.isNotEmpty) {
        fields['phone'] = phone;
      }

      Map<String, File>? files;
      Map<String, Uint8List>? webFiles;

      // ✅ Handle image with compression
      if (profileImage != null || profileImageBytes != null) {
        print("📸 Processing profile image...");

        final compressedBytes = await _compressImage(
          profileImage ?? profileImageBytes,
        );

        if (kIsWeb) {
          // Web platform
          webFiles = {'image': compressedBytes};
          print("🌐 Web: Adding compressed image (${compressedBytes.length} bytes)");
        } else {
          // Mobile platform - create temp file from compressed bytes
          final tempFile = File('${Directory.systemTemp.path}/temp_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await tempFile.writeAsBytes(compressedBytes);
          files = {'image': tempFile};
          print("📱 Mobile: Adding compressed image file");
        }
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

      // Clean up temp file if created
      if (!kIsWeb && files != null) {
        try {
          await files['image']!.delete();
        } catch (e) {
          print("⚠️ Could not delete temp file: $e");
        }
      }

      if (response is List && response.isNotEmpty) {
        final data = response[0];
        return ProfileModel.fromJson(data['user'] ?? data);
      } else if (response is Map<String, dynamic>) {
        return ProfileModel.fromJson(response['user'] ?? response);
      } else {
        throw Exception("Invalid update response format");
      }
    } catch (e) {
      print("❌ Profile update error: $e");
      rethrow;
    }
  }
}