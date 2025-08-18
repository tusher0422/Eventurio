import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'app/bindings/initial_binding.dart';

void main() {
  runApp(const EventurioApp());
}

class EventurioApp extends StatelessWidget{
  const EventurioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Eventurio",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode.value,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ));
  }

}



