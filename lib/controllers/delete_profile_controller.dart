// lib/controllers/delete_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/delete_profile_service.dart';
import '../utils/storage_helper.dart';

class DeleteProfileController extends GetxController {
  final DeleteProfileService _deleteService = DeleteProfileService();

  var isDeleting = false.obs;

  /// Delete user account
  Future<bool> deleteAccount() async {
    try {
      isDeleting.value = true;

      print("🔥 Starting account deletion...");

      // Call delete service
      final success = await _deleteService.deleteProfile();

      if (success) {
        print("✅ Account deleted from server");

        // Clear all local data
        await StorageHelper.clearAllUserData();

        print("✅ All local data cleared");

        return true;
      } else {
        print("❌ Failed to delete account from server");

        return false;
      }
    } catch (e) {
      print("❌ Error in deleteAccount: $e");
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  /// Show confirmation dialog before deleting (using Flutter's native dialog)
  Future<void> showDeleteConfirmation(
      BuildContext context,
      Function onConfirm,
      ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            "Are you sure you want to permanently delete your account? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                onConfirm(); // Execute delete
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show success message
  void showSuccessMessage() {
    print("✅ Showing success message");
  }

  /// Show error message
  void showErrorMessage(String message) {
    print("❌ Error: $message");
  }
}