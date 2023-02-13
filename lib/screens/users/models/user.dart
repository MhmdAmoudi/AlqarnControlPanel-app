import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../service/current_datetime.dart';

class User {
  String id;
  String name;
  String username;
  String? verifiedAt;
  bool isVerified;
  RxBool isActive;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.verifiedAt,
    required this.isVerified,
    required this.isActive,
  });

  static List<User> fromJson(List map) {
    return map
        .map((e) => User(
              id: e['id'],
              name: e['name'],
              username: e['username'],
              verifiedAt: getZoneDatetime(e['verifiedAt']),
              isVerified: e['verifiedAt'] != null,
              isActive: RxBool(e['isActive']),
            ))
        .toList();
  }
}
