import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Offer {
  String? id;
  TextEditingController category;
  TextEditingController min;
  TextEditingController max;
  RxBool isActive;
  List<OfferItem> items;
  List<String>? deletedItems;

  Offer({
    this.id,
    required this.category,
    required this.min,
    required this.max,
    required this.isActive,
    required this.items,
    this.deletedItems,
  });

  static List<Offer> fromJson(List map, [bool isEdited = false]) {
    if (isEdited) {
      return map
          .map((e) => Offer(
              id: e['id'],
              category: TextEditingController(text: e['category']),
              min: TextEditingController(text: '${e['min']}'),
              max: TextEditingController(text: '${e['max']}'),
              items: OfferItem.fromJson(e['items']),
              isActive: RxBool(e['isActive']),
              deletedItems: []))
          .toList();
    } else {
      return map
          .map((e) => Offer(
                id: e['id'],
                category: TextEditingController(text: e['category']),
                min: TextEditingController(text: '${e['min']}'),
                max: TextEditingController(text: '${e['max']}'),
                items: OfferItem.fromJson(e['items']),
                isActive: RxBool(e['isActive']),
              ))
          .toList();
    }
  }

  static List<Map<String, dynamic>> toJson(List<Offer> offers) {
    return offers
        .map((e) => {
              'id': e.id,
              'category': e.category.text.trim(),
              'min': int.parse(e.min.text),
              'max': int.parse(e.max.text),
              'items': OfferItem.toJson(e.items),
              'isActive': e.isActive.value,
            })
        .toList();
  }
}

class OfferItem {
  String? id;
  TextEditingController name;
  TextEditingController price;
  RxBool isActive;

  OfferItem({
    this.id,
    required this.name,
    required this.price,
    required this.isActive,
  });

  static List<OfferItem> fromJson(List map) {
    return map
        .map((e) => OfferItem(
              id: e['id'],
              name: TextEditingController(text: e['name']),
              price: TextEditingController(text: '${e['price']}'),
              isActive: RxBool(e['isActive']),
            ))
        .toList();
  }

  static List<Map<String, dynamic>> toJson(List<OfferItem> items) {
    return items
        .map((e) => {
              'id': e.id,
              'name': e.name.text.trim(),
              'price': double.parse(e.price.text),
              'isActive': e.isActive.value
            })
        .toList();
  }
}
