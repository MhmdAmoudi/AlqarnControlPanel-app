import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ItemCategory {
  String? id;
  String name;
  bool isActive;
  RxBool? isSelect;

  ItemCategory({
    this.id,
    required this.name,
    required this.isActive,
    this.isSelect,
  });

  static List<ItemCategory> fromJson(List map, List selected) {
    return map
        .map((e) => ItemCategory(
            id: e['id'],
            name: e['name'],
            isActive: e['isActive'],
            isSelect: RxBool(selected.contains(e['id']))))
        .toList();
  }
}
