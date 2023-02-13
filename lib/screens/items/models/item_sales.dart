import 'dart:ui';

import '../../../service/order_status.dart';

class ItemSales {
  int quantity;
  double total;
  String currency;
  String state;
  Color color;

  ItemSales({
    required this.quantity,
    required this.total,
    required this.currency,
    required this.state,
    required this.color,
  });

  static List<ItemSales> fromJson(List map) {
    return map
        .map(
          (e) => ItemSales(
            quantity: e['quantity'],
            total: e['total'],
            currency: e['currency'],
            state: OrderStatus.label(e['state']),
            color: OrderStatus.color(e['state']),
          ),
        )
        .toList();
  }
}
