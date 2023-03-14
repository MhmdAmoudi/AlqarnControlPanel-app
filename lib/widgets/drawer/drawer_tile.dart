import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:manage/utilities/appearance/style.dart';

import '../../../widgets/drawer/menu_drawer.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.index,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final int index;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MenuDrawer.selectedSectionIndex == index
          ? AppColors.mainColor
          : AppColors.darkMainColor,
      child: ListTile(
        leading: Icon(MenuDrawer.selectedSectionIndex == index
            ? selectedIcon
            : unselectedIcon),
        title: Text(title),
        style: ListTileStyle.drawer,
        onTap: () {
          if (MenuDrawer.selectedSectionIndex == index) {
            Get.back();
          } else {
            MenuDrawer.selectedSectionIndex = index;
            onTap();
          }
        },
      ),
    );
  }
}
