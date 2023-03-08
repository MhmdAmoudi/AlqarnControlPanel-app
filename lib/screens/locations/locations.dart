import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../api/api.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/error_handler.dart';
import '../../widgets/section_card.dart';
import '../home/home.dart';
import 'countries.dart';
import 'models/all_locatons.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final API api = API('Location');

  final List<AllLocations> allLocations = [
    AllLocations(
      icon: Icons.flag_circle_outlined,
      name: 'الدول',
      page: const Countries(),
    ),
    AllLocations(
      icon: Icons.flag_outlined,
      name: 'المحافظات',
      page: const Countries(),
    ),
    AllLocations(
      icon: Icons.location_city_outlined,
      name: 'المدن',
      page: const Countries(),
    ),
    AllLocations(
      icon: Icons.location_on_outlined,
      name: 'المناطق',
      page: const Countries(),
    ),
    AllLocations(
      icon: Icons.storefront_outlined,
      name: 'الفروع',
      page: const Countries(),
    ),
  ];

  late Future<List> getStatistics;

  @override
  void initState() {
    getStatistics = getItemStatistics();
    super.initState();
  }

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
            title: const Text('المواقع'),
          ),
          drawer: const MenuDrawer(),
          body: FutureBuilder(
            future: getStatistics,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: allLocations.length,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 150,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    return SectionCard(
                      icon: allLocations[index].icon,
                      label: allLocations[index].name,
                      value: '${snapshot.data![index]}',
                      onTap: () => Get.to(() => allLocations[index].page),
                    );
                  },
                );
              } else {
                return ErrorHandler(
                  error: snapshot.error,
                  onPressed: () {
                    setState(() {
                      getStatistics = getItemStatistics();
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

  Future<List> getItemStatistics() async {
    try {
      return await api.get('LocationStatistics');
    } catch (_) {
      rethrow;
    }
  }
}
