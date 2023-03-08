import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../service/current_datetime.dart';

class ChargeCardData {
  String? id;
  String card;
  int balance;
  double? price;
  String currency;
  String expireAt;
  RxBool? isActive;
  bool? used;

  ChargeCardData({
    this.id,
    required this.card,
    required this.balance,
    this.price,
    required this.currency,
    required this.expireAt,
    this.isActive,
    this.used,
  });

  static List<ChargeCardData> fromJson(List cardsMap) {
    return cardsMap
        .map((e) => ChargeCardData(
              id: e['id'],
              card: e['card'],
              balance: e['balance'],
              currency: e['currency'],
              expireAt: getZoneDatetime(e['expiryAt'])!,
              isActive: RxBool(e['isActive']),
              used: e['used'],
            ))
        .toList();
  }

  static List<Map<String, dynamic>> toJson(List<ChargeCardData> cards) {
    return cards
        .map((e) => {
              'card': e.card,
              'balance': e.balance,
              'price': e.price,
              'currencyId': e.currency,
              'expireAt': e.currency,
            })
        .toList();
  }
}
