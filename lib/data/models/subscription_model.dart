// lib/data/models/subscription_model.dart

class SubscriptionPlan {
  final int id;
  final String name;
  final String price;
  final String currency;
  final String interval;
  final bool isActive;
  final String appleProductId;
  final String googleProductId;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.isActive,
    required this.appleProductId,
    required this.googleProductId,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '0.00',
      currency: json['currency'] ?? 'USD',
      interval: json['interval'] ?? '',
      isActive: json['is_active'] ?? false,
      appleProductId: json['apple_product_id'] ?? '',
      googleProductId: json['google_product_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'interval': interval,
      'is_active': isActive,
      'apple_product_id': appleProductId,
      'google_product_id': googleProductId,
    };
  }

  String get displayPrice {
    if (price == '0.00') return 'Free';
    return '$currency $price';
  }

  String get displayInterval {
    if (interval == 'week') return 'Weekly';
    if (interval == 'month') return 'Monthly';
    if (interval == 'year') return 'Yearly';
    return interval;
  }
}

class SubscriptionStatus {
  final String status;
  final String startDate;
  final String renewalDate;
  final String planName;

  SubscriptionStatus({
    required this.status,
    required this.startDate,
    required this.renewalDate,
    required this.planName,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      status: json['status'] ?? 'inactive',
      startDate: json['start_date'] ?? '',
      renewalDate: json['renewal_date'] ?? '',
      planName: json['plan_name'] ?? '',
    );
  }

  bool get isActive => status.toLowerCase() == 'active';
  bool get isPaid => planName != 'trial' && isActive;
}

class ValidationResponse {
  final String message;
  final String subscriptionStatus;
  final String plan;
  final String planInterval;
  final String planPrice;
  final String renewalDate;
  final String platform;

  ValidationResponse({
    required this.message,
    required this.subscriptionStatus,
    required this.plan,
    required this.planInterval,
    required this.planPrice,
    required this.renewalDate,
    required this.platform,
  });

  factory ValidationResponse.fromJson(Map<String, dynamic> json) {
    return ValidationResponse(
      message: json['message'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? '',
      plan: json['plan'] ?? '',
      planInterval: json['plan_interval'] ?? '',
      planPrice: json['plan_price'] ?? '',
      renewalDate: json['renewal_date'] ?? '',
      platform: json['platform'] ?? '',
    );
  }
}