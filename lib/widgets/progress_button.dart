import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../utilities/appearance/style.dart';

class CustomProgressButton extends StatelessWidget {
  const CustomProgressButton({
    Key? key,
    required this.state,
    required this.confirmText,
    required this.onPressed,
  }) : super(key: key);
  final ButtonState state;
  final String confirmText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ProgressButton.icon(
      height: 40.0,
      minWidth: 40.0,
      progressIndicatorSize: 30.0,
      iconedButtons: {
        ButtonState.idle: const IconedButton(
          text: "إضافة",
          icon: Icon(Icons.add_rounded, color: Colors.white),
          color: AppColors.mainColor,
        ),
        ButtonState.loading: const IconedButton(color: AppColors.mainColor),
        ButtonState.fail: IconedButton(
            text: "فشل",
            icon: const Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: "تم بنجاح",
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: onPressed,
      state: state,
    );
  }
}
