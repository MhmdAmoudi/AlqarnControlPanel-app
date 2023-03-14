import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:manage/screens/locations/widgets/progress_button.dart';
import 'package:manage/utilities/appearance/style.dart';

import '../../../api/api.dart';
import '../../../widgets/bottom_sheet.dart';
import '../models/all_locations.dart';
import '../models/location.dart';
import '../screens/branches.dart';
import '../screens/cities.dart';
import '../screens/counties.dart';
import '../screens/countries/countries.dart';
import '../screens/regions.dart';
import '../widgets/input_location_row.dart';

class LocationController {
  final API api = API('Location');

  final List<AllLocations> allLocations = [
    AllLocations(
      icon: Icons.flag_circle_outlined,
      name: 'الدول',
      page: const Countries(),
    ),
    AllLocations(
      icon: Icons.flag_outlined,
      name: 'المحافظات',
      page: const Counties(),
    ),
    AllLocations(
      icon: Icons.location_city_outlined,
      name: 'المدن',
      page: const Cities(),
    ),
    AllLocations(
      icon: Icons.location_on_outlined,
      name: 'المناطق',
      page: const Regions(),
    ),
    AllLocations(
      icon: Icons.storefront_outlined,
      name: 'الفروع',
      page: const Branches(),
    ),
  ];

  late Future<List> getStatistics;
  late Future<List<Location>> getLocations;
  late final String route;

  Future<List> getItemStatistics() async {
    try {
      return await api.get('LocationStatistics');
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Location>> getAllLocations() async {
    try {
      var data = await api.get('Get${route}s');
      return Location.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }

  Future addLocation({
    required String parentId,
    required String name,
    String? deliveryLong,
    double? deliveryFee,
  }) async {
    return await api.post(
      'Add$route',
      data: {
        'parentId': parentId,
        'name': name,
        'deliveryLong': deliveryLong,
        'deliveryFee': deliveryFee,
      },
    );
  }

  Future<void> updateLocation({
    required String id,
    required String name,
    required String parentId,
    String? deliveryLong,
    double? deliveryFee,
  }) async {
    try {
      return await api.put(
        'Update$route',
        data: {
          'id': id,
          'parentId': parentId,
          'name': name,
          'deliveryLong': deliveryLong,
          'deliveryFee': deliveryFee,
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteLocation(String id) async {
    try {
      await api.delete('Delete$route/$id');
    } catch (_) {
      rethrow;
    }
  }

  Future<void> changeState({required String id, required bool state}) async {
    try {
      await api.put('Change${route}State', data: {id: state});
    } catch (_) {
      rethrow;
    }
  }

  Future manageNewLocation({
    required List<DropdownMenuItem<String>> requirements,
    required String type,
    required String method,
    required String parentType,
    required LocationType locationType,
    required Future Function(
      String,
      String,
      String?,
      double?,
    )
        onSubmit,
    String? oldName,
    String? oldDeliveryLong,
    double? oldDeliveryFee,
    String? oldSelectedId,
  }) async {
    final RxString selectedId =
        RxString(oldSelectedId ?? requirements.first.value!);
    final TextEditingController name = TextEditingController(text: oldName);
    final TextEditingController deliveryLong =
        TextEditingController(text: oldDeliveryLong);
    final TextEditingController deliveryFee = TextEditingController();
    if (oldDeliveryFee != null) {
      deliveryFee.text = oldDeliveryFee.toString();
    }
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    RxBool delivery = RxBool(false);
    return await showGetBottomSheet(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: '$method $type',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('اختر $parentType'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Obx(
                  () => DropdownButton<String>(
                    isDense: true,
                    dropdownColor: AppColors.darkSubColor,
                    value: selectedId.value,
                    items: requirements,
                    onChanged: selectedId,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Form(
          key: formKey,
          child: Column(
            children: [
              InputLocationRow(
                controller: name,
                hint: 'ادخل الأسم',
                label: 'اسم ال$type',
              ),
              if (locationType == LocationType.region)
                Obx(() => Column(
                      children: [
                        SwitchListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          title: const Text('يوجد توصيل'),
                          value: delivery.value,
                          onChanged: delivery,
                        ),
                        if (delivery.value) ...[
                          InputLocationRow(
                            controller: deliveryLong,
                            hint: 'ادخل فترة التوصيل',
                            label: 'فترة التوصيل للمنطقة',
                          ),
                          const SizedBox(height: 15),
                          InputLocationRow(
                            controller: deliveryFee,
                            hint: 'ادخل سعر التوصيل',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            label: 'سعر التوصيل',
                          )
                        ]
                      ],
                    ))
              else if (locationType == LocationType.branch)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: InputLocationRow(
                    controller: deliveryLong,
                    hint: 'ادخل وصف الموقع',
                    label: 'وصف الموقع',
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        LocationProgressButton(
          confirmText: method,
          successMessage: 'تمت ال$method بنجاح',
          formKey: formKey,
          onPressed: () async {
            return await onSubmit(
              selectedId.value,
              name.text.trim(),
              delivery.value || locationType == LocationType.branch
                  ? deliveryLong.text.trim()
                  : null,
              delivery.value ? double.parse(deliveryFee.text.trim()) : null,
            );
          },
        ),
      ],
    );
  }
}

enum LocationType { region, branch, other }
