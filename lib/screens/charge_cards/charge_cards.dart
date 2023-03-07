import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/screens/charge_cards/controllers/charge_card_controller.dart';
import 'package:manage/utilities/appearance/style.dart';
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:manage/widgets/custom_textfield.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../widgets/bottom_sheet.dart';
import '../../widgets/card_tile.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/infinite_list.dart';
import '../home/home.dart';
import 'models/charge_card.dart';
import 'widgets/add_charge_cards.dart';

class ChargeCards extends StatelessWidget {
  ChargeCards({Key? key}) : super(key: key);
  final ChargeCardController controller = Get.put(ChargeCardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.off(() => const Home());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('كروت الشحن'),
            actions: [
              IconButton(
                onPressed: () async {
                  context.loaderOverlay.show();
                  Map<String, dynamic>? codesData =
                      await controller.getAllCodes();
                  context.loaderOverlay.hide();
                  if (codesData != null) {
                    generateQrCodes(
                      context: context,
                      currency: codesData['currency'],
                      allCodes: codesData['codes'],
                    );
                  } else {
                    showSnackBar(
                        message: 'فشل الحصول على المعلومات',
                        type: AlertType.failure);
                  }
                },
                icon: const Icon(Icons.add_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          drawer: const MenuDrawer(),
          body: InfiniteList<ChargeCardData>(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: const EdgeInsets.only(top: 1),
            items: controller.items,
            getItems: controller.getChargeCards,
            child: (int index) => CardTile(
              leading: IconButton(
                  onPressed: () {
                    controller.showQrCode(
                      context: context,
                      code: controller.items[index].card,
                      currency: controller.items[index].currency,
                      balance: '${controller.items[index].balance}',
                    );
                  },
                  icon: const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppColors.mainColor,
                    size: 40,
                  )),
              title: controller.items[index].card,
              subtitle:
                  '${controller.items[index].expireAt} | ${controller.items[index].balance} ${controller.items[index].currency}',
              isActive: controller.items[index].isActive!,
              onTap: () {},
              onEditPressed: () {},
              onActivePressed: (val) {},
              onDeletePressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  void generateQrCodes({
    required BuildContext context,
    required String currency,
    required List allCodes,
  }) {
    RxInt count = RxInt(1);
    RxInt length = RxInt(2);
    Rx<DateTime> expireAt = Rx(DateTime.now().add(const Duration(days: 1)));
    RxBool numbers = RxBool(false);
    TextEditingController balance = TextEditingController();
    List<String> codes = [];
    showGetBottomSheet(
      title: 'إضافة كروت شحن',
      children: [
        cardData(
          label: 'عدد الكروت',
          value: count,
          minValue: 1,
          maxValue: 1000,
        ),
        const Divider(),
        cardData(
          label: 'عدد أحرف الكرت',
          value: length,
          minValue: 2,
          maxValue: 8,
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تاريخ الإنتهاء'),
            Card(
              color: AppColors.darkSubColor,
              child: Obx(
                () => TextButton(
                  onPressed: () async {
                    DateTime? datetime = await showDatePicker(
                        context: context,
                        initialDate: expireAt.value,
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)));
                    if (datetime != null) {
                      expireAt(datetime);
                    }
                  },
                  child: Text(controller.getDate(expireAt.value)),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const Expanded(child: Text('الرصيد')),
              Expanded(
                child: CustomTextFormField(
                  controller: balance,
                  hintText: 'ادخل الرصيد',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 10),
              Text(currency)
            ],
          ),
        ),
        const Divider(),
        Obx(
          () => SwitchListTile(
            value: numbers.value,
            title: const Text('يتضمن أرقام'),
            onChanged: numbers,
          ),
        ),
        const Divider(height: 20),
        ElevatedButton(
          onPressed: () {
            if (balance.text.isNotEmpty) {
              final random = Random();
              final String allChars;
              if (numbers.value) {
                allChars =
                    'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
              } else {
                allChars =
                    'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZzEeFfGgHhIiJjKkL';
              }
              String code;
              int allExist = 0;
              while (codes.length != count.value || allExist == 3) {
                code = List.generate(length.value,
                        (index) => allChars[random.nextInt(allChars.length)])
                    .join();

                if (!allCodes.contains(code)) {
                  allExist = 0;
                  codes.add(code);
                } else {
                  allExist++;
                }
              }

              if (allExist == 3) {
                showSnackBar(
                    message: 'يبدو أن كل الإحتمالات موجوده سابقاً',
                    type: AlertType.failure);
              } else {
                Get.off(() => AddChargeCards(
                      controller: controller,
                      codes: codes,
                      balance: balance.text,
                      expireAt: expireAt.value,
                  currency: currency,
                    ));
              }
            } else {
              showSnackBar(
                  message: 'يرجى ادخال سعر الكروت', type: AlertType.warning);
            }
          },
          child: const Text('إنشاء'),
        )
      ],
    );
  }

  Widget cardData({
    required String label,
    required RxInt value,
    required int minValue,
    required int maxValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Card(
          color: AppColors.darkSubColor,
          child: Obx(() => NumberPicker(
                value: value.value,
                minValue: minValue,
                maxValue: maxValue,
                onChanged: value,
                itemHeight: 20,
                textStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                selectedTextStyle: const TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 18,
                ),
              )),
        ),
      ],
    );
  }
}
