import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/theme_controller.dart';
import 'controllers/auth_controller.dart';
import 'utils/storage_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StorageService().init();

  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(), permanent: true);

  runApp(const EventurioApp());
}

class EventurioApp extends StatelessWidget {
  const EventurioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventurio',
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.isDark.value
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const SplashScreen(),
    ));
  }
}
