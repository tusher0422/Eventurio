import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/storage_service.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget{
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              StorageService().setHasSeenOnboarding(true);

              Get.offAll(() => LoginScreen());
            },
        child: const Text("Finish Onboarding"),
        ),
      ),
    );
  }
}