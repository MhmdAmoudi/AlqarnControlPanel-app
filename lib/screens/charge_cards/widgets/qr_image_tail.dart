import 'package:flutter/material.dart';

import 'qr_image_info.dart';

class QrImageTail extends StatelessWidget {
  final double? size;
  final String balance;
  final String expireAt;

  const QrImageTail({
    Key? key,
    this.size,
    required this.balance,
    required this.expireAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ,
      child: Row(
        children: [
          QrImageInfo(label: expireAt, verticalPadding: 14),
          const SizedBox(width: 10),
          QrImageInfo(label: balance, verticalPadding: 10),
        ],
      ),
    );
  }
}
