import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'qr_image_design.dart';
import 'qr_image_tail.dart';

class QrCodeImage extends StatelessWidget {
  final WidgetsToImageController qrCodeController;
  final String code;
  final String balance;
  final String expireAt;

  const QrCodeImage({
    Key? key,
    required this.qrCodeController,
    required this.code,
    required this.balance,
    required this.expireAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsToImage(
      controller: qrCodeController,
      child: Column(
        children: [
          QrImageDesign(
            code: code,
            size: 60.w,
          ),
          QrImageTail(
            size: 60.w + 20,
            balance: balance,
            expireAt: expireAt,
          )
        ],
      ),
    );
  }
}
