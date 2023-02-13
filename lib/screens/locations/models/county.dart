class County {
  String? id;
  String name;
  String? location;
  bool isActive;

  County({
    this.id,
    required this.name,
    this.location,
    required this.isActive,
  });

  static List<County> fromJson(List map) {
    return map
        .map((e) => County(
              id: e['id'],
              name: e['name'],
              location: e['location'],
              isActive: e['isActive'],
            ))
        .toList();
  }
}
