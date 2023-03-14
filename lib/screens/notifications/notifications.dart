import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../service/go_main_screen.dart';
import '../../widgets/drawer/menu_drawer.dart';
import '../home/home.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: goMainScreen,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الإعلانات'),
          ),
          drawer: const MenuDrawer(),
        ),
      ),
    );
  }
}
