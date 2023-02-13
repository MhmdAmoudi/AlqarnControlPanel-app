import 'package:flutter/material.dart';

import 'item_discount.dart';


class ItemRequirements {
  String currency;
  List<DropdownMenuItem<String>> bottles;
  List<ItemDiscount> discounts;
  List<ItemDiscount> coupons;

  ItemRequirements({
    required this.currency,
    required this.bottles,
    required this.discounts,
    required this.coupons,
  });

  static ItemRequirements fromJson(Map<String, dynamic> map) {
    List<ItemDiscount> discounts = ItemDiscount.fromJson(map['discounts'], []);
    return ItemRequirements(
      currency: map['currency'],
      bottles: List.from(map['bottles'])
          .map((e) => DropdownMenuItem(
                value: e['id'] as String,
                child: Text(e['name'] +
                    (e['isActive'] != null
                        ? e['isActive']
                            ? ' (مفعل)'
                            : ' (موقف)'
                        : '')),
              ))
          .toList(),
      discounts: discounts.where((e) => e.coupon == null).toList(),
      coupons: discounts.where((e) => e.coupon != null).toList(),
    );
  }
}
