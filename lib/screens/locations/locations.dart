import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../service/go_main_screen.dart';
import '../../widgets/drawer/menu_drawer.dart';
import '../../widgets/error_handler.dart';
import '../../widgets/section_card.dart';
import 'controller/location_controller.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final LocationController controller = LocationController();
  @override
  void initState() {
    controller.getStatistics = controller.getItemStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: goMainScreen,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المواقع'),
          ),
          drawer: const MenuDrawer(),
          body: FutureBuilder(
            future: controller.getStatistics,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: controller.allLocations.length,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 150,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return SectionCard(
                      icon: controller.allLocations[index].icon,
                      label: controller.allLocations[index].name,
                      value: '${snapshot.data![index]}',
                      onTap: () => Get.to(() => controller.allLocations[index].page),
                    );
                  },
                );
              } else {
                return ErrorHandler(
                  error: snapshot.error,
                  onPressed: () {
                    setState(() {
                      controller.getStatistics = controller.getItemStatistics();
                    });
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
