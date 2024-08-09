import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_reguler_repo.dart';
import '../../utils/constant/storage_util.dart';

class DoRegulerController extends GetxController {
  final isLoadingReguler = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doRegulerRepo = Get.put(DoRegulerRepository());

  RxString roleUser = ''.obs;
  final storageUtil = StorageUtil();
  String namaUser = '';

  // roles users
  RxInt rolesLihat = 0.obs;
  RxInt rolesBatal = 0.obs;
  RxInt rolesEdit = 0.obs;
  RxInt rolesHapus = 0.obs;

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      roleUser.value = user.tipe;
      rolesLihat.value = user.lihat;
      rolesBatal.value = user.batal;
      rolesEdit.value = user.edit;
      rolesHapus.value = user.hapus;
    }
    fetchRegulerContent();
  }

  Future<void> fetchRegulerContent() async {
    try {
      isLoadingReguler.value = true;
      final getRegulerDo = await doRegulerRepo.fetchDoRegulerData();
      doRealisasiModel.assignAll(getRegulerDo);
    } catch (e) {
      print('Error while fetching data do reguler: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingReguler.value = false;
    }
  }

  Future<void> editRealisasiReguler()async{}

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doRegulerRepo.tambahJumlahUnit(id, user, jumlahUnit);
    await fetchRegulerContent();

    CustomFullScreenLoader.stopLoading();
  }
}
