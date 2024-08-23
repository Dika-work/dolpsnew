import 'package:get/get.dart';

import '../../models/home/do_global_harian.dart';
import '../../models/user_model.dart';
import '../../repository/home/do_global_harian_repo.dart';
import '../../utils/constant/storage_util.dart';

class DataDOGlobalHarianController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoGlobalHarianModel> doGlobalHarianModel = <DoGlobalHarianModel>[].obs;
  final dataGlobalHarianRepo = Get.put(DoGlobalHarianRepository());
  final storageUtil = StorageUtil();

  String roleUser = '';
  String rolePlant = '';

  @override
  void onInit() {
    loadDataDetails();
    fetchDataDoGlobal();
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

  bool get isAdmin => roleUser == 'admin';

  Future<void> fetchDataDoGlobal() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();
      if (dataHarian.isNotEmpty) {
        if (isAdmin) {
          doGlobalHarianModel.assignAll(dataHarian);
        } else {
          doGlobalHarianModel.assignAll(
              dataHarian.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doGlobalHarianModel.assignAll([]);
      }
    } catch (e) {
      print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void loadDataDetails() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleUser = user.tipe;
      rolePlant = user.plant;
    }
  }

  void clearData() {
    doGlobalHarianModel.clear(); // Bersihkan model
    roleUser = ''; // Reset role user
    rolePlant = ''; // Reset role plant
  }
}
