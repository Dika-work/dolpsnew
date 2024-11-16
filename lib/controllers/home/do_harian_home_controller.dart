import 'package:get/get.dart';

import '../../models/home/do_harian_home.dart';
import '../../models/user_model.dart';
import '../../repository/home/do_harian_home_repo.dart';
import '../../utils/constant/storage_util.dart';

class DataDOHarianHomeController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianHomeModel> doHarianHomeModel = <DoHarianHomeModel>[].obs;
  final dataHarianHomeRepo = Get.put(DoHarianHomeRepository());
  final storageUtil = StorageUtil();

  String roleUser = '';
  String rolePlant = '';
  int daerah = 0;

  @override
  void onInit() {
    loadDataDetails(); // Load data user terlebih dahulu
    fetchDataDoGlobal(); // Lalu fetch data
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchDataDoGlobal(); // Fetch ulang data setelah controller siap
  }

  @override
  void onClose() {
    clearData(); // Bersihkan state sebelum controller dihapus
    super.onClose();
  }

  bool get isAdmin => roleUser == 'admin' || roleUser == 'k.pool';
  bool get isPengurusStaffing => roleUser == 'Pengurus Stuffing';

  Future<void> fetchDataDoGlobal() async {
    try {
      isLoadingGlobalHarian.value = true;

      print("Fetching data for User Role: $roleUser, Plant: $rolePlant");

      final dataHarian = await dataHarianHomeRepo.fetchGlobalHarianContent();
      print(" ${dataHarian.length} items");

      if (dataHarian.isNotEmpty) {
        if (isAdmin) {
          doHarianHomeModel.assignAll(dataHarian);
        } else {
          doHarianHomeModel.assignAll(
              dataHarian.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doHarianHomeModel.assignAll([]);
      }

      print("Final model data length: ${doHarianHomeModel.length}");
    } catch (e) {
      print('Error fetching data do harian: $e');
      doHarianHomeModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void loadDataDetails() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleUser = user.tipe;
      rolePlant = user.plant;
      daerah = user.wilayah;
      print("User Role: $roleUser, Plant: $rolePlant");
      print('..INI DAERAH USER YG LOGIN $daerah');
    }
  }

  void clearData() {
    doHarianHomeModel.clear(); // Bersihkan model
    roleUser = ''; // Reset role user
    rolePlant = ''; // Reset role plant
  }
}
