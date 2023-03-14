import 'package:get/route_manager.dart';

import '../screens/home/home.dart';
import '../widgets/drawer/menu_drawer.dart';

Future<bool> goMainScreen() async {
  MenuDrawer.selectedSectionIndex = 0;
  Get.off(() => const Home());
  return false;
}
