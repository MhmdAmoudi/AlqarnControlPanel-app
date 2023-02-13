import 'package:flutter/material.dart';

import '../../../../utilities/appearance/style.dart';
import '../../../../widgets/custom_textfield.dart';
import '../requirement_widget.dart';

class Info extends StatelessWidget {
  const Info({
    required this.name,
    required this.description,
    Key? key,
  }) : super(key: key);
  final TextEditingController name;
  final TextEditingController description;

  @override
  Widget build(BuildContext context) {
    return RequirementsWidget(
      title: 'معلومات المنتج',
      icon: Icons.label_rounded,
      requirement: Column(
        children: [
          CustomTextFormField(
            fillColor: AppColors.darkMainColor,
            controller: name,
            labelText: 'اسم المنتج',
            hintText: 'ادخل اسم المنتج',
            prefixIcon: Icons.title_rounded,
            borderColor: true,
            validator: (val) {
              if (val!.trim().isEmpty) {
                return 'ادخل اسم المنتج';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextFormField(
            fillColor: AppColors.darkMainColor,
            controller: description,
            labelText: 'وصف المنتج',
            hintText: 'ادخل وصف المنتج',
            prefixIcon: Icons.description_rounded,
            keyboardType: TextInputType.multiline,
            borderColor: true,
            minLines: 4,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
