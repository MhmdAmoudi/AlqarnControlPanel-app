import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/current_datetime.dart';

class OrderView {
  String id;
  String recipient;
  String number;
  String datetime;
  int quantity;
  String receiveType;
  String location;
  String? locationDescription;
  double total;
  String currency;
  OrderBillItem? bill;
  bool isOpen;
  RxBool loadingBill;
  int status;

  OrderView({
    required this.id,
    required this.recipient,
    required this.number,
    required this.datetime,
    required this.quantity,
    required this.receiveType,
    required this.location,
    required this.locationDescription,
    required this.total,
    required this.currency,
    required this.isOpen,
    required this.loadingBill,
    required this.status,
    this.bill,
  });

  static Future<List<OrderView>> fromJson(List<dynamic> ordersMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<OrderView> orders = [];
    for (var order in ordersMap) {
      orders.add(
        OrderView(
            id: order['id'],
            recipient: order['recipient'],
            number: order['number'],
            datetime: getZoneDatetime(order['datetime'])!,
            quantity: order['quantity'],
            receiveType: order['branch'] == null ? 'توصيل' : 'استلام من فرع',
            location: order['region'] ?? order['branch'],
            locationDescription: order['locationDescription'],
            total: order['total'],
            currency: order['symbol'],
            status: order['status'],
            isOpen: false,
            loadingBill: RxBool(false)),
      );
    }
    if(ordersMap.isNotEmpty) {
      prefs.setString('lastOrderSeen', ordersMap.first['datetime']);
    }
    return orders;
  }
}

class OrderBillItem {
  double? deliveryFee;
  List<OrderViewItem> items;
  int offerItemsQuantity;
  double offerItemsTotal;

  OrderBillItem({
    required this.deliveryFee,
    required this.items,
    required this.offerItemsQuantity,
    required this.offerItemsTotal,
  });

  static OrderBillItem fromJson(Map<String, dynamic> billMap) {
    return OrderBillItem(
      deliveryFee: billMap['deliveryFee'],
      items: OrderViewItem.fromJson(billMap['orderItems']),
      offerItemsQuantity: billMap['offersCount'],
      offerItemsTotal: billMap['offersTotal'],
    );
  }
}

class OrderViewItem {
  String name;
  int quantity;
  double total;

  OrderViewItem({
    required this.name,
    required this.quantity,
    required this.total,
  });

  static List<OrderViewItem> fromJson(List<dynamic> itemsMap) {
    List<OrderViewItem> items = [];

    for (var item in itemsMap) {
      items.add(
        OrderViewItem(
          name: item['name'],
          quantity: item['quantity'],
          total: item['total'],
        ),
      );
    }

    return items;
  }
}

class OrderStatus {
  static Color color(int status) {
    switch (status) {
      case (0):
        return Colors.redAccent;
      case 1:
        return Colors.teal;
      case 2:
        return Colors.yellow;
      default:
        return Colors.orange;
    }
  }

  static Icon icon(int status) {
    switch (status) {
      case 0:
        return const Icon(
          Icons.cancel_outlined,
          color: Colors.redAccent,
          size: 35,
        );
      case 1:
        return const Icon(
          Icons.check_circle_outline,
          color: Colors.teal,
          size: 35,
        );
      case 2:
        return const Icon(
          Icons.delivery_dining_outlined,
          color: Colors.yellow,
          size: 35,
        );
      default:
        return const Icon(
          Icons.access_time,
          color: Colors.orange,
          size: 35,
        );
    }
  }

  static String label(int status) {
    switch (status) {
      case 0:
        return 'ملغي';
      case 1:
        return 'تم الإستلام';
      case 2:
        return 'جار التوصيل';
      default:
        return 'جار المعالجة';
    }
  }
}
