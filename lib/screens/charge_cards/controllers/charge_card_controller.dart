import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage/screens/charge_cards/widgets/qr_code_image.dart';
import 'package:manage/utilities/appearance/style.dart';
import 'package:path_provider/path_provider.dart';

import '../../../api/api.dart';
import '../models/charge_card.dart';

class ChargeCardController extends GetxController {
  final API _api = API('ChargeCards');
  late List<ChargeCardData> items;

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
          'ExpireAfterDays': expireAt.difference(DateTime.now()).inDays,
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
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(code)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrCodeImage(code),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    color: AppColors.darkMainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('$balance $currency'),
                    ),
                  ),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.share_rounded))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void shareQrCode() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';

    // final picData =
    //     await painter.toImageData(2048, format: ui.ImageByteFormat.png);
    // await writeToFile(picData, path);
  }

  @override
  void onInit() {
    items = [];
    super.onInit();
  }
}
