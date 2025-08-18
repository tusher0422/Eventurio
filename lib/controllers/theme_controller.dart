import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  var themeMode = ThemeMode.light.obs;

  void toggleTheme(){
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}