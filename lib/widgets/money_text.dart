import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

import '../utilities/appearance/style.dart';

class MoneyTextStyle extends StatelessWidget {
  const MoneyTextStyle({
    required this.price,
    this.currency,
    this.offerPercent,
    this.oldPrice,
    this.fontSize = 18,
    this.color = AppColors.mainColor,
    this.showOldPrice = true,
    Key? key,
  }) : super(key: key);

  final double price;
  final String? currency;
  final int? offerPercent;
  final double? oldPrice;
  final double fontSize;
  final Color? color;
  final bool showOldPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (offerPercent != null && showOldPrice)
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: AutoSizeText.rich(
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
                fontSize: fontSize * 0.7,
                decoration: TextDecoration.lineThrough,
              ),
              TextSpan(
                children: [
                  TextSpan(text: '${oldPrice!.toMoneyFormat}.'),
                  TextSpan(
                    text: oldPrice!.fractionDigitsOnlyFixed2,
                    style: TextStyle(fontSize: fontSize * 0.5),
                  ),
                  TextSpan(text: ' $currency'),
                ],
              ),
            ),
          ),
        AutoSizeText.rich(
          maxLines: 1,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
          TextSpan(
            children: [
              TextSpan(text: '${price.toMoneyFormat}.'),
              TextSpan(
                text: price.fractionDigitsOnlyFixed2,
                style: TextStyle(fontSize: fontSize * 0.7),
              ),
              if (currency != null) TextSpan(text: ' $currency'),
            ],
          ),
        ),
      ],
    );
  }
}

extension PriceText on double {
  String get toMoneyFormat => MoneyFormatter(
        amount: this,
        settings: MoneyFormatterSettings(
          symbol: '',
          fractionDigits: 0,
        ),
      ).output.nonSymbol;

  String get fractionDigitsOnlyFixed2 => toStringAsFixed(2).split('.').last;
}
