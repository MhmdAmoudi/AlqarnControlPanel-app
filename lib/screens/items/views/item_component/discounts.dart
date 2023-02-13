import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utilities/appearance/style.dart';
import '../../models/item_discount.dart';
import '../item_table.dart';
import '../requirement_widget.dart';

class Discounts extends StatelessWidget {
  const Discounts({
    Key? key,
    required this.discounts,
    required this.coupons,
    required this.selectedDiscounts,
  }) : super(key: key);
  final List<ItemDiscount> discounts;
  final List<ItemDiscount> coupons;
  final List<String> selectedDiscounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RequirementsWidget(
          icon: Icons.discount_rounded,
          title: 'الخصومات',
          requirement: Column(
            children: [
              TableField(
                color: AppColors.darkMainColor,
                index: 'م',
                cell1: TableColumn(flex: 0.2, value: 'النسبة'),
                cell2: TableColumn(flex: 0.5, value: 'الإنتهاء'),
                cell3: TableColumn(flex: 0.2, value: 'اختيار'),
              ),
              Obx(
                () => Column(
                  children: List.generate(
                    discounts.length,
                    (index) => TableField(
                      cell0: TableColumn(
                        flex: 0.1,
                        value: '${index + 1}',
                        backgroundColor: discounts[index].isActive.value ? Colors.green : Colors.red
                      ),
                      cell1: TableColumn(
                        flex: 0.2,
                        value: '${discounts[index].percent}',
                      ),
                      cell2: TableColumn(
                        flex: 0.5,
                        value: discounts[index].endDatetime,
                      ),
                      cell3: TableColumn(
                        flex: 0.2,
                        status: discounts[index].isSelect!.value,
                        textColor: Colors.white,
                        unSelectedIcon: true,
                        onTap: () {
                          if (discounts[index].isSelect!.value) {
                            discounts[index].isSelect!(false);
                            selectedDiscounts.remove(discounts[index].id);
                          } else {
                            discounts.any((d) {
                              if (d.isSelect!.value) {
                                d.isSelect!(false);
                                selectedDiscounts.remove(d.id);
                                return true;
                              }
                              return false;
                            });
                            discounts[index].isSelect!(true);
                            selectedDiscounts.add(discounts[index].id!);
                          }
                        },
                      ),
                    ),
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
                cell1: TableColumn(flex: 0.15, value: 'النسبة'),
                cell2: TableColumn(flex: 0.3, value: 'الإنتهاء'),
                cell3: TableColumn(flex: 0.3, value: 'كوبون'),
                cell4: TableColumn(flex: 0.15, value: 'اختيار'),
              ),
              Obx(
                () => Column(
                  children: List.generate(
                    coupons.length,
                    (index) => TableField(
                      cell0: TableColumn(
                        flex: 0.1,
                        value:'${index + 1}' ,
                        backgroundColor: coupons[index].isActive.value ? Colors.green : Colors.red
                      ),
                      cell1: TableColumn(
                        flex: 0.15,
                        value: '${coupons[index].percent}',
                      ),
                      cell2: TableColumn(
                        flex: 0.3,
                        value: coupons[index].endDatetime,
                      ),
                      cell3: TableColumn(
                        flex: 0.3,
                        value: coupons[index].coupon,
                      ),
                      cell4: TableColumn(
                          flex: 0.15,
                          status: coupons[index].isSelect!.value,
                          textColor: Colors.white,
                          unSelectedIcon: true,
                          onTap: () {
                              if (coupons[index].isSelect!.value) {
                                selectedDiscounts.remove(coupons[index].id);
                                coupons[index].isSelect!(false);
                              } else {
                                selectedDiscounts.add(coupons[index].id!);
                                coupons[index].isSelect!(true);
                              }
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
