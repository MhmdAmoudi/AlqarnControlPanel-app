import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../widgets/card_tile.dart';
import '../../../../widgets/download_image.dart';
import '../../../../widgets/error_handler.dart';
import 'controller/countries_controller.dart';
import 'model/country.dart';

class Countries extends StatefulWidget {
  const Countries({Key? key}) : super(key: key);

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  final CountriesController controller = CountriesController();

  @override
  void initState() {
    controller.getCountries = controller.getAllCountries();
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
              controller.manageCountry(
                title: 'إضافة دولة',
                buttonText: 'إضافة',
                onSubmitted: (name, code, symbol, image, _) {
                  return controller.addCountry(
                    name: name,
                    code: code,
                    symbol: symbol,
                    image: image,
                  );
                },
              );
            },
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: controller.getCountries,
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
                return CardTile(
                  leading: snapshot.data![index].haveImage
                      ? DownloadImage(
                          getImage: () {
                            return controller
                                .getCountryImage(snapshot.data![index].name);
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
                  title:
                      '${snapshot.data![index].name} ${snapshot.data![index].symbol}',
                  subtitle:
                      '${snapshot.data![index].code} | ${snapshot.data![index].counties} محافظة',
                  isActive: snapshot.data![index].isActive,
                  onActivePressed: (val) {},
                  onEditPressed: () {},
                );
              },
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  controller.getCountries = controller.getAllCountries();
                });
              },
            );
          }
        },
      ),
    );
  }
}
