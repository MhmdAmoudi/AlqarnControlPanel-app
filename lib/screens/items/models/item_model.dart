import 'dart:io';

import 'package:get/get.dart';

import '../../../service/current_datetime.dart';

class ItemModel {
  String id;
  String name;
  int quantity;
  File? mainImage;
  String createdAt;
  RxBool isActive;
  bool haveImage;

  ItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.createdAt,
    this.mainImage,
    required this.isActive,
    required this.haveImage,
  });

  static List<ItemModel> fromJson(List map) {
    return map
        .map((e) => ItemModel(
            id: e['id'],
            name: e['name'],
            quantity: e['quantity'],
            createdAt: getZoneDatetime(e['createdAt'])!,
            isActive: RxBool(e['isActive']),
            haveImage: e['haveImage']))
        .toList();
  }
}
