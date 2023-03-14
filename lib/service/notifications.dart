import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

late FlutterLocalNotificationsPlugin _localNotificationService;
late SharedPreferences _prefs;

void callbackDispatcher() async {
  int newOrders = await _getNewOrders();
  if (newOrders > 0) {
    await _initialize(newOrders);
  }
}

Future<int> _getNewOrders() async {
  if (!dotenv.isInitialized) await dotenv.load();
  Dio dio = Dio(
    BaseOptions(
      baseUrl:
          '${dotenv.get('BASE_URL')}Notification/',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  _prefs = await SharedPreferences.getInstance();
  String? lastOrderSeen = _prefs.getString('lastOrderSeen') ?? '';
  try {
    Response response = await dio.get('GetNewOrdersCount/datetime?datetime=$lastOrderSeen');
    int count = 0;
    if (response.statusCode == 200) {
      count = response.data['data'];
    }
    return count;
  } catch (_) {
    return 0;
  }
}

Future<void> _initialize(int count) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_circle_notifications');
  const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  _localNotificationService = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  _localNotificationService.initialize(initializationSettings);

  Workmanager().executeTask((taskName, inputData) async {
    showNotification(
      id: count,
      title: 'طلبات جديدة',
      body: 'يوجد لديك $count طلب جديد',
    );
    return true;
  });
}

Future<void> showNotification({
  required int id,
  required String title,
  required String body,
}) async {
  final details = await _notificationDetails();
  await _localNotificationService.show(id, title, body, details);
}

Future<NotificationDetails> _notificationDetails() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('متجر القرن', 'لوحة التحكم والإدارة',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true);
  const DarwinNotificationDetails iosNotificationDetails =
      DarwinNotificationDetails();
  return const NotificationDetails(
      android: androidNotificationDetails, iOS: iosNotificationDetails);
}
