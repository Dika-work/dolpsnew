import 'package:get/get.dart';

import '../../models/home/do_harian_home_bsk.dart';
import '../../models/user_model.dart';
import '../../repository/home/do_harian_home_bsk_repo.dart';
import '../../utils/constant/storage_util.dart';

class DoHarianHomeBskController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianHomeBskModel> doHarianHomeBskModel =
      <DoHarianHomeBskModel>[].obs;
  final dataHarianHomeBskRepo = Get.put(DoHarianHomeBskRepository());
  final storageUtil = StorageUtil();

  String roleUser = '';
  String rolePlant = '';

  @override
  void onInit() {
    loadDataDetails();
    fetchHarianBesok();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchHarianBesok(); // Fetch ulang data setelah controller siap
  }

  @override
  void onClose() {
    clearData(); // Bersihkan state sebelum controller dihapus
    super.onClose();
  }

  bool get isAdmin => roleUser == 'admin';

  Future<void> fetchHarianBesok() async {
    try {
      isLoadingGlobalHarian.value = true;

      print(
          "Fetching data Harian Besok for User Role: $roleUser, Plant: $rolePlant");

      final dataHarian =
          await dataHarianHomeBskRepo.fetchGlobalHarianBesokContent();
      if (dataHarian.isNotEmpty) {
        if (isAdmin) {
          doHarianHomeBskModel.assignAll(dataHarian);
        } else {
          doHarianHomeBskModel.assignAll(
              dataHarian.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doHarianHomeBskModel.assignAll([]);
      }
    } catch (e) {
      print('Error fetching data do harian : $e');
      doHarianHomeBskModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void loadDataDetails() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleUser = user.tipe;
      rolePlant = user.plant;
      print("Loaded User Role: $roleUser, Plant: $rolePlant");
    }
  }

  void clearData() {
    doHarianHomeBskModel.clear(); // Bersihkan model
    roleUser = ''; // Reset role user
    rolePlant = ''; // Reset role plant
  }
}
