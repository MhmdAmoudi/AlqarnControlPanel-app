class NewEditedData {
  late final List<String> add;
  late final List<String> delete;

  NewEditedData({
    required List<String> oldItems,
    required List<String> newItems,
  }) {
    delete = oldItems.where((i) => !newItems.contains(i)).toList();
    add = newItems.where((i) => !oldItems.contains(i)).toList();
  }
}
