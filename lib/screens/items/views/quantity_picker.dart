import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class QuantityPicker extends StatelessWidget {
  QuantityPicker({
    Key? key,
    required this.onChange,
  }) : super(key: key);
  final Function(int) onChange;
  final RxInt _currentValue = RxInt(0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => NumberPicker(
            value: _currentValue.value,
            minValue: 0,
            maxValue: 1000,
            onChanged: (value) {
              onChange(value);
              _currentValue(value);
            },
          ),
        ),
      ],
    );
  }
}
