import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:get/get.dart';

import '../screens/login.dart';
import '../screens/manajemen user/data_user_screen.dart';
import '../screens/onboarding.dart';
import '../screens/profile.dart';
import '../screens/rootpage.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/rootpage',
          page: () => const Rootpage(),
        ),
        GetPage(
          name: '/profile',
          page: () => const Profile(),
        ),
        // manajemen user
        GetPage(
            name: '/data-user',
            page: () => const DataUserScreen(),
            binding: BindingsBuilder(() {
              Get.put(DataUserController());
            })),
      ];
}
