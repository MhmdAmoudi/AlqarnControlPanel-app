import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/error_handler.dart';
import '../models/item_category.dart';
import '../models/new_edited_data.dart';
import '../views/item_component/categories.dart';

class EditCategories extends StatefulWidget {
  const EditCategories({required this.id, required this.name, Key? key})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  final API api = API('Item');

  late List<String> newSelectedCategories;
  late List<String> oldSelectedCategories;

  late Future<List<ItemCategory>> getCategories;

  @override
  void initState() {
    getCategories = getItemCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل فئات ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getCategories,
        builder:
            (BuildContext context, AsyncSnapshot<List<ItemCategory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ItemCategories(
                  categories: snapshot.data!,
                  selectedCategories: newSelectedCategories,
                ),
                ElevatedButton(onPressed: update, child: const Text('حفظ'))
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getCategories = getItemCategories();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<List<ItemCategory>> getItemCategories() async {
    try {
      var data = await api.get('GetItemCategories/${widget.id}');
      oldSelectedCategories = List<String>.from(data['selectedCategories']);
      newSelectedCategories = [...oldSelectedCategories];
      return ItemCategory.fromJson(data['categories'], newSelectedCategories);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update() async {
    context.loaderOverlay.show();
    NewEditedData data = NewEditedData(
      oldItems: oldSelectedCategories,
      newItems: newSelectedCategories,
    );
    try {
      await api.post(
        'UpdateItemCategories',
        data: {
          'id': widget.id,
          'add': data.add,
          'delete': data.delete,
        },
      );
      context.loaderOverlay.hide();
      Get.back();
      showSnackBar(message: 'تم التعديل بنجاح', type: AlertType.success);
    } on ResponseError catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
        title: 'فشل التعديل',
        message: e.error,
        type: AlertType.failure,
      );
    }
  }
}
