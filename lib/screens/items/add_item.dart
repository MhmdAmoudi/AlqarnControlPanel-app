import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../utilities/appearance/style.dart';
import '../../widgets/animated_snackbar.dart';
import '../../widgets/error_handler.dart';
import 'controller/add_item_controller.dart';
import 'models/item_requirements.dart';
import 'models/item_images.dart';
import 'views/item_component/categories.dart';
import 'views/item_component/discounts.dart';
import 'views/item_component/info.dart';
import 'views/item_component/more_info.dart';
import 'views/item_component/offers.dart';
import 'views/item_component/sizes.dart';
import 'views/requirement_widget.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final AddItemController controller = AddItemController();

  final CarouselController carouselController = CarouselController();

  late Future<ItemRequirements> getRequirements;

  final RxInt currentIndex = RxInt(-1);

  @override
  void initState() {
    getRequirements = controller.getRequirements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج'),
      ),
      body: FutureBuilder(
        future: getRequirements,
        builder:
            (BuildContext context, AsyncSnapshot<ItemRequirements> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Info(
                    name: controller.name,
                    description: controller.description,
                  ),
                  MoreInfo(
                    belongings: controller.belongings,
                    details: controller.details,
                  ),
                  ItemCategories(
                    categories: controller.categories,
                    selectedCategories: controller.selectedCategories,
                  ),
                  Offers(offers: controller.offers),
                  BottleSizes(
                    currency: snapshot.data!.currency,
                    bottles: snapshot.data!.bottles,
                    selectedBottles: controller.selectedBottles,
                  ),
                  Discounts(
                    discounts: snapshot.data!.discounts,
                    coupons: snapshot.data!.coupons,
                    selectedDiscounts: controller.selectedDiscounts,
                  ),
                  RequirementsWidget(
                    title: 'الصور',
                    icon: Icons.image_rounded,
                    requirement: Column(
                      children: [
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (controller.images.isNotEmpty) {
                                    if (controller.images[currentIndex.value]
                                        .isMain.value) {
                                      controller.images[currentIndex.value]
                                          .isMain(false);
                                    }
                                    else {
                                      controller.images.any((i) {
                                        if (i.isMain.value) {
                                          i.isMain(false);
                                          return true;
                                        }
                                        return false;
                                      });
                                      controller.images[currentIndex.value]
                                          .isMain(true);
                                    }
                                  }
                                },
                                child: controller.images.isNotEmpty &&
                                        controller.images[currentIndex.value]
                                            .isMain.value
                                    ? const Icon(Icons.check_circle_rounded)
                                    : const Icon(Icons.circle_outlined),
                              ),
                              Text(
                                  '${currentIndex.value + 1} / ${controller.images.length}'),
                              GestureDetector(
                                onTap: () {
                                  if (currentIndex.value > -1) {
                                    setState(() {
                                      controller.images
                                          .removeAt(currentIndex.value);
                                      if (currentIndex.value ==
                                          controller.images.length) {
                                        currentIndex.value -= 1;
                                      }
                                    });
                                  }
                                },
                                child: const Icon(
                                    Icons.remove_circle_outline_rounded),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          margin: const EdgeInsets.all(0),
                          color: AppColors.darkMainColor,
                          child: CarouselSlider(
                            carouselController: carouselController,
                            items: List.generate(
                              controller.images.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Image.file(
                                  width: double.infinity,
                                  controller.images[index].image,
                                  fit: BoxFit.cover,
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
                    onAddPressed: () async {
                      List<XFile> files = await ImagePicker().pickMultiImage();
                      if (files.isNotEmpty) {
                        bool noImages = controller.images.isEmpty;
                        setState(() {
                          for (var f in files) {
                            controller.images.add(ItemImage(
                              image: File(f.path),
                              isMain: RxBool(false),
                            ));
                          }
                          if (noImages) {
                            controller.images.first.isMain(true);
                          }
                          currentIndex(controller.images.length - 1);
                          carouselController
                              .animateToPage(controller.images.length);
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? message;
                      if (checkInfo()) {
                        if (checkBelongings()) {
                          if (checkMoreDetail()) {
                            if (checkBottles()) {
                              if (checkOffers()) {
                                context.loaderOverlay.show();
                                await controller.addItem();
                                context.loaderOverlay.hide();
                              } else {
                                message = 'يرجى إكمال معومات العروض';
                              }
                            } else {
                              message = 'يرجى إكمال معومات الأحجام';
                            }
                          } else {
                            message = 'يرجى إكمال معومات المزيد من التفاصيل';
                          }
                        } else {
                          message = 'يرجى إكمال معومات المتعلقات';
                        }
                      } else {
                        message = 'يرجى إدخال اسم المنتج';
                      }
                      if (message != null) {
                        showSnackBar(message: message, type: AlertType.warning);
                      }
                    },
                    child: const Text('إضافة'),
                  ),
                ],
              ),
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getRequirements = controller.getRequirements();
                });
              },
            );
          }
        },
      ),
    );
  }

  bool checkInfo() {
    return controller.name.text.trim().isNotEmpty;
  }

  bool checkBelongings() {
    return controller.belongings.isEmpty ||
        (controller.belongings.last.label.text.trim().isNotEmpty &&
            controller.belongings.last.description.text.trim().isNotEmpty);
  }

  bool checkMoreDetail() {
    return controller.details.isEmpty ||
        (controller.details.last.label.text.trim().isNotEmpty &&
            controller.details.last.description.text.trim().isNotEmpty);
  }

  bool checkBottles() {
    return controller.selectedBottles.last.price.text.trim().isNotEmpty &&
        controller.selectedBottles.last.quantity.text.trim().isNotEmpty;
  }

  bool checkOffers() {
    return controller.offers.isEmpty ||
        (controller.offers.last.category.text.trim().isNotEmpty &&
            controller.offers.last.max.text.trim().isNotEmpty &&
            controller.offers.last.min.text.trim().isNotEmpty &&
            controller.offers.last.items.last.name.text.trim().isNotEmpty &&
            controller.offers.last.items.last.price.text.trim().isNotEmpty);
  }
}
