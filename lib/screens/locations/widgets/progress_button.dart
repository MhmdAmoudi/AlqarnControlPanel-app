import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage/api/response_error.dart';
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../utilities/appearance/style.dart';

class LocationProgressButton extends StatelessWidget {
  final String confirmText;
  final String successMessage;
  final Future<dynamic> Function() onPressed;
  final GlobalKey<FormState> formKey;

  LocationProgressButton({
    Key? key,
    required this.confirmText,
    required this.successMessage,
    required this.onPressed,
    required this.formKey,
  }) : super(key: key);

  final Rx<ButtonState> _state = Rx(ButtonState.idle);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProgressButton.icon(
        height: 40.0,
        minWidth: 40.0,
        progressIndicatorSize: 30.0,
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: confirmText,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            color: AppColors.mainColor,
          ),
          ButtonState.loading: const IconedButton(color: AppColors.mainColor),
          ButtonState.fail: IconedButton(
              text: "فشل",
              icon: const Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade300),
          ButtonState.success: const IconedButton(color: Colors.green)
        },
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            _state(ButtonState.loading);
            try {
              var result = await onPressed();
              Get.back(result: result);
              showSnackBar(message: successMessage, type: AlertType.success);
            } on ResponseError catch (e) {
              _state(ButtonState.fail);
              showSnackBar(message: e.message, type: AlertType.failure);
            }
          }
        },
        state: _state.value,
      ),
    );
  }
}
