import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/screens/items/models/item_discount.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/animated_snackbar.dart';
import '../../../widgets/error_handler.dart';
import '../models/new_edited_data.dart';
import '../views/item_component/discounts.dart';

class EditDiscounts extends StatefulWidget {
  const EditDiscounts({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String id;
  final String name;

  @override
  State<EditDiscounts> createState() => _EditDiscountsState();
}

class _EditDiscountsState extends State<EditDiscounts> {
  final API api = API('Item');
  late Future<List<ItemDiscount>> getDiscounts;

  late List<String> oldSelectedDiscount;
  late List<String> newSelectedDiscount;

  @override
  void initState() {
    getDiscounts = getItemDiscounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل عروض ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getDiscounts,
        builder:
            (BuildContext context, AsyncSnapshot<List<ItemDiscount>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Discounts(
                  discounts: snapshot.data!.where((e) => e.coupon == null).toList(),
                  coupons: snapshot.data!.where((e) => e.coupon != null).toList(),
                  selectedDiscounts: newSelectedDiscount,
                ),
                ElevatedButton(
                  onPressed: update,
                  child: const Text('حفظ'),
                )
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getDiscounts = getItemDiscounts();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<List<ItemDiscount>> getItemDiscounts() async {
    try {
      var data = await api.get('GetItemDiscounts/${widget.id}');
      oldSelectedDiscount = List<String>.from(data['selectedDiscounts']);
      newSelectedDiscount = [...oldSelectedDiscount];
      return ItemDiscount.fromJson(
          data['discounts'], data['selectedDiscounts']);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update() async {
    context.loaderOverlay.show();
    NewEditedData data = NewEditedData(
      oldItems: oldSelectedDiscount,
      newItems: newSelectedDiscount,
    );
    try {
      await api.post('UpdateDiscounts', data: {
        'id': widget.id,
        'delete': data.delete,
        'add': data.add,
      });
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
