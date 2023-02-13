import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../utilities/appearance/style.dart';
import '../../../../widgets/animated_snackbar.dart';
import '../../../../widgets/custom_alert_dialog.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../offers/models/offer.dart';
import '../requirement_widget.dart';

class Offers extends StatefulWidget {
  const Offers({required this.offers, this.deletedOffers, Key? key})
      : super(key: key);
  final List<Offer> offers;
  final List<String>? deletedOffers;

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RequirementsWidget(
      icon: Icons.card_giftcard_rounded,
      title: 'العروض الإضافية',
      requirement: Form(
        key: formKey,
        child: Column(
          children: List.generate(
            widget.offers.length,
            (index) => Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(0),
                  color: AppColors.darkMainColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              widget.offers[index].items.add(OfferItem(
                                name: TextEditingController(),
                                price: TextEditingController(),
                                isActive: RxBool(true),
                              ));
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          color: AppColors.mainColor,
                        ),
                      ),
                      Obx(() => IconButton(
                            onPressed: () {
                              if(widget.offers[index].isActive.value){
                                widget.offers[index].isActive(false);
                              } else {

                              }

                            },
                            icon: widget.offers[index].isActive.value
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                  ),
                          )),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (widget.offers[index].id != null) {
                              widget.deletedOffers!.add(widget.offers[index].id!);
                            }
                            widget.offers.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.darkMainColor, width: 2)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text('${index + 1}'),
                        horizontalTitleGap: 0,
                        minLeadingWidth: 20,
                        title: CustomTextFormField(
                          controller: widget.offers[index].category,
                          fillColor: AppColors.darkMainColor,
                          labelText: 'الفئة',
                          hintText: 'اسم الفئة',
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'ادخل الأسم';
                            }
                            return null;
                          },
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: widget.offers[index].min,
                                  labelText: 'أقل كمية',
                                  hintText: 'ادخل أقل كمية',
                                  borderColor: true,
                                  fillColor: AppColors.darkMainColor,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {
                                      return 'ادخل أقل كمية';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: widget.offers[index].max,
                                  labelText: 'أكثر كمية',
                                  hintText: 'ادخل أكثر كمية',
                                  borderColor: true,
                                  fillColor: AppColors.darkMainColor,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {
                                      return 'ادخل أكثر كمية';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Flexible(
                              child: Divider(
                            color: AppColors.darkMainColor,
                            thickness: 1,
                          )),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('العناصر'),
                          ),
                          Flexible(
                              child: Divider(
                            color: AppColors.darkMainColor,
                            thickness: 1,
                          )),
                        ],
                      ),
                      Column(
                        children: List.generate(
                            widget.offers[index].items.length,
                            (i) => Slidable(
                                  useTextDirection: false,
                                  startActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      Obx(() => widget.offers[index].items[i]
                                              .isActive.value
                                          ? SlidableAction(
                                              onPressed: (_) {
                                                CustomAlertDialog.show(
                                                    animation: true,
                                                    type: AlertType.question,
                                                    title:
                                                        'هل ترغب بإلغاء تفعيل ${index + 1}؟',
                                                    showCancelButton: true,
                                                    confirmBackgroundColor:
                                                        Colors.red,
                                                    confirmText:
                                                        'إلغاء التفعيل',
                                                    onConfirmPressed: () async {
                                                      Get.back();
                                                      widget.offers[index]
                                                          .items[i]
                                                          .isActive(false);
                                                    });
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.cancel_rounded,
                                              label: 'إلغاء التفعيل',
                                            )
                                          : SlidableAction(
                                              onPressed: (_) {
                                                CustomAlertDialog.show(
                                                    animation: true,
                                                    type: AlertType.question,
                                                    title:
                                                        'هل ترغب بتفعيل ${i + 1}؟',
                                                    showCancelButton: true,
                                                    confirmBackgroundColor:
                                                        Colors.green,
                                                    confirmText: 'تفعيل',
                                                    onConfirmPressed: () async {
                                                      Get.back();
                                                      widget.offers[index]
                                                          .items[i]
                                                          .isActive(true);
                                                    });
                                              },
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              icon: Icons.check_circle_rounded,
                                              label: 'تفعيل',
                                            )),
                                    ],
                                  ),
                                  endActionPane: i != 0
                                      ? ActionPane(
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) {
                                                CustomAlertDialog.show(
                                                    animation: true,
                                                    type: AlertType.question,
                                                    title:
                                                        'هل ترغب بحذف ${i + 1}؟',
                                                    showCancelButton: true,
                                                    confirmText: 'حذف',
                                                    confirmBackgroundColor:
                                                        Colors.red,
                                                    onConfirmPressed: () async {
                                                      Get.back();
                                                      setState(() {
                                                        if (widget.offers[index]
                                                                .items[i].id !=
                                                            null) {
                                                          widget.offers[index]
                                                              .deletedItems!
                                                              .add(widget
                                                                  .offers[index]
                                                                  .items[i]
                                                                  .id!);
                                                        }
                                                        widget
                                                            .offers[index].items
                                                            .removeAt(i);
                                                      });
                                                    });
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete_rounded,
                                              label: 'حذف',
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: ListTile(
                                    horizontalTitleGap: 0,
                                    minLeadingWidth: 20,
                                    leading: Text('${i + 1}'),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            fillColor: AppColors.darkMainColor,
                                            controller: widget
                                                .offers[index].items[i].name,
                                            labelText: 'الأسم',
                                            hintText: 'ادخل الأسم',
                                            validator: (val) {
                                              if (val!.trim().isEmpty) {
                                                return 'ادخل الأسم';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFormField(
                                            fillColor: AppColors.darkMainColor,
                                            controller: widget
                                                .offers[index].items[i].price,
                                            labelText: 'السعر',
                                            hintText: 'ادخل السعر',
                                            keyboardType: TextInputType.number,
                                            validator: (val) {
                                              if (val!.trim().isEmpty) {
                                                return 'ادخل السعر';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      onAddPressed: () {
        if (formKey.currentState!.validate()) {
          setState(() {
            widget.offers.add(
              Offer(
                category: TextEditingController(),
                min: TextEditingController(),
                max: TextEditingController(),
                isActive: RxBool(true),
                items: [
                  OfferItem(
                    name: TextEditingController(),
                    price: TextEditingController(),
                    isActive: RxBool(true),
                  )
                ],
              ),
            );
          });
        }
      },
    );
  }
}
