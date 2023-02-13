import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BottlePrice {
  String? id;
  String bottle;
  TextEditingController price;
  TextEditingController quantity;
  RxBool isMainBottle;
  RxBool isActive;

  BottlePrice({
    this.id,
    required this.bottle,
    required this.price,
    required this.quantity,
    required this.isMainBottle,
    required this.isActive,
  });

  static List<Map<String, dynamic>> toJson(List<BottlePrice> bottles) {
    return bottles
        .map((e) => {
              'id': e.id,
              'bottleId': e.bottle,
              'price': double.parse(e.price.text),
              'quantity': int.parse(e.quantity.text),
              'isMainBottle': e.isMainBottle.value,
              'isActive': e.isActive.value
            })
        .toList();
  }

  static List<BottlePrice> fromJson(
      List map, String Function(dynamic e) bottle) {
    return map
        .map(
          (e) => BottlePrice(
            id: e['id'],
            bottle: bottle(e),
            quantity: TextEditingController(text: '${e['quantity']}'),
            price: TextEditingController(text: '${e['price']}'),
            isMainBottle: RxBool(e['mainPrice']),
            isActive: RxBool(e['isActive']),
          ),
        )
        .toList();
  }
}
