import 'package:flutter/material.dart';

import '../widgets/general_location.dart';

class Counties extends StatelessWidget {
  const Counties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GeneralLocation(
      route: 'Governorate',
      title: 'المحافظات',
      addType: 'محافظة',
      parent: 'الدولة',
      child: 'مدينة',
    );
  }
}
