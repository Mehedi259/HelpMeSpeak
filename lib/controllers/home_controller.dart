import 'package:get/get.dart';
import '../data/services/user_service.dart';
import '../data/models/user_model.dart';

class HomeController extends GetxController {
  final UserService _userService = UserService();

  // Observable variables
  var isLoading = true.obs;
  var userName = 'Hello User'.obs;
  var profileImageUrl = ''.obs;
  var userEmail = ''.obs;
  var userId = 0.obs;
  var userGender = ''.obs;
  var userRole = ''.obs;
  var isEmailVerified = false.obs;
  var hasError = false.obs;

  // Store complete user model
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final userProfile = await _userService.getUserProfile();

      if (userProfile != null) {
        // Store complete user model
        currentUser.value = userProfile;

        // Update observable variables
        userName.value = 'Hello ${userProfile.fullName}';
        profileImageUrl.value = userProfile.profileImage;
        userEmail.value = userProfile.email;

        print('User data loaded: ${userProfile.fullName}, ${userProfile.email}');
      } else {
        hasError.value = true;
        userName.value = 'Hello User';
        currentUser.value = null;
        print('No user profile data received');
      }
    } catch (e) {
      print('Error in loadUserProfile: $e');
      hasError.value = true;
      userName.value = 'Hello User';
      currentUser.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  // Helper methods
  String get displayName => currentUser.value?.fullName ?? 'User';
  String get userProfileImage => currentUser.value?.profileImage ?? '';
  bool get hasUserData => currentUser.value != null;
}