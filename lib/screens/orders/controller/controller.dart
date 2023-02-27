import 'package:manage/api/response_error.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../models/order_view.dart';

class OrderController {
  final API _api = API('Order');

  Future<List<OrderView>> getOrders(List<String> sentItemsIds) async {
    var data = await _api.post('GetOrders', data: sentItemsIds);
    return OrderView.fromJson(data);
  }

  Future<OrderBillItem?> getOrderBill(String id) async {
    try {
      var data = await _api.get('GetOrderItems/$id');
      return OrderBillItem.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> changeOrderStatus(String id, int status) async {
    try {
      return await _api.post('ChangeOrderStatus', data: {id: status});
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل تغيير الحالة',
        message: e.message,
        type: AlertType.failure,
      );
      return false;
    }
  }
}
