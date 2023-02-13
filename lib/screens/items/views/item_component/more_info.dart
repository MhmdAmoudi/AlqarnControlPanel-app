import 'package:flutter/material.dart';

import '../../models/more_detail.dart';
import '../more_detail_widget.dart';

class MoreInfo extends StatelessWidget {
  const MoreInfo({
    Key? key,
    required this.belongings,
    required this.details,
    this.deletedIds,
  }) : super(key: key);
  final List<MoreDetail> belongings;
  final List<MoreDetail> details;
  final List<String>? deletedIds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoreDetailWidget(
          type: 1,
          title: 'المتعلقات',
          icon: Icons.ballot_rounded,
          details: belongings,
          deletedIds: deletedIds,
        ),
        MoreDetailWidget(
          type: 2,
          title: 'المزيد من التفاصيل',
          icon: Icons.more_rounded,
          details: details,
          deletedIds: deletedIds,
        ),
      ],
    );
  }
}
