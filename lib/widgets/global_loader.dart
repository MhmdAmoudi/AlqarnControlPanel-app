import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({required this.child, Key? key})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayColor: Colors.black,
      overlayWidget: const Center(child: CircularProgressIndicator()),
      child: child,
    );
  }
}
