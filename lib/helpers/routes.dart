import 'package:get/get.dart';

import '../controllers/input data do/do_global_controller.dart';
import '../controllers/input data do/do_harian_controller.dart';
import '../controllers/input data do/do_kurang_controller.dart';
import '../controllers/input data do/do_tambah_controller.dart';
import '../controllers/input data realisasi/do_mutasi_controller.dart';
import '../controllers/input data realisasi/do_reguler_controller.dart';
import '../controllers/input data realisasi/estimasi_pengambilan_controller.dart';
import '../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../controllers/master data/type_motor_controller.dart';
import '../controllers/tampil seluruh data/all_estimasi_controller.dart';
import '../controllers/tampil seluruh data/all_global_controller.dart';
import '../controllers/tampil seluruh data/all_harian_lps_controller.dart';
import '../controllers/tampil seluruh data/all_kurang_controller.dart';
import '../controllers/tampil seluruh data/all_tambah_controller.dart';
import '../screens/input data do/do_global.dart';
import '../screens/input data do/do_harian.dart';
import '../screens/input data do/do_kurang.dart';
import '../screens/input data do/do_tambah.dart';
import '../screens/input data realisasi/do_mutasi.dart';
import '../screens/input data realisasi/do_reguler.dart';
import '../screens/input data realisasi/estimasi_pengambilan.dart';
import '../screens/input data realisasi/request_kendaraan_screen.dart';
import '../screens/input data realisasi/table_estimasi_pm.dart';
import '../screens/laporan honda/laporan_plant.dart';
import '../screens/laporan honda/samarinda.dart';
import '../screens/login.dart';
import '../screens/manajemen user/data_user_screen.dart';
import '../screens/master data/type_motor_screen.dart';
import '../screens/onboarding.dart';
import '../screens/profile.dart';
import '../screens/rootpage.dart';
import '../screens/tampil seluruh data/do_estimasi_all.dart';
import '../screens/tampil seluruh data/do_global_all.dart';
import '../screens/tampil seluruh data/do_harian_lps.dart';
import '../screens/tampil seluruh data/do_kurang_all.dart';
import '../screens/tampil seluruh data/do_mutasi_all.dart';
import '../screens/tampil seluruh data/do_reguler_all.dart';
import '../screens/tampil seluruh data/do_tambah_all.dart';

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
        GetPage(
            name: '/all-do-reguler',
            page: () => const DoRegulerAll(),
            binding: BindingsBuilder(() {
              Get.put(DoRegulerController());
            })),
        GetPage(
            name: '/all-do-mutasi',
            page: () => const DoMutasiAll(),
            binding: BindingsBuilder(() {
              Get.put(DoMutasiController());
            })),
        GetPage(
            name: '/all-do-estimasi',
            page: () => const AllDoEstimasi(),
            binding: BindingsBuilder(() {
              Get.put(AllEstimasiController());
            })),
        // Input data realisasi
        GetPage(
            name: '/request-mobil',
            page: () => const RequestKendaraanScreen(),
            binding: BindingsBuilder(() {
              Get.put(RequestKendaraanController());
            })),
        GetPage(
            name: '/do-reguler',
            page: () => const DoRegulerScreen(),
            binding: BindingsBuilder(() {
              Get.put(DoRegulerController());
            })),
        GetPage(
            name: '/do-mutasi',
            page: () => const DoMutasiScreen(),
            binding: BindingsBuilder(() {
              Get.put(DoMutasiController());
            })),
        GetPage(
            name: '/estimasi-pm',
            page: () => const EstimasiPM(),
            binding: BindingsBuilder(() {
              Get.put(EstimasiPengambilanController());
            })),
        GetPage(
            name: '/table-estimasi',
            page: () => const TableEstimasiPM(),
            binding: BindingsBuilder(() {
              Get.put(EstimasiPengambilanController());
            })),
        // master data
        GetPage(
            name: '/type-motor',
            page: () => const TypeMotorScreen(),
            binding: BindingsBuilder(() {
              Get.put(TypeMotorController());
            })),
        // Laporan Honda
        GetPage(name: '/laporan-plant', page: () => const LaporanPlant()),
        GetPage(
            name: '/laporan-samarinda', page: () => const LaporanSamarinda()),
      ];

  static String mapCodeToRoute(String code) {
    switch (code) {
      case 'login':
        return '/login';
      case 'rootpage':
        return '/rootpage';
      case 'profile':
        return '/profile';
      case 'data-user':
        return '/data-user';
      case 'data-do-harian':
        return '/data-do-harian';
      case 'data-do-global':
        return '/data-do-global';
      case 'data-do-tambahan':
        return '/data-do-tambahan';
      case 'data-do-pengurangan':
        return '/data-do-pengurangan';
      case 'all-do-global':
        return '/all-do-global';
      case 'all-do-harian':
        return '/all-do-harian';
      case 'all-do-kurang':
        return '/all-do-kurang';
      case 'all-do-tambah':
        return '/all-do-tambah';
      case 'all-do-reguler':
        return '/all-do-reguler';
      case 'all-do-mutasi':
        return '/all-do-mutasi';
      case 'all-do-estimasi':
        return '/all-do-estimasi';
      case 'request-mobil':
        return '/request-mobil';
      case 'do-reguler':
        return '/do-reguler';
      case 'do-mutasi':
        return '/do-mutasi';
      case 'estimasi-pm':
        return '/estimasi-pm';
      case 'table-estimasi':
        return '/table-estimasi';
      case 'type-motor':
        return '/type-motor';
      case 'laporan-plant':
        return '/laporan-plant';
      case 'laporan-samarinda':
        return '/laporan-samarinda';

      default:
        return '/';
    }
  }
}
