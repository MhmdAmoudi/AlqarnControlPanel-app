import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/error_handler.dart';
import '../../offers/models/offer.dart';
import '../views/item_component/offers.dart';

class EditOffers extends StatefulWidget {
  const EditOffers({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String id;
  final String name;

  @override
  State<EditOffers> createState() => _EditOffersState();
}

class _EditOffersState extends State<EditOffers> {
  final API api = API('Item');

  late Future<List<Offer>> getOffers;

  final List<String> deletedOffers = [];

  @override
  void initState() {
    getOffers = getItemOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل عروض ${widget.name}'),
      ),
      body: FutureBuilder(
        future: getOffers,
        builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Offers(
                  offers: snapshot.data!,
                  deletedOffers: deletedOffers,
                ),
                ElevatedButton(
                  onPressed: () => update(snapshot.data!),
                  child: const Text('حفظ'),
                )
              ],
            );
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: () {
                setState(() {
                  getOffers = getItemOffers();
                });
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Offer>> getItemOffers() async {
    try {
      var data = await api.get('GetItemOffers/${widget.id}');
      return Offer.fromJson(data, true);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update(List<Offer> offers) async {
    try {
      context.loaderOverlay.show();
      List<String> deleteItems = [];
      List<Offer> add = [];
      List<Offer> update = [];
      for (var o in offers) {
        if (o.id == null) {
          add.add(o);
        } else {
          update.add(o);
          deleteItems.addAll(o.deletedItems!);
        }
      }
      await api.post(
        'UpdateItemOffers',
        data: {
          'id': widget.id,
          'add': Offer.toJson(add),
          'update': Offer.toJson(update),
          'deleteOffers': deletedOffers,
          'deleteItems': deleteItems,
        },
      );
      context.loaderOverlay.hide();
      Get.back();
      showSnackBar(message: 'تم التعديل بمجاح', type: AlertType.success);
    } on ResponseError catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
        title: 'فشل التعديل',
        message: e.error,
        type: AlertType.failure,
      );
    }
  }
}
