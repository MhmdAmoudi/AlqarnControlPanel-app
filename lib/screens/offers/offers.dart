import 'package:flutter/material.dart';

import '../../service/go_main_screen.dart';
import '../../widgets/drawer/menu_drawer.dart';

class Offers extends StatelessWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: goMainScreen,
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
