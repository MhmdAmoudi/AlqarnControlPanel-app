import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utilities/appearance/style.dart';
import '../../../../widgets/animated_snackbar.dart';
import '../../../../widgets/custom_alert_dialog.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../models/bottle_price.dart';
import '../requirement_widget.dart';

class BottleSizes extends StatefulWidget {
  const BottleSizes({
    Key? key,
    required this.bottles,
    required this.selectedBottles,
    required this.currency,
    this.deletedBottles,
  }) : super(key: key);
  final List<DropdownMenuItem<String>> bottles;
  final List<BottlePrice> selectedBottles;
  final String currency;
  final List<String>? deletedBottles;

  @override
  State<BottleSizes> createState() => _BottleSizesState();
}

class _BottleSizesState extends State<BottleSizes> {
  final GlobalKey<FormState> priceKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RequirementsWidget(
      icon: Icons.battery_full_rounded,
      title: 'الأحجام',
      requirement: Form(
        key: priceKey,
        child: Column(
          children: List.generate(
            widget.selectedBottles.length,
            (index) => Column(
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.darkMainColor, width: 1.5)
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${index + 1}'),
                          ],
                        ),
                        horizontalTitleGap: 5,
                        minLeadingWidth: 20,
                        title: DropdownButton<String>(
                          isExpanded: true,
                          value: widget.selectedBottles[index].bottle,
                          items: widget.bottles,
                          onChanged: (val) {
                            if (widget.selectedBottles[index].bottle != val) {
                              if (widget.selectedBottles
                                  .every((sp) => sp.bottle != val)) {
                                setState(() {
                                  widget.selectedBottles[index].bottle =
                                      val as String;
                                });
                              } else {
                                showSnackBar(
                                  message: 'هذا الحجم مختار مسبقاً',
                                  type: AlertType.warning,
                                );
                              }
                            }
                          },
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: widget.selectedBottles[index].quantity,
                                  labelText: 'الكمية',
                                  hintText: 'ادخل الكمية',
                                  borderColor: true,
                                  fillColor: AppColors.darkMainColor,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {
                                      return 'ادخل الكمية';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: widget.selectedBottles[index].price,
                                  labelText: 'السعر ${widget.currency}',
                                  hintText: 'ادخل السعر',
                                  borderColor: true,
                                  fillColor: AppColors.darkMainColor,
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
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => !widget.selectedBottles[index].isMainBottle.value
                            ? Card(
                                margin: const EdgeInsets.all(0),
                                color: AppColors.darkMainColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    if (widget.selectedBottles[index].isActive.value)
                                      IconButton(
                                        onPressed: () {
                                          CustomAlertDialog.show(
                                              type: AlertType.question,
                                              title:
                                                  'هل ترغب بإلغاء تفعيل الحجم ${index + 1} ؟',
                                              confirmText: 'إلغاء التفعيل',
                                              confirmBackgroundColor: Colors.red,
                                              onConfirmPressed: () {
                                                Get.back();
                                                widget.selectedBottles[index]
                                                    .isActive(!widget
                                                        .selectedBottles[index]
                                                        .isActive
                                                        .value);
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                        ),
                                      )
                                    else
                                      IconButton(
                                        onPressed: () {
                                          CustomAlertDialog.show(
                                              type: AlertType.question,
                                              title:
                                                  'هل ترغب بتفعيل الحجم ${index + 1} ؟',
                                              confirmText: 'تفعيل',
                                              confirmBackgroundColor: Colors.green,
                                              onConfirmPressed: () {
                                                Get.back();
                                                widget.selectedBottles[index]
                                                    .isActive(!widget
                                                        .selectedBottles[index]
                                                        .isActive
                                                        .value);
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    IconButton(
                                      onPressed: () {
                                        widget.selectedBottles.any((b) {
                                          if (b.isMainBottle.value) {
                                            b.isMainBottle(false);
                                            return true;
                                          }
                                          return false;
                                        });
                                        widget.selectedBottles[index]
                                            .isMainBottle(true);
                                        widget.selectedBottles[index].isActive(true);
                                      },
                                      icon: const Icon(
                                        Icons.change_circle_rounded,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        CustomAlertDialog.show(
                                            type: AlertType.question,
                                            title:
                                                'هل ترغب بحذف الحجم ${index + 1} ؟',
                                            confirmText: 'حذف',
                                            confirmBackgroundColor: Colors.red,
                                            onConfirmPressed: () {
                                              Get.back();
                                              setState(() {
                                                if (widget.deletedBottles != null &&
                                                    widget.selectedBottles[index]
                                                            .id !=
                                                        null) {
                                                  widget.deletedBottles!.add(widget
                                                      .selectedBottles[index].id!);
                                                }
                                                widget.selectedBottles
                                                    .removeAt(index);
                                              });
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                const Divider()
              ],
            ),
          ),
        ),
      ),
      onAddPressed: () {
        if (priceKey.currentState!.validate()) {
          try {
            String? id = widget.bottles
                .firstWhere(
                  (size) => widget.selectedBottles
                      .every((sp) => sp.bottle != size.value),
                )
                .value;
            setState(() {
              widget.selectedBottles.add(
                BottlePrice(
                    bottle: id!,
                    price: TextEditingController(),
                    quantity: TextEditingController(),
                    isMainBottle: RxBool(false),
                    isActive: RxBool(true)),
              );
            });
          } catch (_) {
            showSnackBar(
              message: 'لا يوجد حجم إضافي',
              type: AlertType.warning,
            );
          }
        }
      },
    );
  }
}
