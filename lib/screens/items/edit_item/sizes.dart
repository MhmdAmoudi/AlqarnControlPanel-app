import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/animated_snackbar.dart';
import '../../../widgets/error_handler.dart';
import '../models/bottle_price.dart';
import '../views/item_component/sizes.dart';

class EditBottles extends StatefulWidget {
  const EditBottles({required this.id, required this.name, Key? key})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<EditBottles> createState() => _EditBottlesState();
}

class _EditBottlesState extends State<EditBottles> {
  final API api = API('Item');

  late final String currency;

  late final List<DropdownMenuItem<String>> bottles;
  late final List<BottlePrice> selectedBottles;
  final List<String> deletedIds = [];

  late final Future<bool> getBottles;

  @override
  void initState() {
    getBottles = getItemBottles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل أحجام ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getBottles,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                BottleSizes(
                  currency: currency,
                  bottles: bottles,
                  selectedBottles: selectedBottles,
                  deletedBottles: deletedIds,
                ),
                ElevatedButton(onPressed: update, child: const Text('حفظ'))
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getBottles = getItemBottles();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> getItemBottles() async {
    try {
      var data = await api.get('GetItemBottles/${widget.id}');
      currency = data['currency'];
      bottles = List.from(data['bottles'])
          .map((e) => DropdownMenuItem(
                value: e['id'] as String,
                child:
                    Text(e['name'] + (e['isActive'] ? ' (مفعل)' : ' (موقف)')),
              ))
          .toList();
      selectedBottles = BottlePrice.fromJson(data['selectedBottles'], (e) => e['bottleId']);
      selectedBottles.any((e) {
        if (e.isMainBottle.value) {
          selectedBottles.remove(e);
          selectedBottles.insert(0, e);
          return true;
        }
        return false;
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update() async {
    try {
      context.loaderOverlay.show();
      await api.post(
        'UpdateBottles',
        data: {
          'id': widget.id,
          'add': BottlePrice.toJson(
              selectedBottles.where((b) => b.id == null).toList()),
          'update': BottlePrice.toJson(
              selectedBottles.where((b) => b.id != null).toList()),
          'delete': deletedIds,
        },
      );
      context.loaderOverlay.hide();
      Get.back();
      showSnackBar(message: 'تم التعديل بنجاح', type: AlertType.success);
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل التعديل',
        message: e.error,
        type: AlertType.failure,
      );
    }
  }
}
