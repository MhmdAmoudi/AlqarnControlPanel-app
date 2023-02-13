import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:manage/widgets/drawer/sections_drawer.dart';

import '../../widgets/infinite_list.dart';
import '../home/home.dart';
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
        onWillPop: () async {
          Get.off(() => const Home());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الطلبات'),
          ),
          drawer: const MenuDrawer(),
          body: InfiniteList<OrderView>(
            items: orders,
            padding: const EdgeInsets.all(10),
            getItems: controller.getOrders,
            child: (index) => OrderCard(orders[index], controller),
          ),
        ),
      ),
    );
  }
}
