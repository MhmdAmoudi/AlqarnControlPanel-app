import 'package:flutter/material.dart';

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
        return 'جار التسليم';
      default:
        return 'جار المعالجة';
    }
  }
}