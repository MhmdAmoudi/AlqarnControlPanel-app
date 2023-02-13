import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../utilities/appearance/style.dart';
import '../models/item_sales.dart';
import 'item_table.dart';

class ItemSalesWidget extends StatefulWidget {
  const ItemSalesWidget(this.id, {Key? key}) : super(key: key);
  final String id;

  @override
  State<ItemSalesWidget> createState() => _ItemSalesWidgetState();
}

class _ItemSalesWidgetState extends State<ItemSalesWidget> {
  late Future<List<ItemSales>> getSales;
  final API api = API('Item');

  @override
  void initState() {
    getSales = getItemSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSales,
      builder: (BuildContext context, AsyncSnapshot<List<ItemSales>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Column(
            children: [
              TableField(
                color: AppColors.darkMainColor,
                index: 'م',
                cell1: TableColumn(flex: 0.25, value: 'الكمية'),
                cell2: TableColumn(flex: 0.4, value: 'الإجمالي'),
                cell3: TableColumn(flex: 0.25, value: 'الحالة'),
              ),
              ...List.generate(
                snapshot.data!.length,
                (index) => TableField(
                  index: '${index + 1}',
                  cell1: TableColumn(
                    flex: 0.25,
                    value: '${snapshot.data![index].quantity}',
                  ),
                  cell2: TableColumn(
                    flex: 0.4,
                    value: '${snapshot.data![index].total} ${snapshot.data![index].currency}',
                  ),
                  cell3: TableColumn(
                    flex: 0.25,
                    value: snapshot.data![index].state,
                    textColor: snapshot.data![index].color
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  getSales = getItemSales();
                });
              },
              child: Text((snapshot.error as ResponseError).error),
            ),
          );
        }
      },
    );
  }

  Future<List<ItemSales>> getItemSales() async {
    try {
      var data = await api.get('GetItemSales/${widget.id}');
      return ItemSales.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }
}
