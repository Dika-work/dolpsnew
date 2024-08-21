import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_reguler_repo.dart';
import '../../utils/constant/storage_util.dart';
import 'do_mutasi_controller.dart';

class DoRegulerController extends GetxController {
  final isLoadingReguler = Rx<bool>(false);
  final isLoadingRegulerAll = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doRegulerRepo = Get.put(DoRegulerRepository());
  final doMutasiController = Get.put(DoMutasiController());

  String roleUser = '';
  String rolePlant = '';
  final storageUtil = StorageUtil();
  String namaUser = '';

  // roles users
  int rolesLihat = 0;
  int rolesBatal = 0;
  int rolesEdit = 0;
  int rolesJumlah = 0;

  bool get isAdmin => roleUser == 'admin';

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      roleUser = user.tipe;
      rolesLihat = user.lihat;
      rolesBatal = user.batal;
      rolesEdit = user.edit;
      rolesJumlah = user.jumlah;
    }

    print("rolesLihat: $rolesLihat");
    print("rolesBatal: $rolesBatal");
    print("rolesEdit: $rolesEdit");
    print("rolesJumlah: $rolesJumlah");
    print("roleUser: $roleUser");

    fetchRegulerContent();
  }

  Future<void> fetchRegulerContent() async {
    try {
      isLoadingReguler.value = true;
      final getRegulerDo = await doRegulerRepo.fetchDoRegulerData();

      if (getRegulerDo.isNotEmpty) {
        if (isAdmin) {
          doRealisasiModel.assignAll(getRegulerDo);
        } else {
          doRealisasiModel.assignAll(
              getRegulerDo.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doRealisasiModel.assignAll([]);
      }
    } catch (e) {
      print('Error while fetching data do reguler asad: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingReguler.value = false;
    }
  }

  Future<void> fetchRegulerAllContent() async {
    try {
      isLoadingRegulerAll.value = true;
      final getRegulerDo = await doRegulerRepo.fetchAllRegulerData();
      doRealisasiModel.assignAll(getRegulerDo);
    } catch (e) {
      print('Error while fetching data do reguler zzzz: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingRegulerAll.value = false;
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

    await doRegulerRepo.editDoReguler(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchRegulerContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doRegulerRepo.tambahJumlahUnit(id, user, jumlahUnit);
    await fetchRegulerContent();
    await doMutasiController.fetchMutasiContent();

    CustomFullScreenLoader.stopLoading();
  }
}
