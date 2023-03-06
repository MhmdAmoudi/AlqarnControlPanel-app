import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/drawer/sections_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static bool _exit = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_exit) {
            return true;
          } else {
            Fluttertoast.showToast(msg: 'اضغط مره أخرى للخروج');
            _exit = true;
            Future.delayed(
              const Duration(seconds: 3),
              () {
                _exit = false;
              },
            );
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الرئيسية'),
          ),
          drawer: const MenuDrawer(),
          body: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}
