import 'package:flutter/material.dart';
import 'package:manage/widgets/drawer/menu_drawer.dart';

import '../../service/go_main_screen.dart';
import '../../widgets/infinite_list.dart';
import 'controller/controller.dart';
import 'models/order_view.dart';
import 'views/order_card.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final OrderController controller = OrderController();

  final List<OrderView> orders = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: goMainScreen,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الطلبات'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
              )
            ],
          ),
          drawer: const MenuDrawer(),
          body: InfiniteList<OrderView>(
            items: orders,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            getItems: controller.getOrders,
            child: (index) => OrderCard(orders[index], controller),
          ),
        ),
      ),
    );
  }
}
