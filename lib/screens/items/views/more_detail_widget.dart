import 'package:flutter/material.dart';

import '../../../utilities/appearance/style.dart';
import '../../../widgets/custom_textfield.dart';
import '../models/more_detail.dart';
import 'requirement_widget.dart';

class MoreDetailWidget extends StatefulWidget {
  const MoreDetailWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.type,
    required this.details,
    this.deletedIds,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final int type;
  final List<MoreDetail> details;
  final List<String>? deletedIds;

  @override
  State<MoreDetailWidget> createState() => _MoreDetailWidgetState();
}

class _MoreDetailWidgetState extends State<MoreDetailWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return RequirementsWidget(
      icon: widget.icon,
      title: widget.title,
      requirement: Form(
        key: formKey,
        child: Column(
          children: List.generate(
            widget.details.length,
            (index) => Column(
              children: [
                ListTile(
                  minLeadingWidth: 10,
                  leading: Text('${index + 1}'),
                  title: CustomTextFormField(
                    controller: widget.details[index].label,
                    prefixIcon: Icons.title_rounded,
                    fillColor: AppColors.darkMainColor,
                    labelText: 'العنوان',
                    hintText: 'ادخل العنوان',
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'ادخل العنوان';
                      }
                      return null;
                    },
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CustomTextFormField(
                      controller: widget.details[index].description,
                      prefixIcon: Icons.description_rounded,
                      fillColor: AppColors.darkMainColor,
                      labelText: 'الوصف',
                      hintText: 'ادخل الوصف',
                      minLines: 3,
                      maxLength: null,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'ادخل الوصف';
                        }
                        return null;
                      },
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      setState(() {
                        if(widget.deletedIds != null && widget.details[index].id != null){
                          widget.deletedIds!.add(widget.details[index].id!);
                        }
                        widget.details.removeAt(index);
                      });
                    },
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      onAddPressed: () {
        if (formKey.currentState!.validate()) {
          setState(() {
            widget.details.add(MoreDetail(
              label: TextEditingController(),
              description: TextEditingController(),
              type: widget.type,
            ));
          });
        }
      },
    );
  }
}
