import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/animated_snackbar.dart';
import '../../offers/models/offer.dart';
import '../models/item_requirements.dart';
import '../models/bottle_price.dart';
import '../models/item_category.dart';
import '../models/item_images.dart';
import '../models/more_detail.dart';

class AddItemController {
  final API _api = API('Item', isFile: true);

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  final List<List<DropdownMenuItem<String>>> bottles = [];
  final List<BottlePrice> selectedBottles = [];

  late final List<ItemCategory> categories;
  final List<Offer> offers = [];
  final List<MoreDetail> details = [];
  final List<MoreDetail> belongings = [];
  final List<ItemImage> images = [];

  final List<String> selectedDiscounts = [];
  final List<String> selectedCategories = [];

  Future<ItemRequirements> getRequirements() async {
    try {
      var data = await _api.get('GetItemRequirements');
      ItemRequirements requirements = ItemRequirements.fromJson(data['requirements']);
      categories = ItemCategory.fromJson(data['categories'], []);
      categories.first.isSelect = RxBool(true);
      selectedCategories.add(categories.first.id!);
      selectedBottles.add(
        BottlePrice(
          bottle: requirements.bottles.first.value!,
          price: TextEditingController(),
          quantity: TextEditingController(),
          isMainBottle: RxBool(true),
          isActive: RxBool(true),
        ),
      );
      bottles.add(requirements.bottles);
      return requirements;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addItem() async {
    MultipartFile? mainImage;
    for (var i in images) {
      if (i.isMain.value) {
        mainImage = await MultipartFile.fromFile(i.image.path);
        images.remove(i);
        break;
      }
    }
    try {
      FormData form = FormData.fromMap({
        'name': name.text.trim(),
        'description': description.text.trim(),
        'categories': selectedCategories,
        'bottles': BottlePrice.toJson(selectedBottles),
        'moreDetails': MoreDetail.toJson([...details, ...belongings]),
        'offers': Offer.toJson(offers),
        'mainImage': mainImage,
        'discounts': selectedDiscounts,
        'images': await ItemImage.toForm(images),
      });
      await _api.postFile('AddItem', data: form);
      showSnackBar(
        title: 'تمت الإضافة بنجاح',
        message: 'تمت إضافة المنتج ${name.text.trim()}',
        type: AlertType.success,
      );
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل إضافة المنتج ${name.text.trim()}',
        message: e.error,
        type: AlertType.failure,
      );
    }
  }
}
