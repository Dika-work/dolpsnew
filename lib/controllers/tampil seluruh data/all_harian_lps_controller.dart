import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_harian_all_lps.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/harian_all_lps_repo.dart';
import '../../utils/constant/storage_util.dart';

class DataAllHarianLpsController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianAllLpsModel> doGlobalHarianModel = <DoHarianAllLpsModel>[].obs;
  final dataGlobalHarianRepo = Get.put(GlobalHarianAllLpsRepository());
  final storageUtil = StorageUtil();

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;

  @override
  void onInit() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
    }
    fetchDataDoGlobal();
    super.onInit();
  }

  Future<void> fetchDataDoGlobal() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();
      doGlobalHarianModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }
}
