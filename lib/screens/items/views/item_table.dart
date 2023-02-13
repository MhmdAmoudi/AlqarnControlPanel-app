import 'package:flutter/material.dart';

import '../controller/item_controller.dart';

class TableField extends StatelessWidget {
  TableField({
    String? index,
    this.cell0,
    required this.cell1,
    this.cell2,
    this.cell3,
    this.cell4,
    this.cell5,
    this.color,
    Key? key,
  }) : super(key: key) {
    this.index = TableColumn(flex: 0.1, value: index);
  }

  late final TableColumn index;
  final TableColumn? cell0;
  final TableColumn cell1;
  final TableColumn? cell2;
  final TableColumn? cell3;
  final TableColumn? cell4;
  final TableColumn? cell5;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.grey.withOpacity(0.5)),
      columnWidths: {
        0: FlexColumnWidth(cell0?.flex ?? 0.1),
        1: FlexColumnWidth(cell1.flex),
        2: FlexColumnWidth(cell2?.flex ?? 0),
        3: FlexColumnWidth(cell3?.flex ?? 0),
        4: FlexColumnWidth(cell4?.flex ?? 0),
        5: FlexColumnWidth(cell5?.flex ?? 0),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: color),
          children: [
            cell(cell0 ?? index),
            cell(cell1),
            if (cell2 != null) cell(cell2!),
            if (cell3 != null) cell(cell3!),
            if (cell4 != null) cell(cell4!),
            if (cell5 != null) cell(cell5!),
          ],
        )
      ],
    );
  }

  TableCell cell(TableColumn cell) {
    return TableCell(
      child:  InkWell(
        onTap: cell.onTap,
        child: Container(
          color: cell.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          child: Center(
            child: cell.value != null
                ? Text(
                    cell.value!,
                    style: TextStyle(color: cell.textColor),
                  )
                : ItemController.getActiveState(
                    isActive: cell.status!,
                    activeColor: cell.textColor,
                    unSelectedIcon: cell.unSelectedIcon,
                  ),
          ),
        ),
      ),
    );
  }
}

class TableColumn {
  double flex;
  String? value;
  Color? textColor;
  Color? backgroundColor;
  bool? status;
  bool unSelectedIcon;
  void Function()? onTap;

  TableColumn({
    required this.flex,
    this.value,
    this.textColor,
    this.backgroundColor,
    this.status,
    this.unSelectedIcon = false,
    this.onTap,
  });
}
