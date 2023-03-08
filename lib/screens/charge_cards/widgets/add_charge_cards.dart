import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/service/current_datetime.dart';
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../controllers/charge_card_controller.dart';
import 'qr_image_design.dart';
import 'qr_image_tail.dart';

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
    List<GlobalKey> qrImageKeys = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('حفظ كروت الشحن'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            QrImageTail(
              balance: '$balance $currency',
              expireAt: controller.getDate(expireAt),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 1 / 1.1,
                ),
                itemCount: codes.length,
                itemBuilder: (BuildContext context, int index) {
                  var key = GlobalKey();
                  qrImageKeys.add(key);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: WidgetsToImage(
                      controller: controller.qrCodeControllers[index],
                      child: QrImageDesign(
                        key: qrImageKeys[index],
                        size: 100,
                        code: codes[index],
                      ),
                    ),
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
                        codes: codes,
                      );
                      context.loaderOverlay.hide();
                      if (saved) {
                        saved = false;
                        await CustomAlertDialog.show(
                            type: AlertType.success,
                            title: 'تم حفظ الكروت بنجاح',
                            content:
                                'هل ترغب بإنشاء ملف pdf بالكروت التي تم حفظها',
                            confirmText: 'إنشاء',
                            onConfirmPressed: () {
                              saved = true;
                              Get.back();
                            });
                        if (saved) {
                          await controller.generateQrPdf(
                            context: context,
                            codesKey: qrImageKeys,
                            balance: balance,
                            expireAt: getZoneDatetime('$expireAt')!,
                          );
                        }
                        Get.back(result: true);
                      } else {
                        showSnackBar(
                            message: 'فشل حفظ المعلومات',
                            type: AlertType.failure);
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
