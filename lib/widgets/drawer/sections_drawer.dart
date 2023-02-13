import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../api/api.dart';
import '../../screens/bottles/bottles.dart';
import '../../screens/items/items.dart';
import '../../screens/locations/locations.dart';
import '../../screens/notifications/notifications.dart';
import '../../screens/offers/offers.dart';
import '../../screens/orders/orders.dart';
import '../../screens/users/users_types.dart';
import '../../screens/categories/categories.dart';
import '../../screens/home/home.dart';
import '../../utilities/appearance/style.dart';
import '../circle_card.dart';
import 'drawer_tile.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  static int selectedSectionIndex = 0;

  static late String _name;
  static late String _username;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.darkMainColor,
        child: Column(
          children: [
            Expanded(
              child: DrawerHeader(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleCard(
                          radius: 9.h,
                          color: AppColors.darkMainColor,
                          child: Icon(
                            Icons.person_rounded,
                            color: AppColors.mainColor,
                            size: 5.h,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(_name),
                        Text(
                          _username,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                children: [
                  DrawerTile(
                    index: 0,
                    title: 'الرئيسية',
                    selectedIcon: Icons.home_rounded,
                    unselectedIcon: Icons.home_outlined,
                    onTap: () => Get.off(
                      () => const Home(),
                      transition: Transition.leftToRight,
                    ),
                  ),
                  DrawerTile(
                    index: 1,
                    title: 'الفئات',
                    selectedIcon: Icons.category_rounded,
                    unselectedIcon: Icons.category_outlined,
                    onTap: () => Get.off(() => const Categories(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 2,
                    title: 'المنتجات',
                    selectedIcon: Icons.shopping_bag_rounded,
                    unselectedIcon: Icons.shopping_bag_outlined,
                    onTap: () => Get.off(() => const Items(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 3,
                    title: 'الأحجام',
                    selectedIcon: Icons.battery_full_rounded,
                    unselectedIcon: Icons.battery_0_bar_outlined,
                    onTap: () => Get.off(() => const Bottles(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 4,
                    title: 'المواقع',
                    selectedIcon: Icons.home_work_rounded,
                    unselectedIcon: Icons.home_work_outlined,
                    onTap: () => Get.off(() => const Locations(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 5,
                    title: 'العروض',
                    selectedIcon: Icons.discount_rounded,
                    unselectedIcon: Icons.discount_outlined,
                    onTap: () => Get.off(() => const Offers(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 6,
                    title: 'المستخدمين',
                    selectedIcon: Icons.people_rounded,
                    unselectedIcon: Icons.people_outline,
                    onTap: () => Get.off(() => const UserTypes(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 7,
                    title: 'الإعلانات',
                    selectedIcon: Icons.notifications_on_rounded,
                    unselectedIcon: Icons.notifications_on_outlined,
                    onTap: () => Get.off(() => const Notifications(),
                        transition: Transition.leftToRight),
                  ),
                  DrawerTile(
                    index: 8,
                    title: 'العملات',
                    selectedIcon: Icons.monetization_on_rounded,
                    unselectedIcon: Icons.monetization_on_outlined,
                    onTap: () => Get.off(
                      () => const Home(),
                      transition: Transition.leftToRight,
                    ),
                  ),
                  DrawerTile(
                    index: 9,
                    title: 'الطلبات',
                    selectedIcon: Icons.list_rounded,
                    unselectedIcon: Icons.list_outlined,
                    onTap: () => Get.off(
                      () => const Orders(),
                      transition: Transition.leftToRight,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static void extractUserInfo() {
    var userInfoJson = json.decode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(API.token!.split('.')[1]),
        ),
      ),
    );
    _name = userInfoJson["Name"];
    _username = userInfoJson["UserName"];
  }
}
