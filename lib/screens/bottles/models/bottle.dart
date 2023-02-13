import 'package:get/get.dart';

class Bottle {
  String id;
  int size;
  String unit;
  int itemsCount;
  RxBool isActive;

  Bottle({
    required this.id,
    required this.size,
    required this.unit,
    required this.itemsCount,
    required this.isActive,
  });

  static List<Bottle> fromJson(List bottlesMap) {
    return bottlesMap.map(
      (b) => Bottle(
        id: b['id'],
        size: b['size'],
        unit: b['unit'],
        itemsCount: b['itemsCount'],
        isActive: RxBool(b['isActive']),
      ),
    ).toList();
  }
}
