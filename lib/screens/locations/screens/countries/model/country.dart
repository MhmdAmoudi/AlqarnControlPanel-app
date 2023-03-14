import 'dart:io';

import 'package:get/get.dart';

class Country {
  String? id;
  File? image;
  String name;
  String symbol;
  String code;
  int counties;
  bool haveImage;
  RxBool isActive;

  Country({
    required this.id,
    this.image,
    required this.name,
    required this.symbol,
    required this.code,
    required this.counties,
    required this.haveImage,
    required this.isActive,
  });

  static List<Country> fromJson(List map) {
    return map
        .map((e) => Country(
              id: e['id'],
              name: e['name'],
              symbol: e['symbol'],
              code: e['code'],
              counties: e['counties'],
              haveImage: e['haveImage'],
              isActive: RxBool(e['isActive']),
            ))
        .toList();
  }
}
