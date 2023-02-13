import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../utilities/appearance/style.dart';
import '../../../../widgets/animated_snackbar.dart';
import '../../models/item_category.dart';
import '../item_table.dart';
import '../requirement_widget.dart';

class ItemCategories extends StatelessWidget {
  const ItemCategories({
    Key? key,
    required this.categories,
    required this.selectedCategories,
  }) : super(key: key);

  final List<ItemCategory> categories;
  final List<String> selectedCategories;

  @override
  Widget build(BuildContext context) {
    return RequirementsWidget(
      icon: Icons.category_rounded,
      title: 'الفئات',
      requirement: Column(children: [
        TableField(
          color: AppColors.darkMainColor,
          index: 'م',
          cell1: TableColumn(flex: 0.7, value: 'الفئة'),
          cell2: TableColumn(flex: 0.2, value: 'اختيار'),
        ),
        Obx(
          () => Column(
            children: List.generate(
              categories.length,
              (index) => TableField(
                cell0: TableColumn(
                    flex: 0.1,
                    value: '${index + 1}',
                    backgroundColor:
                        categories[index].isActive ? Colors.green : Colors.red),
                cell1: TableColumn(
                  flex: 0.7,
                  value: categories[index].name,
                ),
                cell2: TableColumn(
                  flex: 0.2,
                  status: categories[index].isSelect!.value,
                  textColor: Colors.white,
                  unSelectedIcon: true,
                  onTap: () {
                    if (categories[index].isSelect!.value) {
                      if (selectedCategories.length > 1) {
                        categories[index].isSelect!(false);
                        selectedCategories.remove(categories[index].id!);
                      } else {
                        showSnackBar(
                            message: 'يجب اختيار فئة على الأقل',
                            type: AlertType.warning);
                      }
                    } else {
                      categories[index].isSelect!(true);
                      selectedCategories.add(categories[index].id!);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
