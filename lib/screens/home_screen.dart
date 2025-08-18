import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../utils/storage_service.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();


    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () => themeController.toggleTheme())

        ],
      ),
      body: const Center(
        child: Text("Welcome To Eventurio!"),
      ),
    );

  }
}