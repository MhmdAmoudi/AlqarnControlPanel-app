import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/drawer/sections_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool exit = false;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (exit) {
            return true;
          } else {
            Fluttertoast.showToast(msg: 'اضغط مره أخرى للخروج');
            exit = true;
            Future.delayed(
              const Duration(seconds: 3),
              () {
                exit = false;
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
        ),
      ),
    );
  }
}
