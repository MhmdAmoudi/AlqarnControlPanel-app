import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AddRequirement {
  String? id;
  String name;

  AddRequirement({required this.id, required this.name});

  static List<DropdownMenuItem<String>> fromJson(List map) {
    return map
        .map((e) => DropdownMenuItem<String>(
              value: e['id'],
              child: Text(e['name']),
            ))
        .toList();
  }
}

class Location extends AddRequirement {
  String data;
  String parentId;
  String? deliveryLong;
  double? deliveryFee;
  RxBool isActive;
  RxBool loading;

  Location({
    super.id,
    required super.name,
    required this.data,
    required this.parentId,
    required this.deliveryLong,
    required this.deliveryFee,
    required this.isActive,
    required this.loading,
  });

  static List<Location> fromJson(List map) {
    return map
        .map((e) => Location(
              id: e['id'],
              name: e['name'],
              parentId: e['parent'],
              data: '${e['data']}',
              deliveryLong: e['deliveryLong'],
              deliveryFee: e['deliveryFee'],
              isActive: RxBool(e['isActive']),
              loading: RxBool(false),
            ))
        .toList();
  }
}
