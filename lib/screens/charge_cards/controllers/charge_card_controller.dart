import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:manage/screens/charge_cards/widgets/qr_code_image.dart';
import 'package:manage/utilities/appearance/style.dart';
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../../../api/api.dart';
import '../models/charge_card.dart';

class ChargeCardController extends GetxController {
  final API _api = API('ChargeCards');
  late List<ChargeCardData> items;

  WidgetsToImageController qrCodeController = WidgetsToImageController();

  late List<WidgetsToImageController> qrCodeControllers;

  final ScrollController scrollController = ScrollController();

  Future<List<ChargeCardData>> getChargeCards(List<String> sentIds) async {
    try {
      var data = await _api.post('GetChargeCards', data: sentIds);
      return ChargeCardData.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getAllCodes() async {
    try {
      var data = await _api.get('GetAllCardsCode');
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<bool> addCodes({
    required int balance,
    required DateTime expireAt,
    required List<String> codes,
  }) async {
    try {
      await _api.post(
        'AddCards',
        data: {
          'codes': codes,
          'balance': balance,
          'expireAt': expireAt.toUtc().toString().replaceFirst('Z', ''),
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  String getDate(DateTime datetime) =>
      formatDate(datetime, [yyyy, '/', mm, '/', dd]);

  void showQrCode({
    required BuildContext context,
    required String code,
    required String currency,
    required String balance,
    required String expireAt,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(code)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrCodeImage(
                qrCodeController: qrCodeController,
                code: code,
                balance: '$balance $currency',
                expireAt: expireAt,
              ),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      final bytes = await qrCodeController.capture();
                      if (bytes != null) {
                        String? path = await _createQrImage(bytes);
                        context.loaderOverlay.hide();
                        if (path != null) {
                          await Share.shareXFiles([XFile(path)],
                              subject: 'رمز متجر القرن');
                        }
                      } else {
                        context.loaderOverlay.hide();
                        showSnackBar(
                          message: 'فشل إنشاء صورة الرمز',
                          type: AlertType.failure,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.share_rounded,
                      color: AppColors.mainColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => generateQrPdf(
                      context: context,
                      balance: balance,
                      expireAt: expireAt,
                    ),
                    icon: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<String?> _createQrImage(Uint8List bytes) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '${tempDir.path}/$ts.png';
      return (await File(path).writeAsBytes(bytes)).path;
    } catch (_) {
      showSnackBar(
        message: 'فشل في حفظ صورة الرمز',
        type: AlertType.failure,
      );
    }

    return null;
  }

  Future<void> generateQrPdf({
    required BuildContext context,
    required String balance,
    required String expireAt,
    List<GlobalKey>? codesKey,
  }) async {
    context.loaderOverlay.show();
    try {
      List<String> images = [];
      String? path;
      Uint8List? byte;
      if (codesKey == null) {
        byte = await qrCodeController.capture();
        if (byte != null) {
          path = await _createQrImage(byte);
          if (path != null) {
            images.add(path);
          }
        }
      } else {
        for (int i = 0; i < qrCodeControllers.length; i++) {
          await Scrollable.ensureVisible(codesKey[i].currentContext!);
          byte = await qrCodeControllers[i].capture();
          if (byte == null) break;
          path = await _createQrImage(byte);
          if (path == null) break;
          images.add(path);
        }
      }

      if (byte != null || path == null) {
        final bytes = await rootBundle.load('asset/images/main_logo.png');
        final logo = pw.MemoryImage(bytes.buffer.asUint8List());
        final pdf = pw.Document(
          title: 'رموز تعبئة الرصيد',
          author: 'متجر القرن',
          creator: 'تطبيق أدارة المتجر',
        );
        pdf.addPage(pw.MultiPage(
          header: (_) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.only(bottom: 10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black))
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Image(logo, height: 50)
                  ]
              )
            );
          },
          build: (pw.Context context) {
            return [
              pw.GridView(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1,
                children: List.generate(
                  images.length,
                  (index) => pw.Image(
                    pw.MemoryImage(
                      File(images[index]).readAsBytesSync(),
                    ),
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            ];
          },
        ));

        Directory tempDir = await getTemporaryDirectory();
        String pdfPath = "${tempDir.path}/example.pdf";
        final file = File(pdfPath);
        await file.writeAsBytes(await pdf.save());
        context.loaderOverlay.hide();
        Get.back();
        await Share.shareXFiles([XFile(pdfPath)]);
      }
    } catch (_) {
      context.loaderOverlay.hide();
      showSnackBar(message: 'حصل خطأ في تحويل الرموز', type: AlertType.failure);
    }
  }

  @override
  void onInit() {
    items = [];
    super.onInit();
  }
}
