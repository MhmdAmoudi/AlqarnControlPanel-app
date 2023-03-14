import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../../api/api.dart';
import '../../../../../api/response_error.dart';
import '../../../../../service/file_from_bytes.dart';
import '../../../../../widgets/add_image_to_category.dart';
import '../../../../../widgets/animated_snackbar.dart';
import '../../../../../widgets/bottom_sheet.dart';
import '../../../../../widgets/custom_textfield.dart';
import '../../../widgets/progress_button.dart';
import '../model/country.dart';

class CountriesController {
  final API _api = API('Location', withFile: true);
  late Future<List<Country>> getCountries;

  Future<List<Country>> getAllCountries() async {
    try {
      var data = await _api.get('GetCountries');
      return Country.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<File> getCountryImage(String id) async {
    try {
      var data = await _api.getFile('GetCountryImage/$id');
      return await fileFromBytes(source: data, name: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCountry({
    required String name,
    required String symbol,
    required String code,
    required File? image,
  }) async {
    FormData form = FormData.fromMap({
      'name': name,
      'symbol': symbol,
      'code': code,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    await _api.postFile('AddCountry', data: form);
  }

  Future<bool> updateCountry({
    required String id,
    required String name,
    required String symbol,
    required String code,
    required File? image,
    required bool isImageDeleted,
  }) async {
    try {
      FormData form = FormData.fromMap({
        'id': id,
        'name': name,
        'symbol': symbol,
        'code': code,
        'isImageDeleted': isImageDeleted,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });
      return await _api.put('UpdateCountry', data: form);
    } on ResponseError catch (e) {
      showSnackBar(
        message: e.message,
        type: AlertType.failure,
      );
      return false;
    }
  }

  Future<Country?> manageCountry({
    String? id,
    required String title,
    required String buttonText,
    required Future<void> Function(
      String,
      String,
      String,
      File?,
      bool,
    )
        onSubmitted,
    Country? country,
  }) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController name =
        TextEditingController(text: country?.name);
    final TextEditingController symbol =
        TextEditingController(text: country?.symbol);
    final TextEditingController code =
        TextEditingController(text: country?.code);
    Rx<File?> image = Rx<File?>(country?.image);
    bool isImageEdited = country == null;
    bool imageDeleted = false;

    return await showGetBottomSheet(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: title,
      children: [
        AddImageToCategory(
          image: image,
          isImageEdited: isImageEdited,
          imageDeleted: imageDeleted,
        ),
        const SizedBox(height: 15),
        Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: name,
                prefixIcon: Icons.title_rounded,
                labelText: 'اسم الدولة',
                hintText: 'ادخل اسم الدولة',
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return 'ادخل الأسم';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CustomTextFormField(
                  controller: symbol,
                  prefixIcon: Icons.flag_rounded,
                  labelText: 'رمز الدولة',
                  hintText: 'ادخل رمز الدولة',
                  maxLength: 3,
                  validator: (val) {
                    if (val!.trim().length < 3) {
                      return 'ادخل رمز دولة صالح';
                    }
                    return null;
                  },
                ),
              ),
              CustomTextFormField(
                controller: code,
                prefixIcon: Icons.phone_rounded,
                labelText: 'مفتاح الدولة',
                hintText: 'ادخل مفتاح الدولة',
                maxLength: 3,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().length < 3) {
                    return 'ادخل مفتاح دولة صالح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              LocationProgressButton(
                confirmText: buttonText,
                successMessage: 'تم ال$buttonText بنجاح',
                formKey: formKey,
                onPressed: () async {
                  await onSubmitted(
                    name.text.trim(),
                    code.text.trim(),
                    symbol.text.trim(),
                    isImageEdited ? image.value : null,
                    imageDeleted,
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
