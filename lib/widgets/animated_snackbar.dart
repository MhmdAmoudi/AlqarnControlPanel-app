import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController? showSnackBar({
  required String message,
  required AlertType type,
  String? title,
}) {
  switch (type) {
    case AlertType.failure:
      return _snackBarController(
        title,
        message,
        Icons.clear_rounded,
        Colors.red,
      );
    case AlertType.success:
      return _snackBarController(
        title,
        message,
        Icons.check_rounded,
        Colors.green,
      );
    case AlertType.warning:
      return _snackBarController(
        title,
        message,
        Icons.warning_rounded,
        Colors.orange,
      );
    default:
      return _snackBarController(
        title,
        message,
        Icons.info_rounded,
        Colors.blue,
      );
  }
}

SnackbarController? _snackBarController(
  String? title,
  String message,
  IconData icon,
  MaterialColor color,
) {
  if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
  return Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: color),
        ),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    ),
  );
}

enum AlertType { failure, success, warning, info, question }
