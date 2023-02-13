import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/error_handler.dart';
import '../views/item_component/info.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String id;
  final String name;

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final API api = API('Item');

  late Future<bool> getInfo;

  late final TextEditingController name;
  late final TextEditingController description;

  @override
  void initState() {
    getInfo = getItemInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل تفاصيل ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getInfo,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Info(
                  name: name,
                  description: description,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: update,
                  child: const Text('حفظ'),
                )
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getInfo = getItemInfo();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> getItemInfo() async {
    try {
      var data = await api.get('GetItemInfo/${widget.id}');
      name = TextEditingController(text: data['name']);
      description = TextEditingController(text: data['description'] ?? '');
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update() async {
    if (name.text.trim().isNotEmpty) {
      context.loaderOverlay.show();
      try {
        await api.post(
          'UpdateItemInfo',
          data: {
            'id': widget.id,
            'name': name.text.trim(),
            if (description.text.trim().isNotEmpty) 'description': description,
          },
        );
        context.loaderOverlay.hide();
        Get.back();
        showSnackBar(message: 'تم التعديل بنجاح', type: AlertType.success);
      } on ResponseError catch (e) {
        context.loaderOverlay.hide();
        showSnackBar(
          title: 'فشل التعديل',
          message: e.error,
          type: AlertType.success,
        );
      }
    } else {
      showSnackBar(message: 'يرجى ادخال الأسم', type: AlertType.warning);
    }
  }
}
