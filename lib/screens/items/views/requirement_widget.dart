import 'package:flutter/material.dart';

import '../../../utilities/appearance/style.dart';

class RequirementsWidget extends StatelessWidget {
  const RequirementsWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.requirement,
    this.onAddPressed,
    this.trailing,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final void Function()? onAddPressed;
  final Widget requirement;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: AppColors.mainColor),
                        const SizedBox(width: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (onAddPressed != null)
                      InkWell(
                        onTap: onAddPressed,
                        child: const Icon(
                          Icons.add_circle_rounded,
                          color: AppColors.mainColor,
                        ),
                      )
                    else if (trailing != null)
                      Text(trailing!)
                  ],
                ),
                const Divider(height: 15),
                const SizedBox(height: 5),
                requirement,
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
