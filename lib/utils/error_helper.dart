// lib/utils/error_helper.dart

import 'dart:convert';

class ErrorHelper {
  /// Parse API error and return user-friendly message
  static String parseApiError(dynamic error) {
    try {
      String errorString = error.toString();

      // Extract JSON from error string if present
      if (errorString.contains('{')) {
        int startIndex = errorString.indexOf('{');
        String jsonPart = errorString.substring(startIndex);

        try {
          var errorData = jsonDecode(jsonPart);
          return _formatErrorData(errorData);
        } catch (e) {
          // If JSON parsing fails, continue with string parsing
        }
      }

      // Handle common error patterns
      if (errorString.contains('SocketException') ||
          errorString.contains('NetworkError')) {
        return "No internet connection. Please check your network.";
      }

      if (errorString.contains('TimeoutException')) {
        return "Request timeout. Please try again.";
      }

      if (errorString.contains('FormatException')) {
        return "Invalid data format. Please try again.";
      }

      // Default fallback
      return "Something went wrong. Please try again.";

    } catch (e) {
      print("Error parsing error message: $e");
      return "An unexpected error occurred.";
    }
  }

  /// Format error data from API response
  static String _formatErrorData(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      // Handle validation errors (field-specific errors)
      if (_isValidationError(errorData)) {
        return _formatValidationErrors(errorData);
      }

      // Handle single message errors
      if (errorData.containsKey('message')) {
        return errorData['message'].toString();
      }

      if (errorData.containsKey('detail')) {
        return errorData['detail'].toString();
      }

      if (errorData.containsKey('error')) {
        return errorData['error'].toString();
      }

      // Handle non_field_errors
      if (errorData.containsKey('non_field_errors')) {
        var errors = errorData['non_field_errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    return "Please check your input and try again.";
  }

  /// Check if error data contains validation errors
  static bool _isValidationError(Map<String, dynamic> errorData) {
    // Common validation field names
    const validationFields = [
      'email', 'password', 'password_confirm', 'username',
      'full_name', 'otp', 'phone', 'name'
    ];

    return errorData.keys.any((key) => validationFields.contains(key));
  }

  /// Format validation errors into readable messages
  static String _formatValidationErrors(Map<String, dynamic> errorData) {
    List<String> messages = [];

    errorData.forEach((field, value) {
      String fieldName = _getFieldDisplayName(field);

      if (value is List && value.isNotEmpty) {
        String errorMsg = value.first.toString();
        messages.add("$fieldName: ${_cleanErrorMessage(errorMsg)}");
      } else if (value is String) {
        messages.add("$fieldName: ${_cleanErrorMessage(value)}");
      }
    });

    // Return first error or combined message
    if (messages.isEmpty) {
      return "Please check your input and try again.";
    } else if (messages.length == 1) {
      return messages.first;
    } else {
      return messages.join("\n");
    }
  }

  /// Get user-friendly field display names
  static String _getFieldDisplayName(String field) {
    const fieldNames = {
      'email': 'Email',
      'password': 'Password',
      'password_confirm': 'Confirm Password',
      'username': 'Username',
      'full_name': 'Full Name',
      'otp': 'OTP Code',
      'phone': 'Phone Number',
      'name': 'Name',
      'first_name': 'First Name',
      'last_name': 'Last Name',
    };

    return fieldNames[field] ??
        field.replaceAll('_', ' ').split(' ')
            .map((word) => word.isEmpty ? '' :
        '${word[0].toUpperCase()}${word.substring(1)}')
            .join(' ');
  }

  /// Clean up technical error messages
  static String _cleanErrorMessage(String message) {
    return message
        .replaceAll('This field', 'This')
        .replaceAll('this field', 'this')
        .replaceAll('Enter a valid', 'Please enter a valid')
        .replaceAll('Ensure this field has', 'Must have')
        .replaceAll('ensure this field has', 'must have')
        .trim();
  }

  /// Get HTTP status code specific messages
  static String getHttpErrorMessage(int statusCode, {String? defaultMessage}) {
    switch (statusCode) {
      case 400:
        return defaultMessage ?? "Invalid request. Please check your input.";
      case 401:
        return "Authentication failed. Please login again.";
      case 403:
        return "Access denied. You don't have permission.";
      case 404:
        return "Resource not found. Please try again.";
      case 409:
        return "This resource already exists.";
      case 422:
        return "Validation failed. Please check your input.";
      case 429:
        return "Too many requests. Please wait and try again.";
      case 500:
        return "Server error. Please try again later.";
      case 502:
        return "Server is temporarily unavailable.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        return defaultMessage ?? "Something went wrong. Please try again.";
    }
  }
}