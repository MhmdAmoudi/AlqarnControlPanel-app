import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:manage/widgets/custom_textfield.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../api/api.dart';
import '../../api/response_error.dart';
import '../../utilities/appearance/style.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/download_image.dart';
import '../../widgets/error_handler.dart';
import 'models/country.dart';

class Countries extends StatefulWidget {
  const Countries({Key? key}) : super(key: key);

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  final API api = API('Location', isFile: true);
  late Future<List<Country>> getCountries;

  @override
  void initState() {
    getCountries = getAllCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدول'),
        actions: [
          IconButton(
            onPressed: () {
              final GlobalKey<FormState> formKey = GlobalKey<FormState>();
              final TextEditingController name = TextEditingController();
              final TextEditingController symbol = TextEditingController();
              final TextEditingController code = TextEditingController();
              Rx<ButtonState> state = Rx<ButtonState>(ButtonState.idle);
              File? image;

              showGetBottomSheet(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                title: 'إضافة دولة',
                children: [
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (val) {
                            if (val!.trim().length < 3) {
                              return 'ادخل مفتاح دولة صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => ProgressButton.icon(
                            height: 40.0,
                            minWidth: 40.0,
                            progressIndicatorSize: 30.0,
                            iconedButtons: {
                              ButtonState.idle: const IconedButton(
                                text: "إضافة",
                                icon: Icon(Icons.add_rounded,
                                    color: Colors.white),
                                color: AppColors.mainColor,
                              ),
                              ButtonState.loading: const IconedButton(
                                  color: AppColors.mainColor),
                              ButtonState.fail: IconedButton(
                                  text: "فشل",
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.white),
                                  color: Colors.red.shade300),
                              ButtonState.success: IconedButton(
                                  text: "تم بنجاح",
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  color: Colors.green.shade400)
                            },
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                state(ButtonState.loading);
                                bool add = await addCountry(
                                    name: name.text.trim(),
                                    code: code.text.trim(),
                                    symbol: symbol.text.trim(),
                                    image: image);
                                if (add) {
                                  state(ButtonState.success);
                                  Get.back();
                                  showSnackBar(
                                    message: 'تم الإضافة بنجاح',
                                    type: AlertType.success,
                                  );
                                } else {
                                  state(ButtonState.fail);
                                }
                              }
                            },
                            state: state.value,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCountries,
        builder: (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: AppColors.darkSubColor,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${index + 1}'),
                      ],
                    ),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(
                        '${snapshot.data![index].code}, ${snapshot.data![index].symbol}'),
                    trailing: snapshot.data![index].haveImage
                        ? DownloadImage(
                            getImage: () {
                              return getCountryImage(
                                  snapshot.data![index].name);
                            },
                            parent: (File image) {
                              return CircleAvatar(
                                backgroundImage: FileImage(image),
                              );
                            },
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.flag_circle_rounded),
                          ),
                  ),
                );
              },
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getCountries = getAllCountries();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Country>> getAllCountries() async {
    try {
      var data = await api.get('GetCountries');
      return Country.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<File> getCountryImage(String id) async {
    try {
      var data = await api.getFile('GetCountryImage/$id');
      String tempPath = (await getTemporaryDirectory()).path;
      return await File('$tempPath/$id').writeAsBytes(
        base64Decode(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addCountry({
    required String name,
    required String symbol,
    required String code,
    required File? image,
  }) async {
    try {
      FormData form = FormData.fromMap({
        'name': name,
        'symbol': symbol,
        'code': code,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });
      return await api.postFile('AddCountry', data: form);
    } on ResponseError catch (e) {
      showSnackBar(
        message: e.error,
        type: AlertType.failure,
      );
      return false;
    }
  }
}
