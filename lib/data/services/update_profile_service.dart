// lib/data/services/profile_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';
import '../../app/constants/api_constants.dart';

class ProfileService {
  // GET profile
  static Future<ProfileModel?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profile}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        return ProfileModel.fromJson(data[0]['user']);
      }
    }
    return null;
  }

  // UPDATE profile
  static Future<ProfileModel?> updateProfile({
    required String token,
    required String fullName,
    File? profileImage,
  }) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profile}'));
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.fields['full_name'] = fullName;

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        profileImage.path,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        return ProfileModel.fromJson(data[0]['user']);
      }
    }

    return null;
  }
}
