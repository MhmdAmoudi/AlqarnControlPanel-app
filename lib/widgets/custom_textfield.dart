import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/appearance/style.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.labelText,
    this.suffixIcon,
    this.onPrefixTap,
    this.onSuffixTap,
    this.obscureText = false,
    this.showObscureWidget = true,
    this.borderColor = true,
    this.keyboardType,
    this.focusNode,
    this.fillColor = AppColors.darkSubColor,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.counterText = '',
    this.obscureWidget,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function()? onPrefixTap;
  final Function()? onSuffixTap;
  final bool obscureText;
  final bool showObscureWidget;
  final Widget? obscureWidget;
  final bool borderColor;
  final FocusNode? focusNode;
  final Color fillColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final String? counterText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = false;

  Widget? obscureWidget;

  @override
  void initState() {
    if (widget.obscureText && widget.showObscureWidget) {
      obscureText = true;
      obscureWidget = GestureDetector(
        onTap: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        child: Icon(
          obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 20,
          color: AppColors.mainColor,
        ),
      );
    } else if (widget.suffixIcon != null) {
      obscureWidget = GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(
          widget.suffixIcon,
          size: 20,
          color: Colors.grey,
        ),
      );
    }
    widget.controller.selection =
        TextSelection.fromPosition(const TextPosition(offset: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onEditingComplete: widget.onPrefixTap,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        filled: true,
        isCollapsed: true,
        counterText: widget.counterText,
        fillColor: widget.fillColor,
        contentPadding:
            const EdgeInsets.only(left: 12, right: 8, top: 9, bottom: 9),
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null
            ? GestureDetector(
                onTap: widget.onPrefixTap,
                child: Icon(
                  widget.prefixIcon,
                  size: 22,
                  color: AppColors.mainColor,
                ),
              )
            : null,
        suffix: Transform.translate(
          offset: const Offset(0, 6),
          child: widget.obscureWidget ?? obscureWidget,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.fillColor),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: widget.borderColor
            ? OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.mainColor),
                borderRadius: BorderRadius.circular(5),
              )
            : OutlineInputBorder(
                borderSide: BorderSide(color: widget.fillColor),
                borderRadius: BorderRadius.circular(5),
              ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      obscureText: widget.showObscureWidget ? obscureText : widget.obscureText,
    );
  }
}
