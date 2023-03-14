import 'package:flutter/material.dart';
import 'package:manage/screens/locations/controller/location_controller.dart';
import 'package:manage/screens/locations/widgets/general_location.dart';

class Branches extends StatelessWidget {
  const Branches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GeneralLocation(
      route: 'Branch',
      title: 'الفروع',
      addType: 'فرع',
      parent: 'منطقة',
      child: '',
      locationType: LocationType.branch,
    );
  }
}
