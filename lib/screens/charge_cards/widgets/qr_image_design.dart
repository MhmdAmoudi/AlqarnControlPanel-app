import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrImageDesign extends StatelessWidget {
  final String code;
  final double size;

  const QrImageDesign({
    Key? key,
    required this.code,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(size * 0.05),
        child: PrettyQr(
          size: size,
          roundEdges: true,
          typeNumber: 3,
          data: code,
          image: const AssetImage('asset/images/qr_logo.png'),
        ),
      ),
    );
  }
}
