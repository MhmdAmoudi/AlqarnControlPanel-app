import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../utilities/appearance/style.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/money_text.dart';
import '../controller/controller.dart';
import '../models/order_view.dart';

class OrderCard extends StatefulWidget {
  final OrderView order;
  final OrderController controller;

  const OrderCard(this.order, this.controller, {Key? key}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Color statusColor;
  late String statusLabel;
  late Icon statusIcon;

  @override
  void initState() {
    changeStatus(widget.order.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: statusColor.withOpacity(0.1))),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15),
            decoration: BoxDecoration(
              color: AppColors.darkMainColor,
              border: Border.all(color: statusColor, width: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                statusIcon,
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.numbers,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5),
                        AutoSizeText(
                          '?????? ?????? No.${widget.order.number}',
                          style: const TextStyle(color: Colors.black),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.order.status == 3 || widget.order.status == 2)
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert_rounded, color: statusColor),
                    itemBuilder: (BuildContext context) {
                      return const [
                        PopupMenuItem(
                            value: 2, child: Text('?????????? ???????????? ???????? ??????????????')),
                        PopupMenuItem(
                            value: 1, child: Text('?????????? ?????????? ??????????')),
                        PopupMenuItem(value: 0, child: Text('?????? ??????????')),
                      ];
                    },
                    onSelected: (val) {
                      switch (val) {
                        case 0:
                          showConfirmChangingStatus(
                            value: val,
                            title: '???? ???????? ???????? ????????????',
                            confirmText: '??????',
                            snackBarMessage: '???? ?????? ??????????',
                          );
                          break;
                        case 1:
                          showConfirmChangingStatus(
                            value: val,
                            title: '???? ???????? ???????????? ?????????? ????????????',
                            confirmText: '??????????',
                            snackBarMessage: '???? ?????????? ??????????',
                          );
                          break;
                        case 2:
                          showConfirmChangingStatus(
                            value: val,
                            title: '???? ???????? ???????????? ???????????? ???????? ????????????????',
                            confirmText: '??????????',
                            snackBarMessage: '???? ?????????? ??????????',
                          );
                      }
                    },
                  )
                else
                  const SizedBox(width: 20)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    orderDetail(
                      label: '?????????? ??????????',
                      icon: Icons.date_range,
                      value: widget.order.datetime,
                    ),
                    orderDetail(
                      label: '???????? ??????????',
                      icon: Icons.question_mark,
                      value: statusLabel,
                    ),
                    orderDetail(
                      label: '?????? ??????????????',
                      icon: Icons.send_time_extension_rounded,
                      value: widget.order.receiveType.toString(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: !widget.order.isOpen
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                orderDetail(
                                  label: '????????????',
                                  icon: Icons.location_on,
                                  value: widget.order.location,
                                ),
                                orderDetail(
                                  label: '????????????',
                                  icon: Icons.shopping_bag,
                                  value: widget.order.quantity.toString(),
                                ),
                                orderDetail(
                                  label: '????????????????',
                                  icon: Icons.monetization_on,
                                  price: MoneyTextStyle(
                                    price: widget.order.total,
                                    currency: widget.order.currency,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
                const Divider(height: 0),
                Column(
                  children: [
                    Obx(
                      () => widget.order.loadingBill.value
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '???????? ??????????????',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ]),
                            )
                          : TextButton.icon(
                              label: Text(widget.order.isOpen
                                  ? '?????????? ????????????????'
                                  : '?????? ????????????????'),
                              icon: AnimatedRotation(
                                turns: widget.order.isOpen ? 1.5 : 1,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 15,
                                ),
                              ),
                              onPressed: () async {
                                if (widget.order.bill == null) {
                                  if (widget.order.loadingBill.value) {
                                    return;
                                  }
                                  widget.order.loadingBill(true);
                                  widget.order.bill = await widget.controller
                                      .getOrderBill(widget.order.id);
                                  widget.order.loadingBill(false);
                                  if (widget.order.bill != null) {
                                    setState(() {
                                      widget.order.isOpen = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    widget.order.isOpen = !widget.order.isOpen;
                                  });
                                }
                              },
                            ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: widget.order.isOpen
                          ? Column(
                              children: [
                                const Divider(height: 0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      orderMoreDetail(
                                        label: '?????????? ??????????',
                                        value: widget.order.recipient,
                                      ),
                                      if (widget.order.locationDescription !=
                                          null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: orderMoreDetail(
                                            label: '?????? ????????????',
                                            value: widget
                                                .order.locationDescription!,
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      orderTable(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded orderDetail({
    required String label,
    required IconData icon,
    String? value,
    Widget? price,
  }) {
    return Expanded(
      child: Card(
        color: AppColors.darkMainColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 30,
                color: AppColors.mainColor,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.grey),
              ),
              price ?? Text(value!),
            ],
          ),
        ),
      ),
    );
  }

  Column orderTable() {
    OrderBillItem bill = widget.order.bill!;
    return Column(
      children: [
        itemsTable([
          itemTableHead(),
          ...List.generate(
            bill.items.length,
            (i) {
              return itemTableRow(
                n: '${i + 1}',
                name: bill.items[i].name,
                quantity: '${bill.items[i].quantity}',
                total: bill.items[i].total,
                coin: widget.order.currency,
              );
            },
          ),
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: itemsTable([
            itemTableRow(
              n: '-',
              name: '???????????? ????????????????',
              quantity: '${bill.offerItemsQuantity}',
              total: bill.offerItemsTotal,
              coin: widget.order.currency,
            )
          ]),
        ),
        if (bill.deliveryFee != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: itemsTable([
              itemTableRow(
                n: '-',
                name: '???????? ??????????????',
                quantity: '',
                total: bill.deliveryFee!,
                coin: widget.order.currency,
              )
            ]),
          ),
        itemsTable([
          itemTableRow(
              n: '',
              name: '????????????????',
              quantity: '${widget.order.quantity + bill.offerItemsQuantity}',
              total: widget.order.total,
              coin: widget.order.currency,
              backColor: AppColors.darkMainColor,
              color: AppColors.mainColor)
        ]),
      ],
    );
  }

  Table itemsTable(List<TableRow> children) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(0.07),
        1: FlexColumnWidth(0.45),
        2: FlexColumnWidth(0.16),
        3: FlexColumnWidth(0.32),
      },
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
      children: children,
    );
  }

  TableRow itemTableRow({
    required String n,
    required String name,
    required String quantity,
    required double total,
    required String coin,
    Color? backColor,
    Color? color,
  }) {
    return TableRow(
      decoration: BoxDecoration(color: backColor),
      children: [
        TableCell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(n),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text('  $name'),
          ),
        ),
        TableCell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(quantity),
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: MoneyTextStyle(
                price: total,
                currency: coin,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow itemTableHead() {
    return const TableRow(
      decoration: BoxDecoration(color: AppColors.darkMainColor),
      children: [
        TableCell(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text('??'),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Text('  ??????????'),
          ),
        ),
        TableCell(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text('????????????'),
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text('????????????????'),
            ),
          ),
        ),
      ],
    );
  }

  Widget orderMoreDetail({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value),
          ),
        )
      ],
    );
  }

  void changeStatus(int status) {
    statusColor = OrderStatus.color(status);
    statusLabel = OrderStatus.label(status);
    statusIcon = OrderStatus.icon(status);
    widget.order.status = status;
  }

  void showConfirmChangingStatus({
    required int value,
    required String title,
    required String confirmText,
    required String snackBarMessage,
  }) {
    CustomAlertDialog.show(
        type: AlertType.question,
        title: title,
        showCancelButton: true,
        confirmBackgroundColor: OrderStatus.color(value),
        confirmText: confirmText,
        onConfirmPressed: () async {
          context.loaderOverlay.show();
          bool changed =
              await widget.controller.changeOrderStatus(widget.order.id, value);
          context.loaderOverlay.hide();
          if (changed) {
            setState(() {
              Get.back();
              changeStatus(value);
              showSnackBar(message: snackBarMessage, type: AlertType.success);
            });
          }
        });
  }
}
