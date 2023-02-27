import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/widgets/animated_snackbar.dart';

import '../../../api/api.dart';
import '../../../api/response_error.dart';
import '../../../utilities/appearance/style.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/drawer/sections_drawer.dart';
import '../../home/home.dart';

class LoginController {
  final API _api = API('Login');

  Future<void> login(BuildContext context, String token) async {
    context.loaderOverlay.show();
    try {
      bool exist = await _api.post('Login', data: token);
      if (exist) {
        try {
          const FlutterSecureStorage storage = FlutterSecureStorage();
          await storage.write(key: 'refreshToken', value: token);
          API.token = token;
          MenuDrawer.extractUserInfo();
          context.loaderOverlay.hide();
          Get.off(() => const Home());
        } catch (e) {
          context.loaderOverlay.hide();
          showSnackBar(
            title: 'فشل حفظ المعلومات',
            message: '000 - فشل حفظ معلومات المستخدم على الجهاز',
            type: AlertType.failure,
          );
        }
      } else {
        context.loaderOverlay.hide();
        showSnackBar(
          title: 'فشل تسجيل الدخول',
          message: '111 - هذا المستخدم غير صحيح',
          type: AlertType.failure,
        );
      }
    } on ResponseError catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
        title: 'فشل تسجيل الدخول',
        message: e.message,
        type: AlertType.failure,
      );
    }
  }

  void unauthorizedResetAlert() {
    CustomAlertDialog.show(
      type: AlertType.warning,
      title: 'إعادة تسجيل الدخول',
      content: 'يرجى إعادة تسجيل الدخول لتأكيد حسابك.',
      showCancelButton: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              Get.back();
              CustomAlertDialog.show(
                  type: AlertType.warning,
                  title: 'إعادة تسجيل الدخول',
                  content:
                  'يتم طلب تسجيل الدخول إلى حسابك مرة أخرى حسب الحالات التالية:\n1- تم تسجيل الدخول بحسابك هذا في جهاز آخر.\n2- مرت فترة منذ أن قمت بالدخول إلى حسابك على هذا الجهاز.',
                  confirmBackgroundColor: AppColors.subColor,
                  confirmText: 'فهمت',
                  onConfirmPressed: () => Get.back(),
                  showCancelButton: false
              );
            },
            child: const Text(
              'لماذا ظهر هذا التنبيه؟',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      confirmBackgroundColor: AppColors.subColor,
      confirmText: 'موافق',
      onConfirmPressed: () => Get.back(),
    );
  }
}
