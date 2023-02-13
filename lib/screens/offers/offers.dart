import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../widgets/drawer/sections_drawer.dart';
import '../home/home.dart';

class Offers extends StatelessWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.off(() => const Home());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('العروض'),
          ),
          drawer: const MenuDrawer(),
        ),
      ),
    );
  }
}
