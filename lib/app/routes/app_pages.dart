import 'package:get/get.dart';
import '../../screens/splash_screen.dart';
import '../../screens/home_screen.dart';
import 'app_routes.dart';

class AppPages{
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash , page: () => const SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  ];
}