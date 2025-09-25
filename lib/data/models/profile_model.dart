class ProfileModel {
  final String email;
  final String fullName;
  final String profileImage;

  ProfileModel({
    required this.email,
    required this.fullName,
    required this.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
