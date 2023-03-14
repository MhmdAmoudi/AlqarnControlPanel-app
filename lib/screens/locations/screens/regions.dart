import 'package:flutter/material.dart';
import 'package:manage/screens/locations/controller/location_controller.dart';

import '../widgets/general_location.dart';

class Regions extends StatelessWidget {
  const Regions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GeneralLocation(
      route: 'Region',
      title: 'المناطق',
      addType: 'منطقة',
      parent: 'المدينة',
      child: 'فرع',
      locationType: LocationType.region,
    );
  }
}
