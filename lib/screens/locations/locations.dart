import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:manage/utilities/appearance/style.dart';

import '../../api/api.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/error_handler.dart';
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
    AllLocations(name: 'الدول', trailing: 'دولة', page: const Countries()),
    AllLocations(
        name: 'المحافظات', trailing: 'محافظة', page: const Countries()),
    AllLocations(name: 'المدن', trailing: 'مدينة', page: const Countries()),
    AllLocations(name: 'المناطق', trailing: 'منطقة', page: const Countries()),
    AllLocations(name: 'الفروع', trailing: 'فرع', page: const Countries()),
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
                return ListView.builder(
                  itemCount: allLocations.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: AppColors.darkSubColor,
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${index + 1}'),
                          ],
                        ),
                        title: Text(allLocations[index].name),
                        trailing: RichText(
                          text: TextSpan(
                            text: '${snapshot.data![index]} ',
                            children: [
                              TextSpan(
                                text: allLocations[index].trailing,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        onTap: () => Get.to(() => allLocations[index].page),
                      ),
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
