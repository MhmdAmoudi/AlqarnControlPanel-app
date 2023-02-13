import 'package:flutter/material.dart';

import '../utilities/appearance/style.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final String value;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: AppColors.mainColor,
              ),
              const SizedBox(height: 5),
              Card(
                color: AppColors.darkMainColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: Text(value, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
