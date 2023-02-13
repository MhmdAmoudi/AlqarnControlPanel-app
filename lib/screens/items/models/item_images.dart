import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ItemImage {
  File image;
  RxBool isMain;

  ItemImage({required this.image, required this.isMain});

  static Future<List<MultipartFile>> toForm(List<ItemImage> images) async {
    List<MultipartFile> imagesForm = [];
    for (var i in images) {
      imagesForm.add(await MultipartFile.fromFile(i.image.path));
    }
    return imagesForm;
  }
}
