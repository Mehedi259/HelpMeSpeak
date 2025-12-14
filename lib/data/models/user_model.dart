//lib/data/models/user_model.dart
class UserModel {
  final String email;
  final String fullName;
  final String profileImage;

  UserModel({
    required this.email,
    required this.fullName,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"] ?? "",
      fullName: json["full_name"] ?? json["username"] ?? "",
      profileImage: json["profile_image"] ?? "",
    );
  }
}
