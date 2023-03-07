import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:path_provider/path_provider.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../widgets/animated_snackbar.dart';
import '../model/category_data.dart';

class CategoryController {
  final API _api = API('Category', withFile: true);

  List<CategoryData> categories = [];

  Future<bool> getCategories() async {
    try {
      var data = await _api.get('GetCategories');
      categories = CategoryData.fromJson(data);
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<File> getCategoryImage(String id) async {
    try {
      var data = await _api.get('GetCategoryImage/$id');
      return await File('${API.tempPath}/$id').writeAsBytes(
        base64Decode(data),
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String?> addCategory(String name, File? image) async {
    try {
      FormData form = FormData.fromMap({
        "name": name,
        "image":
            image != null ? await MultipartFile.fromFile(image.path) : null,
      });
      String id = await _api.postFile('AddCategory', data: form);
      Get.back();
      showSnackBar(
        title: 'تم بنجاح',
        message: 'تمت إضافة الفئة $name بنجاح',
        type: AlertType.success,
      );
      return id;
    } on ResponseError catch (e) {
      if (e.type == ErrorType.custom) {
        showSnackBar(
          title: 'فشل إضافة الفئة $name',
          message: 'توجد فئة بنفس الأسم',
          type: AlertType.failure,
        );
      } else {
        showSnackBar(
          title: 'فشل إضافة الفئة $name',
          message: e.message,
          type: AlertType.failure,
        );
      }
      return null;
    }
  }

  Future<bool> updateCategory({
    required CategoryData category,
    required String name,
    required File? image,
    required bool imageDeleted,
  }) async {
    try {
      FormData form = FormData.fromMap({
        'id': category.id,
        "name": name,
        "image":
            image != null ? await MultipartFile.fromFile(image.path) : null,
        'imageDeleted': imageDeleted
      });
      bool updated = await _api.postFile('UpdateCategory', data: form);
      Get.back();
      Get.back();
      showSnackBar(
        title: 'تم بنجاح',
        message: 'تمت تعديل الفئة ${category.name} بنجاح',
        type: AlertType.success,
      );
      return updated;
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل تعديل الفئة ${category.name}',
        message: e.message,
        type: AlertType.failure,
      );
      return false;
    }
  }

  Future<bool> deleteCategory(CategoryData category) async {
    try {
      bool deleted = await _api.get('DeleteCategory/${category.id}');
      showSnackBar(
        title: 'تم الحذف بنجاح',
        message: 'تمت حذف ${category.name} بنجاح',
        type: AlertType.success,
      );
      return deleted;
    } on ResponseError catch (e) {
      showSnackBar(
        title: 'فشل حذف ${category.name}',
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
