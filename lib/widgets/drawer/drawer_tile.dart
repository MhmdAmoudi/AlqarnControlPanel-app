import 'package:flutter/material.dart';

import '../../../widgets/drawer/sections_drawer.dart';

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
    return ListTile(
      leading: Icon(MenuDrawer.selectedSectionIndex == index ? selectedIcon : unselectedIcon),
      title: Text(title),
      style: ListTileStyle.drawer,
      selected: MenuDrawer.selectedSectionIndex == index,
      onTap: () {
        MenuDrawer.selectedSectionIndex = index;
        onTap();
      },
    );
  }
}
