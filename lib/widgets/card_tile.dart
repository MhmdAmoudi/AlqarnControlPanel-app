import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'animated_snackbar.dart';
import 'custom_alert_dialog.dart';

class CardTile extends StatelessWidget {
  CardTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    required this.isActive,
    this.onTap,
    required this.onEditPressed,
    this.onDeletePressed,
    this.onActivePressed,
    this.trailing,
  }) {
    if (onDeletePressed == null) {
      extentRatio = 0.3;
    } else {
      extentRatio = 0.5;
    }
  }

  final Widget leading;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final RxBool isActive;
  final void Function()? onTap;
  final void Function() onEditPressed;
  final void Function()? onDeletePressed;
  final void Function(bool)? onActivePressed;
  final Widget? trailing;
  late final double extentRatio;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Slidable(
        useTextDirection: false,
        startActionPane: onActivePressed != null
            ? ActionPane(
                extentRatio: 0.3,
                motion: const DrawerMotion(),
                children: [
                  Obx(() => isActive.value
                      ? SlidableAction(
                          onPressed: (_) {
                            CustomAlertDialog.show(
                                animation: true,
                                type: AlertType.question,
                                title: 'هل ترغب بإلغاء تفعيل $title؟',
                                showCancelButton: true,
                                confirmBackgroundColor: Colors.red,
                                confirmText: 'إلغاء التفعيل',
                                onConfirmPressed: () async {
                                  Get.back();
                                  onActivePressed!(isActive.value);
                                });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.cancel_rounded,
                          label: 'إلغاء التفعيل',
                        )
                      : SlidableAction(
                          onPressed: (_) {
                            CustomAlertDialog.show(
                                animation: true,
                                type: AlertType.question,
                                title: 'هل ترغب بتفعيل $title؟',
                                showCancelButton: true,
                                confirmBackgroundColor: Colors.green,
                                confirmText: 'تفعيل',
                                onConfirmPressed: () async {
                                  Get.back();
                                  onActivePressed!(isActive.value);
                                });
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check_circle_rounded,
                          label: 'تفعيل',
                        )),
                ],
              )
            : null,
        endActionPane: ActionPane(
          extentRatio: extentRatio,
          motion: const DrawerMotion(),
          children: [
            if (onDeletePressed != null)
              SlidableAction(
                onPressed: (_) {
                  CustomAlertDialog.show(
                      animation: true,
                      type: AlertType.question,
                      title: 'هل ترغب بحذف $title؟',
                      showCancelButton: true,
                      confirmText: 'حذف',
                      confirmBackgroundColor: Colors.red,
                      onConfirmPressed: () async {
                        Get.back();
                        onDeletePressed!();
                      });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_rounded,
                label: 'حذف',
              ),
            SlidableAction(
              onPressed: (_) => onEditPressed(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'تعديل',
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
            ],
          ),
          title: Text(title),
          subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null) ...[
                trailing!,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '|',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
              Obx(
                () => isActive.value
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
