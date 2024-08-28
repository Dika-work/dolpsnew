import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/input data do/do_harian_model.dart';
import '../../repository/input data do/do_harian_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../home/do_harian_home_bsk_controller.dart';
import '../home/do_harian_home_controller.dart';

class DataDoHarianController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingHarian = Rx<bool>(false);
  RxList<DoHarianModel> doHarianModel = <DoHarianModel>[].obs;

  final dataHarianRepo = Get.put(DataDoHarianRepository());

  final dataHarianHomeController = Get.put(DataDOHarianHomeController());
  final dataHarianHomeBskController = Get.put(DoHarianHomeBskController());

  GlobalKey<FormState> addHarianKey = GlobalKey<FormState>();

  final tujuan = '1'.obs;
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  String namaUser = '';

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

  @override
  void onInit() {
    fetchDataDoHarian();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
    }
    // mengubah idPlant berdasarkan plant yg dipilih
    ever(plant, (_) {
      idplant.value = idPlantMap[plant.value] ?? '1';
    });
    super.onInit();
  }

  Future<void> fetchDataDoHarian() async {
    try {
      isLoadingHarian.value = true;
      final dataHarian = await dataHarianRepo.fetchDataHarianContent();
      doHarianModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doHarianModel.assignAll([]);
    } finally {
      isLoadingHarian.value = false;
    }
  }

  Future<void> addDataDOHarian() async {
    CustomDialogs.loadingIndicator();

    if (!addHarianKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    bool isDuplicate = doHarianModel.any((data) =>
        data.idPlant.toString() == idplant.value && data.tgl == tgl.value);

    if (isDuplicate) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Maaf tanggal dan plant sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    await dataHarianRepo.addDataHarian(
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
        plant.value);

    // Clear input fields
    srdController.clear();
    mksController.clear();
    ptkController.clear();
    bjmController.clear();
    plant.value = '1100';
    tujuan.value = '1';

    // Fetch updated data
    await fetchDataDoHarian();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do harian baru..',
    );
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editDOHarian(
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
    await dataHarianRepo.editDOHarianContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoHarian();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOHarian(
    int id,
  ) async {
    CustomDialogs.loadingIndicator();
    await dataHarianRepo.deleteDOHarianContent(id);

    await fetchDataDoHarian();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }
}
