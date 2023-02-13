import 'dart:io';

class Country {
  String? id;
  File? image;
  String name;
  String symbol;
  String code;
  bool haveImage;
  bool isActive;

  Country({
    required this.id,
    this.image,
    required this.name,
    required this.symbol,
    required this.code,
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
              haveImage: e['haveImage'],
              isActive: e['isActive'],
            ))
        .toList();
  }
}
