import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/utilities/appearance/style.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../controllers/charge_card_controller.dart';

class AddChargeCards extends StatelessWidget {
  final ChargeCardController controller;
  final List<String> codes;
  final String balance;
  final String currency;
  final DateTime expireAt;

  const AddChargeCards({
    Key? key,
    required this.controller,
    required this.codes,
    required this.balance,
    required this.currency,
    required this.expireAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حفظ كروت الشحن'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: codes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: IconButton(
                        onPressed: () {
                          controller.showQrCode(
                            context: context,
                            code: codes[index],
                            currency: currency,
                            balance: balance,
                          );
                        },
                        icon: const Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.mainColor,
                          size: 40,
                        )),
                    title: Text(codes[index]),
                    subtitle: Text(controller.getDate(expireAt)),
                    trailing: Text(balance),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      bool saved = await controller.addCodes(
                          balance: int.parse(balance),
                          expireAt: expireAt,
                          codes: codes);
                      context.loaderOverlay.hide();
                      if (saved) {
                        Get.back();
                        Get.back(result: true);
                        showSnackBar(
                            message: 'تم حفظ المعلومات بنجاح',
                            type: AlertType.success);
                      } else {
                        showSnackBar(
                            message: 'فشل حفظ المعلومات', type: AlertType.failure);
                      }
                    },
                    child: const Text('حفظ'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
