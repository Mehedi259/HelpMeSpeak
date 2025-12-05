// lib/utils/validation_helper.dart

class ValidationHelper {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email address";
    }

    final email = value.trim();
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < minLength) {
      return "Password must be at least $minLength characters long";
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }

  /// Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a username";
    }

    final username = value.trim();

    if (username.length < 3) {
      return "Username must be at least 3 characters long";
    }

    if (username.length > 30) {
      return "Username must be less than 30 characters";
    }

    // Only allow alphanumeric and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return "Username can only contain letters, numbers, and underscores";
    }

    return null;
  }

  /// Validate full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }

    final name = value.trim();

    if (name.length < 2) {
      return "Name must be at least 2 characters long";
    }

    return null;
  }

  /// Validate OTP
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return "Please enter the OTP code";
    }

    if (value.length != length) {
      return "OTP must be $length digits";
    }

    // Check if all characters are digits
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "OTP must contain only numbers";
    }

    return null;
  }

  /// Check if all fields are filled
  static bool areFieldsFilled(List<String?> values) {
    return values.every((value) => value != null && value.trim().isNotEmpty);
  }
}