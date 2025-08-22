import 'package:get/get.dart';
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/event_detail_screen.dart';
import '../../screens/create_event_screen.dart';
import '../../screens/edit_event_screen.dart';

import '../routes/app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: "${Routes.eventDetail}/:id",
      page: () => const EventDetailScreen(),
    ),
    GetPage(
      name: Routes.eventCreate,
      page: () => const CreateEventScreen(),
    ),
    GetPage(
      name: "${Routes.eventEdit}/:id",
      page: () => const EditEventScreen(),
    ),
  ];
}
