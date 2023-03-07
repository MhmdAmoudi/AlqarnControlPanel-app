import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/animated_snackbar.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/card_tile.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/download_image.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/error_handler.dart';
import '../home/home.dart';
import 'controller/category_controller.dart';
import 'model/category_data.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryController controller = CategoryController();

  final RxBool loading = RxBool(false);

  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();

  late Future<bool> getCategories;

  @override
  void initState() {
    getCategories = controller.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.off(() => const Home());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الفئات'),
            actions: [
              IconButton(
                onPressed: () {
                  manageCategorySheet(
                    title: 'إضافة فئة',
                    buttonText: 'إضافة',
                    onPressed: (name, image, _) async {
                      String? id = await controller.addCategory(name, image);
                      if (id != null) {
                        setState(() {
                          controller.categories.add(
                            CategoryData(
                              id: id,
                              name: name,
                              itemsCount: 0,
                              isActive: RxBool(true),
                              hasImage: image != null,
                            ),
                          );
                        });
                      }
                    },
                  );
                },
                icon: const Icon(Icons.add_rounded),
              )
            ],
          ),
          drawer: const MenuDrawer(),
          body: FutureBuilder(
            future: getCategories,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(15),
                  children: List.generate(
                      controller.categories.length,
                      (index) => CardTile(
                            leading: controller.categories[index].hasImage
                                ? DownloadImage(
                                    getImage: () {
                                      return controller.getCategoryImage(
                                          controller.categories[index].id);
                                    },
                                    parent: (image) {
                                      controller.categories[index].image =
                                          image;
                                      return CircleAvatar(
                                        backgroundImage: FileImage(image),
                                      );
                                    },
                                  )
                                : const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('asset/icons/alqaren.png'),
                                  ),
                            title: controller.categories[index].name,
                            subtitle:
                                '${controller.categories[index].itemsCount} منتج',
                            isActive: controller.categories[index].isActive,
                            onTap: () {},
                            onEditPressed: () async {
                              manageCategorySheet(
                                title: 'تعديل فئة',
                                buttonText: 'تعديل',
                                cName: controller.categories[index].name,
                                cImage: controller.categories[index].image,
                                onPressed: (name, image, imageDeleted) async {
                                  bool updated =
                                      await controller.updateCategory(
                                          category:
                                              controller.categories[index],
                                          name: name,
                                          image: image,
                                          imageDeleted: imageDeleted);
                                  if (updated) {
                                    setState(() {
                                      controller.categories[index].name = name;
                                      controller.categories[index].image = image;
                                      controller.categories[index].hasImage = image != null;
                                    });
                                  }
                                },
                              );
                            },
                            onDeletePressed: () async {
                              bool deleted = await controller
                                  .deleteCategory(controller.categories[index]);
                              if (deleted) {
                                setState(() {
                                  controller.categories.removeAt(index);
                                });
                              }
                            },
                            onActivePressed: (state) async {
                              controller.categories[index].isActive.value =
                                  await controller.changeState(
                                      controller.categories[index].id, !state);
                            },
                          )),
                );
              } else {
                return ErrorHandler(
                  error: snapshot.error,
                  onPressed: () {
                    setState(() {
                      getCategories = controller.getCategories();
                    });
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void manageCategorySheet({
    required String title,
    required String buttonText,
    required Future Function(String, File?, bool imageDeleted) onPressed,
    String? cName,
    File? cImage,
  }) {
    final TextEditingController name = TextEditingController();
    Rx<File?> image = Rx<File?>(cImage);
    bool isImageEdited = cName == null;
    bool imageDeleted = false;
    name.text = cName ?? '';

    showGetBottomSheet(
      title: title,
      children: [
        GestureDetector(
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
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: nameKey,
            child: CustomTextFormField(
              controller: name,
              hintText: 'اسم الفئة',
              prefixIcon: Icons.title_rounded,
              validator: (val) {
                if (val!.trim().isEmpty) {
                  return 'ادخل اسم الفئة';
                }
                return null;
              },
            ),
          ),
        ),
        Obx(
          () => loading.value
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (nameKey.currentState!.validate()) {
                      CustomAlertDialog.show(
                        type: AlertType.question,
                        title:
                            'هل ترغب حقاً ب$buttonText الفئة ${name.text.trim()}؟',
                        onConfirmPressed: () async {
                          loading(true);
                          Get.back();
                          await onPressed(
                            name.text.trim(),
                            isImageEdited ? image.value : null,
                            imageDeleted,
                          );
                          loading(false);
                        },
                      );
                    }
                  },
                  child: Text(buttonText),
                ),
        )
      ],
    );
  }
}
