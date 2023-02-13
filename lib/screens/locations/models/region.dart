class Region {
  String? id;
  String name;
  double? deliveryFee;
  String? deliveryLong;
  bool isActive;

  Region({
    this.id,
    required this.name,
    required this.deliveryFee,
    required this.deliveryLong,
    required this.isActive,
  });

  static List<Region> fromJson(List map) {
    return map
        .map((e) => Region(
              id: e['id'],
              name: e['name'],
              deliveryFee: e['deliveryFee'],
              deliveryLong: e['deliveryLong'],
              isActive: e['isActive'],
            ))
        .toList();
  }
}
