import 'package:flutter/material.dart';

class QrImageInfo extends StatelessWidget {
  final String label;
  final double verticalPadding;

  const QrImageInfo(
      {Key? key, required this.label, required this.verticalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 10.0, vertical: verticalPadding),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
