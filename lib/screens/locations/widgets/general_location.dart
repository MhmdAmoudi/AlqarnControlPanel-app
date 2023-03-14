import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/screens/locations/controller/location_controller.dart';

import '../../../../widgets/card_tile.dart';
import '../../../../widgets/error_handler.dart';
import '../../../api/response_error.dart';
import '../../../widgets/animated_snackbar.dart';
import '../models/location.dart';

class GeneralLocation extends StatefulWidget {
  final String route;
  final String title;
  final String addType;
  final String parent;
  final String child;
  final LocationType locationType;

  const GeneralLocation({
    Key? key,
    required this.route,
    required this.title,
    required this.addType,
    required this.parent,
    required this.child,
    this.locationType = LocationType.other,
  }) : super(key: key);

  @override
  State<GeneralLocation> createState() => _GeneralLocationState();
}

class _GeneralLocationState extends State<GeneralLocation> {
  final LocationController controller = LocationController();
  final RxBool loading = RxBool(false);

  @override
  void initState() {
    controller.route = widget.route;
    controller.getLocations = controller.getAllLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Obx(
            () => loading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      try {
                        loading(true);
                        final List<DropdownMenuItem<String>> requirements =
                            await getRequirement();
                        loading(false);
                        bool? added = await manageNewLocation(
                          requirements: requirements,
                          method: 'إضافة',
                          onSubmit: (parentId, name, deliveryLong,
                              deliveryFee) async {
                            return await controller.addLocation(
                              name: name,
                              parentId: parentId,
                              deliveryFee: deliveryFee,
                              deliveryLong: deliveryLong,
                            );
                          },
                        );
                        if (added != null) update();
                      } on ResponseError catch (e) {
                        loading(false);
                        showSnackBar(
                          message: e.message,
                          type: AlertType.failure,
                        );
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                  ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getLocations,
        builder:
            (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
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
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => snapshot.data![index].loading.value
                              ? const CircularProgressIndicator()
                              : Text('${index + 1}'),
                        ),
                      ],
                    ),
                    title: snapshot.data![index].name,
                    subtitle: '${snapshot.data![index].data} ${widget.child}',
                    trailing: delivery(snapshot.data![index].deliveryLong,
                        snapshot.data![index].deliveryFee),
                    isActive: snapshot.data![index].isActive,
                    onDeletePressed: () {},
                    onActivePressed: (val) {},
                    onEditPressed: () async {
                      List<DropdownMenuItem<String>>? requirements;
                      try {
                        context.loaderOverlay.show();
                        requirements = await getRequirement();
                        context.loaderOverlay.hide();
                      } on ResponseError catch (e) {
                        context.loaderOverlay.hide();
                        showSnackBar(
                          message: e.message,
                          type: AlertType.failure,
                        );
                      }
                      if (requirements != null) {
                        var updated = await manageNewLocation(
                          requirements: requirements,
                          method: 'تعديل',
                          oldName: snapshot.data![index].name,
                          oldDeliveryFee: snapshot.data![index].deliveryFee,
                          oldDeliveryLong: snapshot.data![index].deliveryLong,
                          oldSelectedId: snapshot.data![index].parentId,
                          branchLocation: snapshot.data![index].data,
                          onSubmit: (parentId, name, deliveryLong,
                              deliveryFee) async {
                            return await controller.updateLocation(
                              id: snapshot.data![index].id!,
                              name: name,
                              parentId: parentId,
                              deliveryFee: deliveryFee,
                              deliveryLong: deliveryLong,
                            );
                          },
                        );
                        if (updated != null) update();
                      }
                    },
                  );
                });
          } else {
            return ErrorHandler(
              error: snapshot.error,
              onPressed: update,
            );
          }
        },
      ),
    );
  }

  Widget? delivery(String? long, double? fee) {
    if (fee != null) {
      return Icon(
        Icons.delivery_dining_rounded,
        color: long != null ? Colors.teal : Colors.red,
      );
    }
    return null;
  }

  void update() {
    setState(() {
      controller.getLocations = controller.getAllLocations();
    });
  }

  Future<List<DropdownMenuItem<String>>> getRequirement() async {
    var data = await controller.api.get('Get${widget.route}Parents');
    return AddRequirement.fromJson(data);
  }

  Future manageNewLocation({
    required List<DropdownMenuItem<String>> requirements,
    required String method,
    required Future<dynamic> Function(String, String, String?, double?)
        onSubmit,
    String? oldName,
    double? oldDeliveryFee,
    String? oldDeliveryLong,
    String? oldSelectedId,
    String? branchLocation,
  }) async {
    return await controller.manageNewLocation(
      requirements: requirements,
      type: widget.addType,
      method: method,
      parentType: widget.parent,
      locationType: widget.locationType,
      oldName: oldName,
      oldDeliveryFee: oldDeliveryFee,
      oldDeliveryLong: oldDeliveryLong ?? branchLocation,
      oldSelectedId: oldSelectedId,
      onSubmit: onSubmit,
    );
  }
}
