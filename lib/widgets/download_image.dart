import 'dart:io';

import 'package:flutter/material.dart';

class DownloadImage extends StatefulWidget {
  const DownloadImage({
    required this.parent,
    required this.getImage,
    this.size = 40,
    this.loadingSize = 15,
    this.strokeWidth = 2,
    Key? key,
  }) : super(key: key);
  final Future<File> Function() getImage;
  final double size;
  final double loadingSize;
  final double strokeWidth;
  final Widget Function(File image) parent;

  @override
  State<DownloadImage> createState() => _DownloadImageState();
}

class _DownloadImageState extends State<DownloadImage> {
  late Future<File> getImage;

  File? file;

  @override
  void initState() {
    getImage = widget.getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return file != null
        ? widget.parent(file!)
        : FutureBuilder(
            future: getImage,
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: Center(
                    child: SizedBox(
                      height: widget.loadingSize,
                      width: widget.loadingSize,
                      child: CircularProgressIndicator(
                          strokeWidth: widget.strokeWidth),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                file = snapshot.data!;
                return widget.parent(snapshot.data!);
              } else if (snapshot.error == null) {
                return const Icon(Icons.image_rounded);
              } else {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      getImage = widget.getImage();
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                );
              }
            },
          );
  }
}
