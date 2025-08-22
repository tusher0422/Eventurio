import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/storage_service.dart';
import '../widgets/eventurio_icon.dart';
import 'login_screen.dart';
import '../app/theme/app_colors.dart';

class OnboardingPageModel {
  final String title;
  final String subtitle;
  final String image;

  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    title: "Discover Events",
    subtitle: "Find and attend events happening around you easily!.",
    image: "assets/onboarding1.jpg",
  ),
  OnboardingPageModel(
    title: "Create Your Event",
    subtitle: "Host and manage your own events!.",
    image: "assets/onboarding2.jpg",
  ),
  OnboardingPageModel(
    title: "Stay Notified",
    subtitle: "Never miss an event!.",
    image: "assets/onboarding3.jpg",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      setState(() => _currentPage++);
    } else {
      StorageService().setHasSeenOnboarding(true);
      Get.offAll(() => LoginScreen());
    }
  }

  void _skip() {
    StorageService().setHasSeenOnboarding(true);
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final page = onboardingPages[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                    child: Image.asset(
                      page.image,
                      key: ValueKey(page.image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.lightBackground.withOpacity(0.8),
                            AppColors.lightBackground,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 20,
                    child: TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                          child: Text(
                            page.title,
                            key: ValueKey(page.title),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                          child: Text(
                            page.subtitle,
                            key: ValueKey(page.subtitle),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingPages.length,
                                (dotIndex) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == dotIndex
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _nextPage,
                            child: _currentPage == onboardingPages.length - 1
                                ? const EventurioIcon(size: 32)
                                : const Text(
                              "Next",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
