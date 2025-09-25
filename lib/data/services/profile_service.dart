import '../../app/constants/api_constants.dart';
import '../services/api_service.dart';
import '../models/profile_model.dart';

class ProfileService {
  static Future<ProfileModel> getProfile() async {
    final response = await ApiService.getRequest(ApiConstants.profile);

    if (response is List && response.isNotEmpty) {
      return ProfileModel.fromJson(response[0]);
    } else if (response is Map<String, dynamic>) {
      return ProfileModel.fromJson(response);
    } else {
      throw Exception("Invalid profile data");
    }
  }
}
