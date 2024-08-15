import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_mutasi_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';

class DoMutasiController extends GetxController {
  final isLoadingMutasi = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doMutasiRepo = Get.put(DoMutasiRepository());

  // roles users
  int rolesLihat = 0;
  int rolesBatal = 0;
  int rolesEdit = 0;
  int rolesJumlah = 0;

  final storageUtil = StorageUtil();

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      rolesLihat = user.lihat;
      rolesBatal = user.batal;
      rolesEdit = user.edit;
      rolesJumlah = user.jumlah;
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

  Future<void> fetchMutasiAllContent() async {
    try {
      isLoadingMutasi.value = true;
      final getRegulerDo = await doMutasiRepo.fetchAllMutasiData();
      doRealisasiModel.assignAll(getRegulerDo);
    } catch (e) {
      print('Error while fetching data do mutasi zzzz: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingMutasi.value = false;
    }
  }

  Future<void> editRealisasiReguler(
      int id,
      String plant,
      String tujuan,
      int type,
      String plant2,
      String tujuan2,
      String kendaraan,
      String supir,
      int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doMutasiRepo.editDoMutasi(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchMutasiContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doMutasiRepo.tambahJumlahUnit(id, user, jumlahUnit);
    await fetchMutasiContent();

    CustomFullScreenLoader.stopLoading();
  }
}
