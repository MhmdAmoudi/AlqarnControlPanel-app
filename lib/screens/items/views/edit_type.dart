import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utilities/appearance/style.dart';

class EditType extends StatelessWidget {
  const EditType({
    Key? key,
    required this.icon,
    required this.name,
    this.page,
    this.color = AppColors.mainColor,
    this.onTap,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final Widget? page;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(name),
        onTap: onTap ?? () => Get.to(() => page!),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
