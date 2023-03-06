import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../api/api.dart';

late FlutterLocalNotificationsPlugin _localNotificationService;
late SharedPreferences prefs;

void callbackDispatcher() async {
  int newOrders = await _getNewOrders();
  if (newOrders > 0) {
    await _initialize(newOrders);
  }
}

Future<int> _getNewOrders() async {
  await dotenv.load();
  API.baseUrl = dotenv.get('BASE_URL');
  final API api = API('Notification');
  prefs = await SharedPreferences.getInstance();
  String? lastOrderSeen = prefs.getString('lastOrderSeen');
  DateTime? lastOrderDatetime;
  if (lastOrderSeen != null) {
    lastOrderDatetime = DateTime.parse(lastOrderSeen);
  }
  try {
    int count = await api.get('GetNewOrdersCount/$lastOrderDatetime');
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
