import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../api/api.dart';
import '../models/item_category.dart';
import '../models/item_data.dart';

class ItemController {
  static final API _api = API('Item', isFile: true);

  List<ItemCategory> categories = [];

  static Icon getActiveState({
    required bool isActive,
    Color? activeColor,
    bool unSelectedIcon = false,
  }) {
    if (isActive) {
      return Icon(
        Icons.check_circle_rounded,
        color: activeColor ?? Colors.green,
        size: 20,
      );
    } else if (unSelectedIcon) {
      return const Icon(
        Icons.circle_outlined,
        size: 20,
      );
    } else {
      return const Icon(
        Icons.cancel_rounded,
        color: Colors.red,
        size: 20,
      );
    }
  }

  static Future<File> getItemMainImage(String id) async {
    try {
      var data = await _api.getFile('GetItemMainImage/$id');
      String tempPath = (await getTemporaryDirectory()).path;
      return await File('$tempPath/$id').writeAsBytes(
        base64Decode(data),
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<ItemData> getItem(String id) async {
    try {
      var data = await _api.get('GetItem/$id');
      for (var c in data['categories']) {
        categories.add(ItemCategory(name: c['name'], isActive: c['isActive']));
      }
      return ItemData.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }

  static Future<File> getItemImage(String id) async {
    try {
      var data = await _api.get('getItemImage/$id');
      String tempPath = (await getTemporaryDirectory()).path;
      return await File('$tempPath/$id').writeAsBytes(
        base64Decode(data),
      );
    } catch (_) {
      rethrow;
    }
  }
}
