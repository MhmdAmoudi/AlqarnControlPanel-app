import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:manage/screens/users/users.dart';
import 'package:manage/widgets/section_card.dart';

import '../../api/api.dart';
import '../../service/go_main_screen.dart';
import '../../widgets/drawer/menu_drawer.dart';
import '../../widgets/error_handler.dart';

class UserTypes extends StatefulWidget {
  const UserTypes({Key? key}) : super(key: key);

  @override
  State<UserTypes> createState() => _UserTypesState();
}

class _UserTypesState extends State<UserTypes> {
  final API api = API('User');
  late Future<List> getUsersCount;

  @override
  void initState() {
    getUsersCount = getAllUsersCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: goMainScreen,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المستخدمين'),
          ),
          drawer: const MenuDrawer(),
          body: FutureBuilder(
            future: getUsersCount,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SectionCard(
                          icon: Icons.support_agent_rounded,
                          value: '${snapshot.data!.first}',
                          label: 'المسؤولين',
                          onTap: () => Get.to(() => const Users(title: 'المسؤولين', type: 'admin')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SectionCard(
                          icon: Icons.people_alt_rounded,
                          value: '${snapshot.data![1]}',
                          label: 'المستخدمين',
                          onTap: () => Get.to(() => const Users(title: 'المستخدمين', type: 'user')),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ErrorHandler(
                  error: snapshot.error,
                  onPressed: () {
                    setState(() {
                      getUsersCount = getAllUsersCount();
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

  Future<List> getAllUsersCount() async {
    try {
      return await api.get('GetUsersCount');
    } catch (_) {
      rethrow;
    }
  }
}
