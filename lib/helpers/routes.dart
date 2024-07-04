import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/controllers/input%20data%20do/do_global_controller.dart';
import 'package:doplsnew/controllers/input%20data%20do/do_pengurangan_controller.dart';
import 'package:doplsnew/controllers/input%20data%20do/do_tambahan_controller.dart';
import 'package:doplsnew/screens/input%20data%20do/do_global.dart';
import 'package:doplsnew/screens/input%20data%20do/do_harian.dart';
import 'package:doplsnew/screens/input%20data%20do/do_pengurangan.dart';
import 'package:doplsnew/screens/input%20data%20do/do_tambahan.dart';
import 'package:get/get.dart';

import '../controllers/input data do/do_harian_controller.dart';
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
        GetPage(
            name: '/data-do-harian',
            page: () => const InputDataDoHarian(),
            binding: BindingsBuilder(() {
              Get.put(DataDoHarianController());
            })),
        GetPage(
            name: '/data-do-global',
            page: () => const InputDataDOGlobal(),
            binding: BindingsBuilder(() {
              Get.put(DataDOGlobalController());
            })),
        GetPage(
            name: '/data-do-tambahan',
            page: () => const InputDataDoTambahan(),
            binding: BindingsBuilder(() {
              Get.put(DataDoTambahanController());
            })),
        GetPage(
            name: '/data-do-pengurangan',
            page: () => const InputDataDoPengurangan(),
            binding: BindingsBuilder(() {
              Get.put(DataDoPenguranganController());
            })),
      ];
}
