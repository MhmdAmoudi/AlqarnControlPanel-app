import 'package:flutter/material.dart';
import 'package:manage/api/response_error.dart';

class ErrorHandler extends StatelessWidget {
  const ErrorHandler({
    Key? key,
    required this.error,
    required this.onPressed,
  }) : super(key: key);
  final dynamic error;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  error is ResponseError ? error.error : '000 - حصل خطأ ما ',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
