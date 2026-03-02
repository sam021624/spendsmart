import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class WidgetSnackbar {
  /// Shows a success toast
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(title ?? 'Success'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
    );
  }

  /// Shows an error toast (Perfect for your Login/Firebase errors)
  static void showError({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(title ?? 'Error'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: Colors.red,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      description: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
