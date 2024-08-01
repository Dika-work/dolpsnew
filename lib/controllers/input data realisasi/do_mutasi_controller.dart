import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_mutasi_repo.dart';
import '../../utils/constant/storage_util.dart';

class DoMutasiController extends GetxController {
  final isLoadingMutasi = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doMutasiRepo = Get.put(DoMutasiRepository());

  RxString roleUser = ''.obs;
  // roles users
  RxInt rolesLihat = 0.obs;
  RxInt rolesBatal = 0.obs;
  RxInt rolesEdit = 0.obs;
  RxInt rolesHapus = 0.obs;

  final storageUtil = StorageUtil();

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleUser.value = user.tipe;
      rolesLihat.value = user.lihat;
      rolesBatal.value = user.batal;
      rolesEdit.value = user.edit;
      rolesHapus.value = user.hapus;
    }
    fetchMutasiContent();
  }

  Future<void> fetchMutasiContent() async {
    try {
      isLoadingMutasi.value = true;
      final getMutasiDo = await doMutasiRepo.fetchDoMutasiData();
      doRealisasiModel.assignAll(getMutasiDo);
    } catch (e) {
      print('Error while fetching data do Mutasi: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingMutasi.value = false;
    }
  }
}
