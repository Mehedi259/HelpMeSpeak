import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String _baseUrl = 'http://10.10.7.116:8000/api';

  Future<UserModel?> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);
        if (userData.isNotEmpty) {
          final userModel = UserModel.fromJson(userData[0] as Map<String, dynamic>);
          print('User model created: $userModel');
          return userModel;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}