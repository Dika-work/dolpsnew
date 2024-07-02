import 'package:doplsnew/screens/profile.dart';
import 'package:get/get.dart';

import '../screens/login.dart';
import '../screens/rootpage.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
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
      ];
}
