import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../utilities/appearance/style.dart';

class QrDataCard extends StatelessWidget {
  final String label;
  final RxInt value;
  final int minValue;
  final int maxValue;

  const QrDataCard({
    Key? key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Card(
          color: AppColors.darkSubColor,
          child: Obx(() => NumberPicker(
                value: value.value,
                minValue: minValue,
                maxValue: maxValue,
                onChanged: value,
                itemHeight: 20,
                textStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                selectedTextStyle: const TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 18,
                ),
              )),
        ),
      ],
    );
  }
}
