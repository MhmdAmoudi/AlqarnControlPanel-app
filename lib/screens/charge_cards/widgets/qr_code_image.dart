import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sizer/sizer.dart';

class QrCodeImage extends StatelessWidget {
  final String code;

  const QrCodeImage(this.code, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: PrettyQr(
          image: const AssetImage('asset/images/main_logo.png'),
          typeNumber: 1,
          size: 60.w,
          data: code,
          roundEdges: true,
        ),
      ),
    );
  }
}
