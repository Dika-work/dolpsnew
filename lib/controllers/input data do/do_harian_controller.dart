import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/do_harian_model.dart';
import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/repository/input%20data%20do/do_harian_repo.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../utils/popups/snackbar.dart';

class DataDoHarianController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingHarian = Rx<bool>(false);
  RxList<DoHarianModel> doHarianModel = <DoHarianModel>[].obs;
  final dataHarianRepo = Get.put(DataDoHarianRepository());
  GlobalKey<FormState> addHarianKey = GlobalKey<FormState>();

  final tujuan = '1'.obs;
  final tgl = ''.obs;
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  String namaUser = '';

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
    fetchDataDoHarian();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
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
    const CustomCircularLoader();

    if (!addHarianKey.currentState!.validate()) {
      print('Form validation do harian failed');
      return;
    }

    bool isDuplicate = doHarianModel.any((data) =>
        data.idPlant.toString() == idplant.value && data.tgl == tgl.value);

    if (isDuplicate) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Maaf tanggal dan plant sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    try {
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
      print('Stopped loading dialog');
      CustomFullScreenLoader.stopLoading();

      srdController.clear();
      mksController.clear();
      ptkController.clear();
      bjmController.clear();

      tgl.value = '';
      plant.value = '1100';
      tujuan.value = '1';

      await fetchDataDoHarian();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data user baru..',
      );
    } catch (e) {
      print('Error while adding data: $e');
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }
}
