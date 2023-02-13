import 'package:flutter/material.dart';

import '../../widgets/circle_card.dart';
import 'model/category_data.dart';

class Category extends StatelessWidget {
  const Category(this.category, this.image, {Key? key}) : super(key: key);
  final Image? image;
  final CategoryData category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          CircleCard(
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('تعديل'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('حذف'),
                  ),
                ];
              },
              onSelected: (val) {},
            ),
          )
        ],
      ),
      body: ListView(),
    );
  }
}
