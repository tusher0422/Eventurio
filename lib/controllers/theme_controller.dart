import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = StorageService();
  var isDark = false.obs;

  ThemeData get lightTheme => ThemeData.light();
  ThemeData get darkTheme => ThemeData.dark();

  @override
  void onInit() {
    super.onInit();
    isDark.value = _storage.read('isDark') ?? false;
    ever(isDark, (val) => _storage.write('isDark', val));
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}
