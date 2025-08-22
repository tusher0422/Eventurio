import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../app/routes/app_routes.dart';

class DrawerHeaderWidget extends StatelessWidget {
  DrawerHeaderWidget({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => CircleAvatar(
            radius: 40,
            backgroundImage: authController.userPhoto.isNotEmpty
                ? NetworkImage(authController.userPhoto)
                : null,
            child: authController.userPhoto.isEmpty
                ? const Icon(Icons.person, size: 40)
                : null,
          )),
          const SizedBox(height: 10),
          Obx(() => Text(
            authController.userName,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height: 5),
          Obx(() => Text(
            authController.userEmail,
            style: const TextStyle(color: Colors.white70),
          )),
          Obx(() => Text(
            authController.userPhone.isNotEmpty
                ? "Phone: ${authController.userPhone}"
                : "",
            style: const TextStyle(color: Colors.white70),
          )),
          Obx(() => Text(
            authController.userAddress.isNotEmpty
                ? "Address: ${authController.userAddress}"
                : "",
            style: const TextStyle(color: Colors.white70),
          )),
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => Get.toNamed(Routes.profile),
          ),
        ],
      ),
    );
  }
}
