import 'package:flutter/material.dart';

import '../widgets/general_location.dart';

class Cities extends StatelessWidget {
  const Cities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GeneralLocation(
      route: 'City',
      title: 'المدن',
      addType: 'مدينة',
      parent: 'محافظة',
      child: 'منطقة',
    );
  }
}
