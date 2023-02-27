import 'package:get/get.dart';

import '../../../../api/api.dart';
import '../../../../api/response_error.dart';
import '../../../../widgets/animated_snackbar.dart';
import '../models/bottle.dart';

class BottleController {
  final API _api = API('Bottle');

  List<Bottle> bottles = [];

  Future<bool> getBottles() async {
    var data = await _api.get('GetBottles');
    bottles = Bottle.fromJson(data);
    return true;
  }

  Future<String?> addBottle(String size, String unit) async {
    try {
      String id =
          await _api.post('AddBottle', data: {'size': size, 'unit': unit});
      Get.back();
      showSnackBar(
        title: 'تم بنجاح',
        message: 'تمت إضافة الحجم $size $unit بنجاح',
        type: AlertType.success,
      );
      return id;
    } on ResponseError catch (e) {
      if (e.type == ErrorType.custom) {
        showSnackBar(
          title: 'فشل إضافة الحجم $size $unit',
          message: 'هذا الحجم موجود مسبقاً',
          type: AlertType.failure,
        );
      } else {
        showSnackBar(
          title: 'فشل إضافة الحجم $size $unit',
          message: e.message,
          type: AlertType.failure,
        );
      }
      return null;
    }
  }

  Future<bool> updateBottle(Bottle bottle, int size, String unit) async {
    try {
      bool updated = await _api.put(
        'UpdateBottle',
        data: {
          'id': bottle.id,
          'size': size,
          'unit': unit,
        },
      );
      Get.back();
      showSnackBar(
        title: 'تم التعديل بنجاح',
        message: 'تمت تعديل الحجم ${bottle.size} ${bottle.unit} بنجاح',
        type: AlertType.success,
      );
      return updated;
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل تعديل الحجم ${bottle.size} ${bottle.unit}',
        message: e.message,
        type: AlertType.failure,
      );
      return false;
    }
  }

  Future<bool> deleteBottle(Bottle bottle) async {
    try {
      bool deleted = await _api.get('DeleteBottle/${bottle.id}');
      showSnackBar(
        title: 'تم الحذف بنجاح',
        message: 'تمت حذف الحجم ${bottle.size} ${bottle.unit} بنجاح',
        type: AlertType.success,
      );
      return deleted;
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل حذف الحجم ${bottle.size} ${bottle.unit}',
        message: e.message,
        type: AlertType.failure,
      );
      return false;
    }
  }

  Future<bool> changeState(String id, bool state) async {
    try {
      return await _api.post('ChangeState', data: {id: state});
    } catch (_) {
      return !state;
    }
  }
}
