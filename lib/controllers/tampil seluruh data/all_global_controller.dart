import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_global_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/global_all_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';

class DataAllGlobalController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoGlobalAllModel> doAllGlobalModel = <DoGlobalAllModel>[].obs;
  final dataGlobalAllRepo = Get.put(GlobalAllRepository());
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
    fetchAllGlobalData();
    super.onInit();
  }

  Future<void> fetchAllGlobalData() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalAllRepo.fetchGlobalHarianContent();
      doAllGlobalModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doAllGlobalModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  Future<void> editDOGlobal(
    int id,
    String tgl,
    int idPlant,
    String tujuan,
    int srd,
    int mks,
    int ptk,
    int bjm,
  ) async {
    CustomDialogs.loadingIndicator();

    await dataGlobalAllRepo.editDOGlobalContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchAllGlobalData();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOGlobal(
    int id,
  ) async {
    CustomDialogs.loadingIndicator();
    await dataGlobalAllRepo.deleteDOGlobalContent(id);

    await fetchAllGlobalData();
    CustomFullScreenLoader.stopLoading();
  }
}
