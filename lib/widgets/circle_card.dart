import 'package:flutter/material.dart';

import '../utilities/appearance/style.dart';

class CircleCard extends StatelessWidget {
  const CircleCard({
    required this.child,
    this.radius = 40,
    this.onTap,
    this.color,
    this.shadowColor = AppColors.mainColor,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final void Function()? onTap;
  final double radius;
  final Color? color;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius * 0.5,
            backgroundColor: shadowColor,
            child: Card(
              color: color,
              elevation: 2,
              shadowColor: shadowColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              child: SizedBox(height: radius, width: radius),
            ),
          ),
          child
        ],
      ),
    );
  }
}
