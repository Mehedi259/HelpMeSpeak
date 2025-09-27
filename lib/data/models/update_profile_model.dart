// lib/data/models/profile_model.dart
class ProfileModel {
  final int id;
  final String email;
  final String fullName;
  final String gender;
  final bool emailVerified;
  final String createdAt;
  final String role;
  final String? profileImage;

  ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.emailVerified,
    required this.createdAt,
    required this.role,
    this.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      gender: json['gender'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      createdAt: json['created_at'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}
