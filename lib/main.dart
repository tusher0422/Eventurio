import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'utils/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService().init();


  Get.put(ThemeController());

  runApp(const EventurioApp());
}

class EventurioApp extends StatelessWidget {
  const EventurioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final themeController = Get.find<ThemeController>();

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eventurio',
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
        home: storage.hasSeenOnboarding
            ? const HomeScreen()
            : const OnboardingScreen(),
      ),
    );
  }
}
