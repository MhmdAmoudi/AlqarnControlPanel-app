import 'package:flutter/cupertino.dart';

class MoreDetail {
  String? id;
  TextEditingController label;
  TextEditingController description;
  int type;

  MoreDetail({
    this.id,
    required this.label,
    required this.description,
    required this.type,
  });

  static List<MoreDetail> fromJson(List detailsMap) {
    List<MoreDetail> details = [];
    for (var d in detailsMap) {
      details.add(MoreDetail(
        id: d['id'],
        label: TextEditingController(text: d['label']),
        description: TextEditingController(text: d['description']),
        type: d['type'],
      ));
    }
    return details;
  }

  static List<Map<String, dynamic>> toJson(List<MoreDetail> details) {
    return details
        .map((d) => {
              'id': d.id,
              'label': d.label.text.trim(),
              'description': d.description.text.trim(),
              'type': d.type,
            })
        .toList();
  }
}
