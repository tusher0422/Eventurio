import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 20),

        
            Text(
              user?.displayName ?? "No Name",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),


            Text(
              user?.email ?? "No Email",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),


            ElevatedButton(
              onPressed: () => authController.logout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
