import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_kurang_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/kurang_all_repo.dart';
import '../../utils/constant/storage_util.dart';

class DataAllKurangController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoKurangAllModel> doGlobalHarianModel = <DoKurangAllModel>[].obs;
  final dataGlobalHarianRepo = Get.put(KurangAllRepository());
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
