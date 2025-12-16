// lib/data/services/subscription_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subscription_model.dart';
import '../../app/constants/api_constants.dart';
import '../../utils/storage_helper.dart';

class SubscriptionService {
  /// Get all available subscription plans
  static Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/payment/plans/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SubscriptionPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting plans: $e');
      rethrow;
    }
  }

  /// Validate IAP purchase (Apple or Google)
  static Future<ValidationResponse> validatePurchase({
    required String token,
    required String platform, // 'apple' or 'google'
    required String productId,
  }) async {
    try {
      final authToken = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/payment/iap/validate/'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'platform': platform,
          'product_id': productId,
        }),
      );

      if (response.statusCode == 200) {
        return ValidationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Validation failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error validating purchase: $e');
      rethrow;
    }
  }

  /// Get current subscription status
  static Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/payment/subscription/manage/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return SubscriptionStatus.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting subscription status: $e');
      rethrow;
    }
  }

  /// Cancel subscription
  static Future<String> cancelSubscription() async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}/api/payment/subscription/manage/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'cancel',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? 'Subscription cancelled successfully';
      } else {
        throw Exception('Cancellation failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error cancelling subscription: $e');
      rethrow;
    }
  }

  /// Check if user is paid subscriber
  static Future<bool> isPaidUser() async {
    try {
      final status = await getSubscriptionStatus();
      return status.isPaid;
    } catch (e) {
      print('❌ Error checking paid status: $e');
      return false;
    }
  }
}