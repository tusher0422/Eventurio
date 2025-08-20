import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventurio Home"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.displayName ?? "Guest User",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user?.email ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => Get.to(() => ProfileScreen()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      child: const Text("View Profile"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),


            const Text(
              "Eventurio Features Coming Soon!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
