import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthController authController = AuthController.to;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = authController.userName;
    phoneController.text = authController.userPhone;
    addressController.text = authController.userAddress;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: authController.userPhoto.isNotEmpty ? NetworkImage(authController.userPhoto) : null,
              child: authController.userPhoto.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone"), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await authController.updateProfile(
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    address: addressController.text.trim(),
                  );
                  Get.back();
                },
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
