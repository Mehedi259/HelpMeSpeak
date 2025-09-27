// class ProfileModel {
//   final String email;
//   final String fullName;
//   final String profileImage;
//
//   ProfileModel({
//     required this.email,
//     required this.fullName,
//     required this.profileImage,
//   });
//
//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       email: json['email'] ?? '',
//       fullName: json['full_name'] ?? '',
//       profileImage: json['profile_image'] ?? '',
//     );
//   }
// }
// ==========================================
// 4. lib/data/models/profile_model.dart (REPLACE existing content)
// ==========================================

class ProfileModel {
final int? id;
final String email;
final String fullName;
final String? gender;
final bool? emailVerified;
final String? createdAt;
final String? role;
final String profileImage;

ProfileModel({
this.id,
required this.email,
required this.fullName,
this.gender,
this.emailVerified,
this.createdAt,
this.role,
required this.profileImage,
});

factory ProfileModel.fromJson(Map<String, dynamic> json) {
return ProfileModel(
id: json['id'],
email: json['email'] ?? '',
fullName: json['full_name'] ?? json['username'] ?? '',
gender: json['gender'],
emailVerified: json['email_verified'],
createdAt: json['created_at'],
role: json['role'],
profileImage: json['profile_image'] ?? '',
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'email': email,
'full_name': fullName,
'gender': gender,
'email_verified': emailVerified,
'created_at': createdAt,
'role': role,
'profile_image': profileImage,
};
}
}