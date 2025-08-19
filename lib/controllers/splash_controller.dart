import 'dart:async';
import 'package:get/get.dart';
import '../utils/storage_service.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  final StorageService _storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (!_storage.hasSeenOnboarding) {
      Get.off(() => const OnboardingScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 600));
    } else if (user != null) {
      Get.off(() => const HomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 600));
    } else {
      Get.off(() => LoginScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 600));
    }
  }
}
