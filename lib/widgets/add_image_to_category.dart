import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddImageToCategory extends StatelessWidget {
  final Rx<File?> image;
  bool isImageEdited;
  bool imageDeleted;

  AddImageToCategory({
    Key? key,
    required this.image,
    required this.isImageEdited,
    required this.imageDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        XFile? file =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (file != null) {
          image(File(file.path));
          isImageEdited = true;
        }
      },
      child: Obx(
        () => image.value == null
            ? const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.add_rounded,
                  size: 30,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(image.value!),
                  ),
                  IconButton(
                    onPressed: () {
                      imageDeleted = true;
                      image.value = null;
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
