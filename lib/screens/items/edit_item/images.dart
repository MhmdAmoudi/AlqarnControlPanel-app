import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/screens/items/controller/item_controller.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../utilities/appearance/style.dart';
import '../../../widgets/animated_snackbar.dart';
import '../../../widgets/download_image.dart';
import '../../../widgets/error_handler.dart';
import '../models/item_data.dart';
import '../views/requirement_widget.dart';

class EditImages extends StatefulWidget {
  const EditImages({
    required this.id,
    required this.name,
    required this.haveImage,
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  final bool haveImage;

  @override
  State<EditImages> createState() => _EditImagesState();
}

class _EditImagesState extends State<EditImages> {
  final API api = API('Item', withFile: true);

  late ImageData mainImage;
  late List<ImageData> images;
  List<String> deletedIds = [];
  RxInt currentIndex = RxInt(-1);
  late Future<bool> getImages;

  late RxBool haveImage;

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    getImages = getItemImages();
    mainImage = ImageData(
      id: widget.id,
      isMain: RxBool(true),
    );
    haveImage = RxBool(widget.haveImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل صور ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getImages,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                RequirementsWidget(
                  title: 'الصور',
                  icon: Icons.image_rounded,
                  requirement: Column(
                    children: [
                      Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(child: Text('الصورة الرئيسية')),
                                IconButton(
                                  onPressed: () async {
                                    XFile? file = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (file != null) {
                                      setState(() {
                                        haveImage.value = true;
                                        mainImage.id = null;
                                        mainImage.image = File(file.path);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.change_circle_rounded),
                                ),
                                if (haveImage.value)
                                  IconButton(
                                    onPressed: () async {
                                      mainImage.image = null;
                                      haveImage.value = false;
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                            Card(
                              color: AppColors.darkMainColor,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: haveImage.value
                                    ? DownloadImage(
                                        getImage: () {
                                          if (mainImage.image != null) {
                                            return Future(
                                                () => mainImage.image!);
                                          } else {
                                            return ItemController
                                                .getItemMainImage(widget.id);
                                          }
                                        },
                                        parent: (image) {
                                          mainImage.image = image;
                                          return Image.file(
                                            width: double.infinity,
                                            image,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Icon(Icons.hide_image_rounded),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text('الصور'),
                          Expanded(
                            child: Center(
                              child: Obx(
                                () => Text(
                                    '${currentIndex.value + 1} / ${images.length}'),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              List<XFile> files = await ImagePicker().pickMultiImage();
                              if (files.isNotEmpty) {
                                setState(() {
                                  for (var f in files) {
                                    images.add(ImageData(image: File(f.path)));
                                  }
                                  currentIndex(images.length - 1);
                                  carouselController.animateToPage(images.length);
                                });
                              }
                            },
                            icon: const Icon(Icons.add_circle_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (images[currentIndex.value].id != null) {
                                  deletedIds.add(images[currentIndex.value].id!);
                                }
                                images.removeAt(currentIndex.value);
                                if (currentIndex.value == images.length) {
                                  currentIndex.value -= 1;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        color: AppColors.darkMainColor,
                        child: CarouselSlider(
                          carouselController: carouselController,
                          items: List.generate(
                            images.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: DownloadImage(
                                getImage: () {
                                  if (images[index].image != null) {
                                    return Future(() => images[index].image!);
                                  } else {
                                    return ItemController.getItemImage(
                                        images[index].id!);
                                  }
                                },
                                parent: (image) {
                                  images[index].image = image;
                                  return Image.file(
                                    width: double.infinity,
                                    image,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            onPageChanged: (index, _) => currentIndex(index),
                            aspectRatio: 1 / 1,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: update, child: const Text('حفظ'))
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getImages = getItemImages();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> getItemImages() async {
    try {
      List data = await api.get('GetItemImages/${widget.id}');
      images = data.map((id) => ImageData(id: id)).toList();
      if (images.isNotEmpty) currentIndex(0);
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update() async {
    context.loaderOverlay.show();
    try {
      List<MultipartFile> imagesForm = [];
      for (var i in images) {
        if (i.id == null) {
          imagesForm.add(await MultipartFile.fromFile(i.image!.path));
        }
      }

      FormData form = FormData.fromMap({
        'id': widget.id,
        'haveImage': haveImage.value,
        if (haveImage.value && mainImage.id == null)
          'mainImage': await MultipartFile.fromFile(mainImage.image!.path),
        'images': imagesForm,
        'deleted': deletedIds,
      });
      await api.postFile('UpdateItemImages', data: form);
      context.loaderOverlay.hide();
      Get.back(result: haveImage.value);
      showSnackBar(message: 'تم التعديل بنجاح', type: AlertType.success);
    } on ResponseError catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
          title: 'فشل الإضافة', message: e.message, type: AlertType.failure);
    }
  }
}
