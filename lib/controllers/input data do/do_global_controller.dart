import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data do/do_global_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data do/do_global_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../home/do_global_harian_controller.dart';

class DataDOGlobalController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingGlobal = Rx<bool>(false);
  RxList<DoGlobalModel> doGlobalModel = <DoGlobalModel>[].obs;
  final dataGlobalRepo = Get.put(DataDoGlobalRepository());
  final doGlobalHarianController = Get.put(DataDOGlobalHarianController());
  GlobalKey<FormState> addGlobalKey = GlobalKey<FormState>();

  final tujuan = '1'.obs;
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  String namaUser = '';
  String roleUser = '';
  String rolePlant = '';

  bool get isAdmin => roleUser == 'admin';

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;

  final srdController = TextEditingController();
  final mksController = TextEditingController();
  final ptkController = TextEditingController();
  final bjmController = TextEditingController();
  final jumlah5 = TextEditingController(text: '0');
  final jumlah6 = TextEditingController(text: '0');

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  final Map<String, String> idPlantMap = {
    '1100': '1', //1
    '1200': '2', //2
    '1300': '3', //3
    '1350': '4', //4
    '1700': '5', //5
    '1800': '6', //6
    '1900': '9', //9
  };

  String get tujuanDisplayValue => tujuanMap[plant.value] ?? '';

  String get idPlantValue => idPlantMap[idplant.value] ?? '';

  @override
  void onInit() {
    fetchDataDoGlobal();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
      roleUser = user.tipe;
      rolePlant = user.plant;

      // nyesuain plant dengan tipe admin atau bukan
      if (!isAdmin) {
        plant.value = rolePlant;
        idplant.value = idPlantMap[rolePlant] ?? '1';
        tujuan.value = idPlantMap[plant.value] ?? '1';
      } else {
        idplant.value = idPlantMap[plant.value] ?? '1';
      }
    }
    // mengubah idPlant berdasarkan plant yg dipilih
    ever(plant, (_) {
      idplant.value = idPlantMap[plant.value] ?? '1';
    });
    super.onInit();
  }

  Future<void> fetchDataDoGlobal() async {
    try {
      isLoadingGlobal.value = true;
      final dataGlobal = await dataGlobalRepo.fetchDataGlobalContent();
      if (dataGlobal.isNotEmpty) {
        if (isAdmin) {
          doGlobalModel.assignAll(dataGlobal);
        } else {
          doGlobalModel.assignAll(
              dataGlobal.where((e) => e.plant == rolePlant).toList());
        }
      } else {
        doGlobalModel.assignAll([]);
      }
    } catch (e) {
      print('Error fetching data do Global : $e');
      throw Exception('Gagal saat mengambil data do global');
    } finally {
      isLoadingGlobal.value = false;
    }
  }

  Future<void> addDataDOGlobal() async {
    CustomDialogs.loadingIndicator();

    if (!addGlobalKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    bool isDuplicate = doGlobalModel.any((data) =>
        data.idPlant.toString() == idplant.value && data.tgl == tgl.value);

    if (isDuplicate) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Maaf tanggal dan plant sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    await dataGlobalRepo.addDataGlobal(
      idplant.value,
      tujuanDisplayValue,
      tgl.value,
      CustomHelperFunctions.formattedTime,
      srdController.text,
      mksController.text,
      ptkController.text,
      bjmController.text,
      jumlah5.text,
      jumlah6.text,
      namaUser,
    );
    print('Stopped loading dialog');

    srdController.clear();
    mksController.clear();
    ptkController.clear();
    bjmController.clear();

    plant.value = '1100';
    tujuan.value = '1';

    await fetchDataDoGlobal();
    await doGlobalHarianController.fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do global baru..',
    );
    CustomFullScreenLoader.stopLoading();
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

    await dataGlobalRepo.editDOGlobalContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoGlobal();
    await doGlobalHarianController.fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOGlobal(
    int id,
  ) async {
    CustomDialogs.loadingIndicator();
    await dataGlobalRepo.deleteDOGlobalContent(id);

    await fetchDataDoGlobal();
    await doGlobalHarianController.fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }
}
