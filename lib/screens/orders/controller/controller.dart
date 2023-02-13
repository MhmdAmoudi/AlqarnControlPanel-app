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
}
