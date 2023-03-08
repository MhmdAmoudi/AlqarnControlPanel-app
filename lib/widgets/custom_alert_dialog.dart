import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../utilities/appearance/style.dart';
import 'animated_snackbar.dart';

abstract class CustomAlertDialog {
  static Future show({
    required AlertType type,
    required String title,
    String? content,
    Widget? body,
    String confirmText = 'موافق',
    Color confirmBackgroundColor = AppColors.mainColor,
    void Function()? onConfirmPressed,
    String cancelText = 'إلغاء',
    void Function()? onCancelPressed,
    bool showCancelButton = true,
    bool animation = true,
  }) async {
    return Get.dialog(
      Dialog(
        backgroundColor: AppColors.darkSubColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: _getDialogColor(type),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 150,
                child: Center(
                  child: animation
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Lottie.asset(
                              'asset/dialog/${_getDialogAnimation(type)}.json',
                              repeat: false,
                              fit: BoxFit.fill,
                              height: 120,
                              width: 120
                            ),
                          ),
                        )
                      : Icon(_getDialogIcon(type), size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (content != null)
                    Text(
                      content,
                      textAlign: TextAlign.justify,
                    ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: body,
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: onConfirmPressed ?? () => Get.back(),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.infinity, 0),
                            backgroundColor: confirmBackgroundColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(confirmText),
                        ),
                      ),
                      if (showCancelButton)
                        OutlinedButton(
                          onPressed: onCancelPressed ?? () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(double.infinity, 0),
                            side: const BorderSide(color: AppColors.mainColor),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(cancelText),
                          ),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.elasticIn,
    );
  }

  static Color _getDialogColor(AlertType type) {
    switch (type) {
      case AlertType.failure:
        return Colors.red;
      case AlertType.success:
        return Colors.green;
      case AlertType.warning:
        return Colors.deepOrange;
      case AlertType.info:
        return Colors.blue;
      case AlertType.question:
        return Colors.orangeAccent;
    }
  }

  static IconData _getDialogIcon(AlertType type) {
    switch (type) {
      case AlertType.failure:
        return Icons.cancel_outlined;
      case AlertType.success:
        return Icons.check_circle_outline_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.info:
        return Icons.info_outline_rounded;
      case AlertType.question:
        return Icons.question_mark_rounded;
    }
  }

  static String _getDialogAnimation(AlertType type) {
    switch (type) {
      case AlertType.failure:
        return 'error';
      case AlertType.success:
        return 'success';
      case AlertType.warning:
        return 'warning';
      case AlertType.info:
        return 'info';
      case AlertType.question:
        return 'question';
    }
  }
}
