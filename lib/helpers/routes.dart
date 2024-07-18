import 'package:doplsnew/controllers/input%20data%20do/do_global_controller.dart';
import 'package:doplsnew/controllers/input%20data%20do/do_kurang_controller.dart';
import 'package:doplsnew/controllers/input%20data%20do/do_tambah_controller.dart';
import 'package:doplsnew/controllers/tampil%20seluruh%20data/all_harian_lps_controller.dart';
import 'package:doplsnew/controllers/tampil%20seluruh%20data/all_kurang_controller.dart';
import 'package:doplsnew/controllers/tampil%20seluruh%20data/all_tambah_controller.dart';
import 'package:doplsnew/screens/input%20data%20do/do_global.dart';
import 'package:doplsnew/screens/input%20data%20do/do_harian.dart';
import 'package:doplsnew/screens/input%20data%20do/do_kurang.dart';
import 'package:doplsnew/screens/input%20data%20do/do_tambah.dart';
import 'package:doplsnew/screens/input%20data%20realisasi/request_kendaraan_screen.dart';
import 'package:doplsnew/screens/tampil%20seluruh%20data/do_global_all.dart';
import 'package:doplsnew/screens/tampil%20seluruh%20data/do_kurang_all.dart';
import 'package:doplsnew/screens/tampil%20seluruh%20data/do_tambah_all.dart';
import 'package:get/get.dart';

import '../controllers/input data do/do_harian_controller.dart';
import '../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../controllers/tampil seluruh data/all_global_controller.dart';
import '../screens/login.dart';
import '../screens/manajemen user/data_user_screen.dart';
import '../screens/onboarding.dart';
import '../screens/profile.dart';
import '../screens/rootpage.dart';
import '../screens/tampil seluruh data/do_harian_lps.dart';

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
        ),
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
              Get.put(DataDOKurangController());
            })),
        // Tampil seluruh data
        GetPage(
            name: '/all-do-global',
            page: () => const DoGlobalAll(),
            binding: BindingsBuilder(() {
              Get.put(DataAllGlobalController());
            })),
        GetPage(
            name: '/all-do-harian',
            page: () => const DoHarianLps(),
            binding: BindingsBuilder(() {
              Get.put(DataAllHarianLpsController());
            })),
        GetPage(
            name: '/all-do-kurang',
            page: () => const DoKurangAll(),
            binding: BindingsBuilder(() {
              Get.put(DataAllKurangController());
            })),
        GetPage(
            name: '/all-do-tambah',
            page: () => const DoTambahAll(),
            binding: BindingsBuilder(() {
              Get.put(DataAllTambahController());
            })),
        // Input data realisasi
        GetPage(
            name: '/request-mobil',
            page: () => const RequestKendaraanScreen(),
            binding: BindingsBuilder(() {
              Get.put(RequestKendaraanController());
            })),
      ];
}
