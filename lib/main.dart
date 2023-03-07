import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:manage/widgets/drawer/sections_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:workmanager/workmanager.dart';

import 'api/api.dart';
import 'screens/home/home.dart';
import 'screens/register/login.dart';
import 'service/notifications.dart';
import 'utilities/appearance/theme.dart';
import 'widgets/global_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) {
        return GlobalLoader(
          child: GetMaterialApp(
            title: 'إدارة المتجر',
            themeMode: ThemeMode.dark,
            theme: AppTheme.darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AR'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ar'),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool startLogo = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        startLogo = true;
      });
    });
    startup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          scale: startLogo ? 1 : 0,
          duration: const Duration(seconds: 2),
          child: AnimatedOpacity(
            opacity: startLogo ? 1 : 0,
            duration: const Duration(seconds: 2),
            child: Image.asset(
              'asset/images/main_logo.png',
              height: 20.h,
            ),
          ),
        ),
      ),
    );
  }

  void startup() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    API.token = await storage.read(key: 'refreshToken');
    await dotenv.load();
    API.baseUrl = dotenv.get('BASE_URL');
    API.tempPath = (await getTemporaryDirectory()).path;
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask('orders', 'new orders count');
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (API.token != null) {
          MenuDrawer.extractUserInfo();
          Get.off(() => const Home());
        } else {
          Get.off(() => const Login());
        }
      },
    );
  }
}
