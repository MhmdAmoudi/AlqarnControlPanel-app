import 'package:flutter/material.dart';
import 'package:manage/screens/charge_cards/controllers/charge_card_controller.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sizer/sizer.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class QrCodeImage extends StatelessWidget {
  final String code;

  const QrCodeImage(this.code, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsToImage(
      controller: ChargeCardController.controller,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: PrettyQr(
            size: 60.w,
            roundEdges: true,
            typeNumber: 3,
            data: code,
            image: const AssetImage('asset/images/qr_logo.png'),
          ),
        ),
      ),
    );
  }
}
