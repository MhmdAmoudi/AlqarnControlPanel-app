import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utilities/appearance/style.dart';
import '../../widgets/download_image.dart';
import '../../widgets/error_handler.dart';
import 'controller/item_controller.dart';
import 'models/item_data.dart';
import 'views/item_sales_widget.dart';
import 'views/requirement_widget.dart';
import 'views/item_table.dart';

class ShowItem extends StatefulWidget {
  const ShowItem(this.id, this.name, {Key? key}) : super(key: key);
  final String id;
  final String name;

  @override
  State<ShowItem> createState() => _ShowItemState();
}

class _ShowItemState extends State<ShowItem> {
  final ItemController controller = ItemController();
  late Future<ItemData> getItem;

  RxInt currentIndex = RxInt(-1);

  late final double radius;

  @override
  void initState() {
    getItem = controller.getItem(widget.id);
    radius = Get.size.width / 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, overflow: TextOverflow.ellipsis),
      ),
      body: FutureBuilder(
        future: getItem,
        builder: (BuildContext context, AsyncSnapshot<ItemData> snapshot) {
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
                  RequirementsWidget(
                    icon: Icons.description_rounded,
                    title: 'المعلومات',
                    requirement: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '- الحالة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: snapshot.data!.isActive
                                  ? [
                                      ItemController.getActiveState(
                                          isActive: true),
                                      const Text('  مفعل')
                                    ]
                                  : [
                                      ItemController.getActiveState(
                                          isActive: false),
                                      const Text('  غير مفعل')
                                    ],
                            )
                          ],
                        ),
                        const Divider(height: 20),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: DownloadImage(
                                getImage: () {
                                  return ItemController.getItemMainImage(
                                      widget.id);
                                },
                                parent: (image) {
                                  return Image.file(image, fit: BoxFit.cover);
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: snapshot.data!.description != null
                                  ? Text(snapshot.data!.description!)
                                  : const Text(
                                      'لا يوجد وصف',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.image_rounded,
                    title: 'الصور',
                    requirement: Column(
                      children: [
                        Obx(
                          () => Text(
                              '${currentIndex.value + 1} / ${snapshot.data!.images.length}'),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          margin: const EdgeInsets.all(0),
                          color: AppColors.darkMainColor,
                          child: CarouselSlider(
                            items: List.generate(
                              snapshot.data!.images.length,
                              (index) => Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: DownloadImage(
                                    getImage: () {
                                      return ItemController.getItemImage(
                                          snapshot.data!.images[index].id!);
                                    },
                                    parent: (image) {
                                      return Image.file(
                                        width: double.infinity,
                                        image,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )),
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
                  RequirementsWidget(
                    icon: Icons.ballot_rounded,
                    title: 'المتعلقات',
                    requirement: Column(
                      children: [
                        TableField(
                          color: AppColors.darkMainColor,
                          index: 'م',
                          cell1: TableColumn(
                            flex: 0.4,
                            value: 'العنوان',
                          ),
                          cell2: TableColumn(
                            flex: 0.5,
                            value: 'الوصف',
                          ),
                        ),
                        ...List.generate(
                          snapshot.data!.belongings.length,
                          (index) => TableField(
                            index: '${index + 1}',
                            cell1: TableColumn(
                              flex: 0.4,
                              value:
                                  snapshot.data!.belongings[index].label.text,
                            ),
                            cell2: TableColumn(
                              flex: 0.5,
                              value: snapshot
                                  .data!.belongings[index].description.text,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.more_rounded,
                    title: 'المزيد من التفاصيل',
                    requirement: Column(
                      children: [
                        TableField(
                          color: AppColors.darkMainColor,
                          index: 'م',
                          cell1: TableColumn(
                            flex: 0.4,
                            value: 'العنوان',
                          ),
                          cell2: TableColumn(
                            flex: 0.5,
                            value: 'الوصف',
                          ),
                        ),
                        ...List.generate(
                          snapshot.data!.details.length,
                          (index) => TableField(
                            index: '${index + 1}',
                            cell1: TableColumn(
                              flex: 0.4,
                              value: snapshot.data!.details[index].label.text,
                            ),
                            cell2: TableColumn(
                              flex: 0.5,
                              value: snapshot
                                  .data!.details[index].description.text,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.card_giftcard_rounded,
                    title: 'العروض الإضافية',
                    requirement: Column(
                      children: List.generate(
                        snapshot.data!.offers.length,
                        (index) => Column(
                          children: [
                            TableField(
                              color: AppColors.darkMainColor,
                              cell0: TableColumn(
                                flex: 0.1,
                                value: '${index + 1}',
                                backgroundColor:
                                    snapshot.data!.offers[index].isActive.value
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              cell1: TableColumn(
                                flex: 0.9,
                                value:
                                    snapshot.data!.offers[index].category.text,
                              ),
                            ),
                            TableField(
                              color: AppColors.darkMainColor,
                              cell0: TableColumn(
                                flex: 0.5,
                                value: 'أقل كمية',
                              ),
                              cell1: TableColumn(
                                flex: 0.5,
                                value: 'أكثر كمية',
                              ),
                            ),
                            TableField(
                              cell0: TableColumn(
                                flex: 0.5,
                                value: snapshot.data!.offers[index].min.text,
                              ),
                              cell1: TableColumn(
                                flex: 0.5,
                                value: snapshot.data!.offers[index].max.text,
                              ),
                            ),
                            TableField(
                              color: AppColors.darkMainColor,
                              index: 'م',
                              cell1: TableColumn(
                                flex: 0.6,
                                value: 'الأسم',
                              ),
                              cell2: TableColumn(
                                flex: 0.3,
                                value: 'السعر',
                              ),
                            ),
                            ...List.generate(
                              snapshot.data!.offers[index].items.length,
                              (i) => TableField(
                                cell0: TableColumn(
                                  flex: 0.1,
                                  backgroundColor: snapshot.data!.offers[index]
                                          .items[i].isActive.value
                                      ? Colors.green
                                      : Colors.red,
                                  value: '${i + 1}',
                                ),
                                cell1: TableColumn(
                                  flex: 0.6,
                                  value: snapshot
                                      .data!.offers[index].items[i].name.text,
                                ),
                                cell2: TableColumn(
                                  flex: 0.3,
                                  value: snapshot
                                      .data!.offers[index].items[i].price.text,
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.category_rounded,
                    title: 'الفئات',
                    requirement: Column(
                      children: [
                        TableField(
                          color: AppColors.darkMainColor,
                          index: 'م',
                          cell1: TableColumn(flex: 0.9, value: 'الفئة'),
                        ),
                        ...List.generate(
                          controller.categories.length,
                          (index) => TableField(
                            cell0: TableColumn(
                              flex: 0.1,
                              backgroundColor:
                                  controller.categories[index].isActive
                                      ? Colors.green
                                      : Colors.red,
                              value: '${index + 1}',
                            ),
                            cell1: TableColumn(
                              flex: 0.9,
                              value: controller.categories[index].name,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.battery_full_rounded,
                    title: 'الأحجام',
                    trailing: snapshot.data!.currency,
                    requirement: Column(children: [
                      TableField(
                        color: AppColors.darkMainColor,
                        index: 'م',
                        cell1: TableColumn(flex: 0.4, value: 'الحجم'),
                        cell2: TableColumn(flex: 0.2, value: 'الكمية'),
                        cell3: TableColumn(flex: 0.3, value: 'السعر'),
                      ),
                      ...List.generate(
                        snapshot.data!.bottles.length,
                        (index) => TableField(
                          cell0: TableColumn(
                            flex: 0.1,
                            backgroundColor: snapshot
                                    .data!.bottles[index].isMainBottle.value
                                ? AppColors.mainColor
                                : snapshot.data!.bottles[index].isActive.value
                                    ? Colors.green
                                    : Colors.red,
                            value: '${index + 1}',
                          ),
                          cell1: TableColumn(
                              flex: 0.4,
                              value: snapshot.data!.bottles[index].bottle),
                          cell2: TableColumn(
                            flex: 0.2,
                            value: snapshot.data!.bottles[index].quantity.text,
                            backgroundColor: int.parse(snapshot
                                        .data!.bottles[index].quantity.text) <
                                    1
                                ? Colors.red
                                : null,
                          ),
                          cell3: TableColumn(
                            flex: 0.3,
                            value: snapshot.data!.bottles[index].price.text,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  RequirementsWidget(
                    icon: Icons.discount_rounded,
                    title: 'الخصم',
                    requirement: Column(
                      children: [
                        TableField(
                          color: AppColors.darkMainColor,
                          index: 'م',
                          cell1: TableColumn(flex: 0.3, value: 'النسبة %'),
                          cell2: TableColumn(flex: 0.6, value: 'الإنتهاء'),
                        ),
                        ...List.generate(
                          snapshot.data!.discounts.length,
                          (index) => TableField(
                            cell0: TableColumn(
                              flex: 0.1,
                              backgroundColor:
                                  snapshot.data!.discounts[index].isActive.value
                                      ? Colors.green
                                      : Colors.red,
                              value: '',
                            ),
                            cell1: TableColumn(
                              flex: 0.3,
                              value:
                                  '${snapshot.data!.discounts[index].percent}',
                            ),
                            cell2: TableColumn(
                              flex: 0.6,
                              value:
                                  snapshot.data!.discounts[index].endDatetime,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.local_offer_rounded,
                    title: 'الكوبونات',
                    requirement: Column(
                      children: [
                        TableField(
                          color: AppColors.darkMainColor,
                          index: 'م',
                          cell1: TableColumn(flex: 0.3, value: 'كوبون'),
                          cell2: TableColumn(flex: 0.2, value: 'النسبة %'),
                          cell3: TableColumn(flex: 0.4, value: 'الإنتهاء'),
                        ),
                        ...List.generate(
                          snapshot.data!.coupons.length,
                          (index) => TableField(
                            cell0: TableColumn(
                              flex: 0.1,
                              backgroundColor:
                                  snapshot.data!.coupons[index].isActive.value
                                      ? Colors.green
                                      : Colors.red,
                              value: '${index + 1}',
                            ),
                            cell1: TableColumn(
                              flex: 0.3,
                              value: snapshot.data!.coupons[index].coupon,
                            ),
                            cell2: TableColumn(
                              flex: 0.2,
                              value: '${snapshot.data!.coupons[index].percent}',
                            ),
                            cell3: TableColumn(
                              flex: 0.4,
                              value: snapshot.data!.coupons[index].endDatetime,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RequirementsWidget(
                    icon: Icons.credit_card_rounded,
                    title: 'المبيعات',
                    requirement: ItemSalesWidget(widget.id),
                  ),
                ],
              ),
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getItem = controller.getItem(widget.id);
                });
              },
            );
          }
        },
      ),
    );
  }

// Color? isDatetimeExpired(DateTime datetime){
//   if(DateTime.now().isAfter(datetime)){
//     return Colors.red;
//   }
//   return null;
// }
}
