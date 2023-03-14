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
import '../../../api/response_error.dart';
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

  Future<bool> deleteCode(int index) async {
    try {
      await _api.delete('DeleteCard/${items[index].id}');
      showSnackBar(
          message: 'تم حذف ${items[index].card} بنجاح',
          type: AlertType.success);
      return true;
    } on ResponseError catch (e) {
      showSnackBar(message: e.message, type: AlertType.failure);
    }
    return false;
  }

  Future<void> changeState({required int index, required bool state}) async {
    try {
      items[index].isActive!.value =
      await _api.post('ChangeCardState', data: {items[index].id: state});
      showSnackBar(message: 'تم تعديل حالة الكرت', type: AlertType.success);
    } on ResponseError catch (e) {
      showSnackBar(message: e.message, type: AlertType.failure);
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
                    onPressed: () => generateQrPdf(context),
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
      final ts = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      String path = '${tempDir.path}/$ts.png';
      return (await File(path).writeAsBytes(bytes)).path;
    } catch (_) {
      return null;
    }
  }

  Future<void> generateQrPdf(BuildContext context, {
    String? balance,
    String? expireAt,
    List<GlobalKey>? codesKey,
  }) async {
    context.loaderOverlay.show();
    try {
      List<String> images = await _getQrImagesPaths(codesKey);
      pw.Document pdf = await _createPdf(
        images: images,
        balance: balance,
        expireAt: expireAt,
      );
      XFile qrPdf = await _savePdf(pdf);
      context.loaderOverlay.hide();
      Get.back();
      await Share.shareXFiles([qrPdf]);
    } catch (_) {
      context.loaderOverlay.hide();
      showSnackBar(message: 'حصل خطأ في تحويل الرموز', type: AlertType.failure);
    }
  }

  Future<List<String>> _getQrImagesPaths(List<GlobalKey>? codesKey) async {
    List<String> images = [];
    String? path;
    Uint8List? byte;

    if (codesKey == null) {
      byte = await qrCodeController.capture();
      path = await _createQrImage(byte!);
      images.add(path!);
    } else {
      for (int i = 0; i < qrCodeControllers.length; i++) {
        await Scrollable.ensureVisible(codesKey[i].currentContext!);
        byte = await qrCodeControllers[i].capture();
        path = await _createQrImage(byte!);
        images.add(path!);
      }
    }
    return images;
  }

  Future<pw.Document> _createPdf({
    required List<String> images,
    String? balance,
    String? expireAt,
  }) async {
    final bytes = await rootBundle.load('asset/images/main_logo.png');
    final logo = pw.MemoryImage(bytes.buffer.asUint8List());
    final font = await rootBundle.load("asset/fonts/agnadeen.ttf");
    final ttf = pw.Font.ttf(font);

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
                border:
                pw.Border(bottom: pw.BorderSide(color: PdfColors.black))),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [pw.Image(logo, height: 50)]));
      },
      build: (pw.Context context) {
        return [
          if (balance != null)
            pw.GridView(
              crossAxisCount: 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1.16 / 1,
              children: List.generate(
                images.length,
                    (index) =>
                    pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Expanded(
                          child: pw.Image(
                            pw.MemoryImage(
                              File(images[index]).readAsBytesSync(),
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          height: 15,
                          width: 85,
                          child: pw.Row(
                            children: [
                              qrImageInfo(expireAt!, ttf),
                              pw.SizedBox(width: 2),
                              qrImageInfo(balance, ttf),
                            ],
                          ),
                        )
                      ],
                    ),
              ),
            )
          else
            pw.GridView(
              crossAxisCount: 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1 / 1,
              children: List.generate(
                images.length,
                    (index) =>
                    pw.Image(
                      pw.MemoryImage(
                        File(images[index]).readAsBytesSync(),
                      ),
                    ),
              ),
            )
        ];
      },
    ));

    return pdf;
  }

  Future<XFile> _savePdf(pw.Document pdf) async {
    Directory tempDir = await getTemporaryDirectory();
    String pdfPath = "${tempDir.path}/example.pdf";
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());
    return XFile(pdfPath);
  }

  pw.Expanded qrImageInfo(String label, pw.Font ttf) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(1),
        decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(3),
            border: pw.Border.all(color: PdfColors.grey400, width: 0.3)),
        child: pw.Center(
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: ttf,
              fontSize: 6,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onInit() {
    items = [];
    super.onInit();
  }
}
