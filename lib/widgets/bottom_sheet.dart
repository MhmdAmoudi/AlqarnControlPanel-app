import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utilities/appearance/style.dart';

Future showGetBottomSheet({
  required String title,
  required List<Widget> children,
  bool isDismissible = true,
  EdgeInsetsGeometry padding = const EdgeInsets.all(10),
}) {
  return Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 90.h),
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.subColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: padding,
                children: children,
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    isDismissible: isDismissible,
  );
}
