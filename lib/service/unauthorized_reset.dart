import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../screens/register/login.dart';

void unauthorizedReset() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  await storage.delete(key: 'refreshToken');
  API.token = null;
  Get.offAll(() => const Login(isUnAuthorizedReset: true));
}