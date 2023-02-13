import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/bottom_sheet.dart';
import '../../widgets/card_tile.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/error_handler.dart';
import '../home/home.dart';
import 'controllers/bottle_controller.dart';
import 'models/bottle.dart';

class Bottles extends StatefulWidget {
  const Bottles({Key? key}) : super(key: key);

  @override
  State<Bottles> createState() => _BottlesState();
}

class _BottlesState extends State<Bottles> {
  final BottleController controller = BottleController();
  late Future<bool> getBottles;

  final RxBool loading = RxBool(false);
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();

  @override
  void initState() {
    getBottles = controller.getBottles();
    super.initState();
  }

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
            title: const Text('أحجام العلب'),
            actions: [
              IconButton(
                onPressed: () {
                  addBottleSheet(
                    title: 'إضافة علبة',
                    buttonText: 'إضافة',
                    onPressed: (size, unit) async {
                      String? id = await controller.addBottle(size, unit);
                      if (id != null) {
                        setState(() {
                          controller.bottles.add(Bottle(
                            id: id,
                            size: int.parse(size),
                            unit: unit,
                            itemsCount: 0,
                            isActive: RxBool(true),
                          ));
                        });
                      }
                    },
                  );
                },
                icon: const Icon(Icons.add_rounded),
              )
            ],
          ),
          drawer: const MenuDrawer(),
          body: FutureBuilder(
            future: getBottles,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: ListView.builder(
                    itemCount: controller.bottles.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index) {
                      return CardTile(
                        leading: Text('${index + 1}'),
                        title:
                            '${controller.bottles[index].size} ${controller.bottles[index].unit}',
                        subtitle:
                            '${controller.bottles[index].itemsCount} منتج',
                        isActive: controller.bottles[index].isActive,
                        onTap: () {},
                        onDeletePressed: () async {
                          bool deleted = await controller
                              .deleteBottle(controller.bottles[index]);
                          if (deleted) {
                            setState(() {
                              controller.bottles.removeAt(index);
                            });
                          }
                        },
                        onEditPressed: () {
                          addBottleSheet(
                            title: 'تعديل علبة',
                            buttonText: 'تعديل',
                            bSize: controller.bottles[index].size.toString(),
                            bUnit: controller.bottles[index].unit,
                            onPressed: (size, unit) async {
                              bool updated = await controller.updateBottle(
                                  controller.bottles[index],
                                  int.parse(size),
                                  unit);
                              if (updated) {
                                setState(() {
                                  controller.bottles[index].size =
                                      int.parse(size);
                                  controller.bottles[index].unit = unit;
                                });
                              }
                            },
                          );
                        },
                        onActivePressed: (state) async {
                          controller.bottles[index].isActive.value =
                              await controller.changeState(
                                  controller.bottles[index].id, !state);
                        },
                      );
                    },
                  ),
                );
              } else {
                return ErrorHandler(
                  error: snapshot.error,
                  onPressed: () {
                    setState(() {
                      getBottles = controller.getBottles();
                    });
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void addBottleSheet({
    required String title,
    required String buttonText,
    required Future Function(String size, String unit) onPressed,
    String? bSize,
    String? bUnit,
  }) {
    final TextEditingController size = TextEditingController();
    final TextEditingController unit = TextEditingController(text: 'مل');
    if (bSize != null) {
      size.text = bSize;
      unit.text = bUnit!;
    }
    showGetBottomSheet(
      title: title,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: nameKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: size,
                  hintText: 'حجم العلبة',
                  prefixIcon: Icons.battery_full_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'ادخل حجم العلبة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: unit,
                  hintText: 'الوحدة',
                  prefixIcon: Icons.title_rounded,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'ادخل الوحدة';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => loading.value
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (nameKey.currentState!.validate()) {
                      loading(true);
                      await onPressed(size.text.trim(), unit.text.trim());
                      loading(false);
                    }
                  },
                  child: Text(buttonText),
                ),
        )
      ],
    );
  }
}
