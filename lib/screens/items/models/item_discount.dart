import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../service/current_datetime.dart';

class ItemDiscount {
  String? id;
  int percent;
  String endDatetime;
  String? coupon;
  RxBool isActive;
  RxBool? isSelect;

  ItemDiscount({
    this.id,
    required this.percent,
    required this.endDatetime,
    required this.coupon,
    required this.isActive,
    this.isSelect,
  });

  static List<ItemDiscount> fromJson(
      List map, [List? selectedDiscounts]) {
    if (selectedDiscounts == null) {
      return map
          .map((e) => ItemDiscount(
                id: e['id'],
                percent: e['percentage'],
                endDatetime: getZoneDatetime(e['endDatetime'])!,
                coupon: e['couponCode'],
                isActive: RxBool(e['isActive']),
              ))
          .toList();
    } else {
      return map
          .map((e) => ItemDiscount(
              id: e['id'],
              percent: e['percentage'],
              endDatetime: getZoneDatetime(e['endDatetime'])!,
              coupon: e['couponCode'],
              isActive: RxBool(e['isActive']),
              isSelect: RxBool(selectedDiscounts.contains(e['id']))))
          .toList();
    }
  }
}
