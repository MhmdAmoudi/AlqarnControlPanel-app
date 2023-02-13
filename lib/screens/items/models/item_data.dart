import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../offers/models/offer.dart';
import 'bottle_price.dart';
import 'item_discount.dart';
import 'more_detail.dart';

class ItemData {
  String currency;
  String? description;
  List<MoreDetail> details;
  List<MoreDetail> belongings;
  List<Offer> offers;
  List<ImageData> images;
  List<BottlePrice> bottles;
  List<ItemDiscount> discounts;
  List<ItemDiscount> coupons;
  bool isActive;

  ItemData({
    required this.currency,
    required this.description,
    required this.details,
    required this.belongings,
    required this.offers,
    required this.bottles,
    required this.discounts,
    required this.coupons,
    required this.images,
    required this.isActive,
  });

  static ItemData fromJson(Map map) {
    List<MoreDetail> details = MoreDetail.fromJson(map['moreDetails']);
    List<ItemDiscount> discounts = ItemDiscount.fromJson(map['discounts']);

    return ItemData(
      currency: map['currency'],
      description: map['description'],
      bottles: BottlePrice.fromJson(
        map['bottles'],
        (e) => "${e['size']} ${e['unit']}",
      ),
      details: details.where((d) => d.type == 2).toList(),
      belongings: details.where((d) => d.type == 1).toList(),
      discounts: discounts.where((d) => d.coupon == null).toList(),
      coupons: discounts.where((d) => d.coupon != null).toList(),
      images: ImageData.fromJson(map['images']),
      offers: Offer.fromJson(map['offers']),
      isActive: map['isActive'],
    );
  }
}

class ImageData {
  String? id;
  File? image;
  RxBool? isMain;

  ImageData({this.id, this.image, this.isMain});

  static List<ImageData> fromJson(List map) {
    return map.map((id) => ImageData(id: id, isMain: RxBool(false))).toList();
  }
}
