import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/api/response_error.dart';
import 'package:manage/screens/items/edit_item/categories.dart';

import '../../api/api.dart';
import '../../widgets/animated_snackbar.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'edit_item/discounts.dart';
import 'edit_item/images.dart';
import 'edit_item/info.dart';
import 'edit_item/more_info.dart';
import 'edit_item/offers.dart';
import 'edit_item/sizes.dart';
import 'models/item_model.dart';
import 'views/edit_type.dart';

class EditItem extends StatelessWidget {
  EditItem(this.item, {Key? key}) : super(key: key);
  final ItemModel item;
  final api = API('Item');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل ${item.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          EditType(
            icon: Icons.description_rounded,
            name: 'المعلومات',
            page: EditInfo(id: item.id, name: item.name),
          ),
          EditType(
            icon: Icons.image_rounded,
            name: 'الصور',
            onTap: () {
              Get.to(() => EditImages(
                        id: item.id,
                        name: item.name,
                        haveImage: item.haveImage,
                      ))!
                  .then((val) {
                if (val != null) {
                  item.haveImage = val;
                }
              });
            },
          ),
          EditType(
            icon: Icons.more_rounded,
            name: 'المزيد من التفاصيل',
            page: EditMoreInfo(id: item.id, name: item.name),
          ),
          EditType(
            icon: Icons.card_giftcard_rounded,
            name: 'العروض الإضافية',
            page: EditOffers(id: item.id, name: item.name),
          ),
          EditType(
            icon: Icons.category_rounded,
            name: 'الفئات',
            page: EditCategories(id: item.id, name: item.name),
          ),
          EditType(
            icon: Icons.ballot_rounded,
            name: 'الأحجام',
            page: EditBottles(id: item.id, name: item.name),
          ),
          EditType(
            icon: Icons.discount_rounded,
            name: 'الخصومات',
            page: EditDiscounts(id: item.id, name: item.name),
          ),
          const Divider(),
          Obx(() => item.isActive.value
              ? EditType(
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                  name: 'مفعل',
                  onTap: () {
                    CustomAlertDialog.show(
                        type: AlertType.question,
                        title: 'هل ترغب بإلغاء تفعيل ${item.name} ؟',
                        confirmText: 'إلغاء التفعيل',
                        confirmBackgroundColor: Colors.red,
                        onConfirmPressed: () async {
                          Get.back();
                          context.loaderOverlay.show();
                          try {
                            await api.post(
                              'ChangeState',
                              data: {'id': item.id, 'state': false},
                            );
                            item.isActive(false);
                            context.loaderOverlay.hide();
                            showSnackBar(
                                message: 'تم إلغاء تفعيل المنتج',
                                type: AlertType.success);
                          } on ResponseError catch (e) {
                            context.loaderOverlay.hide();
                            showSnackBar(
                              title: 'فشل إلغاء تفعيل المنتج',
                              message: e.error,
                              type: AlertType.failure,
                            );
                          }
                        });
                  },
                )
              : EditType(
                  icon: Icons.cancel_rounded,
                  color: Colors.red,
                  name: 'غير مفعل',
                  onTap: () {
                    CustomAlertDialog.show(
                        type: AlertType.question,
                        title: 'هل ترغب بتفعيل ${item.name} ؟',
                        confirmText: 'تفعيل',
                        confirmBackgroundColor: Colors.green,
                        onConfirmPressed: () async {
                          Get.back();
                          context.loaderOverlay.show();
                          try {
                            await api.post(
                              'ChangeState',
                              data: {'id': item.id, 'state': true},
                            );
                            item.isActive(true);
                            context.loaderOverlay.hide();
                            showSnackBar(
                                message: 'تم تفعيل المنتج',
                                type: AlertType.success);
                          } on ResponseError catch (e) {
                            context.loaderOverlay.hide();
                            showSnackBar(
                              title: 'فشل تفعيل المنتج',
                              message: e.error,
                              type: AlertType.failure,
                            );
                          }
                        });
                  },
                )),
          const Divider(),
          EditType(
            onTap: () {
              CustomAlertDialog.show(
                  type: AlertType.question,
                  title: 'هل ترغب بحذف ${item.name} ؟',
                  confirmText: 'حذف',
                  confirmBackgroundColor: Colors.red,
                  onConfirmPressed: () async {
                    Get.back();
                    context.loaderOverlay.show();
                    try {
                      await api.post('DeleteItem/${item.id}');
                      context.loaderOverlay.hide();
                      Get.back(result: true);
                      showSnackBar(
                          message: 'تم حذف المنتج ${item.name}',
                          type: AlertType.success);
                    } on ResponseError catch (e) {
                      context.loaderOverlay.hide();
                      showSnackBar(
                        title: 'فشل حذف المنتج',
                        message: e.error,
                        type: AlertType.failure,
                      );
                    }
                  });
            },
            color: Colors.red,
            icon: Icons.delete_outline_rounded,
            name: 'حذف',
          )
        ],
      ),
    );
  }
}
