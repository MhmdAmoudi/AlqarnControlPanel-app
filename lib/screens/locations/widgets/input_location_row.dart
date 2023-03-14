import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/custom_textfield.dart';

class InputLocationRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const InputLocationRow({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 15),
        Expanded(
          child: CustomTextFormField(
            controller: controller,
            hintText: hint,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: (val) {
              if (val!.trim().isEmpty) {
                return hint;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
