import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/error_handler.dart';
import '../models/more_detail.dart';
import '../views/item_component/more_info.dart';

class EditMoreInfo extends StatefulWidget {
  const EditMoreInfo({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String id;
  final String name;

  @override
  State<EditMoreInfo> createState() => _EditMoreInfoState();
}

class _EditMoreInfoState extends State<EditMoreInfo> {
  final API api = API('Item');
  List<String> deletedIds = [];

  late Future<List<List<MoreDetail>>> getDetails;

  @override
  void initState() {
    getDetails = getItemDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل مزيد ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getDetails,
        builder: (BuildContext context,
            AsyncSnapshot<List<List<MoreDetail>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                MoreInfo(
                  belongings: snapshot.data!.first,
                  details: snapshot.data![1],
                  deletedIds: deletedIds,
                ),
                ElevatedButton(
                  onPressed: () {
                    update([...snapshot.data!.first, ...snapshot.data![1]]);
                  },
                  child: const Text('حفظ'),
                )
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getDetails = getItemDetails();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<List<List<MoreDetail>>> getItemDetails() async {
    try {
      var data = await api.get('GetMoreInfo/${widget.id}');
      return [
        MoreDetail.fromJson(data.where((e) => e['type'] == 1).toList()),
        MoreDetail.fromJson(data.where((e) => e['type'] == 2).toList()),
      ];
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update(List<MoreDetail> details) async {
    context.loaderOverlay.show();
    try {
      await api.post(
        'UpdateMoreInfo',
        data: {
          'id': widget.id,
          'add': MoreDetail.toJson(details.where((d) => d.id == null).toList()),
          'update': MoreDetail.toJson(details.where((d) => d.id != null).toList()),
          'delete': deletedIds
        },
      );
      context.loaderOverlay.hide();
      Get.back();
      showSnackBar(message: 'تم التعديل بنجاح', type: AlertType.success);
    } on ResponseError catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
        title: 'فشل التعديل',
        message: e.message,
        type: AlertType.failure,
      );
    }
  }
}
