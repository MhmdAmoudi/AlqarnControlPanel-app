import 'dart:io';

import 'package:get/get.dart';

class CategoryData {
  String id;
  String name;
  File? image;
  int itemsCount;
  RxBool isActive;

  CategoryData({
    required this.id,
    required this.name,
    this.image,
    required this.itemsCount,
    required this.isActive,
  });

  static List<CategoryData> fromJson(List<dynamic> data) {
    List<CategoryData> categories = [];

    for (var category in data) {
      categories.add(
        CategoryData(
          id: category['id'],
          name: category['name'],
          itemsCount: category['itemsCount'],
          isActive: RxBool(category['isActive']),
        ),
      );
    }

    return categories;
  }
}
