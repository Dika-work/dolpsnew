import 'package:doplsnew/models/input%20data%20do/do_tambah_model.dart';
import 'package:doplsnew/repository/input%20data%20do/do_tambah_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/user_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataDoTambahanController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingTambah = Rx<bool>(false);
  RxList<DoTambahModel> doTambahModel = <DoTambahModel>[].obs;
  final dataTambahRepo = Get.put(DataDoTambahRepository());
  GlobalKey<FormState> addTambahKey = GlobalKey<FormState>();

  final tujuan = '1'.obs;
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
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
    fetchDataDoTambah();
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

  Future<void> fetchDataDoTambah() async {
    try {
      isLoadingTambah.value = true;
      final dataTambah = await dataTambahRepo.fetchDataTambahContent();
      doTambahModel.assignAll(dataTambah);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doTambahModel.assignAll([]);
    } finally {
      isLoadingTambah.value = false;
    }
  }

  Future<void> addDataDoTambah() async {
    const CustomCircularLoader();

    if (!addTambahKey.currentState!.validate()) {
      print('Form validation do harian failed');
      return;
    }

    bool isDuplicate = doTambahModel.any((data) =>
        data.idPlant.toString() == idplant.value && data.tgl == tgl.value);

    if (isDuplicate) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Maaf tanggal dan plant sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    try {
      await dataTambahRepo.addDataTambah(
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

      plant.value = '1100';
      tujuan.value = '1';

      await fetchDataDoTambah();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data do tambah baru..',
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

  Future<void> editDOTambah(
    int id,
    String tgl,
    int idPlant,
    String tujuan,
    int srd,
    int mks,
    int ptk,
    int bjm,
  ) async {
    const CustomCircularLoader();

    try {
      await dataTambahRepo.editDOTambahContent(
          id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);

      fetchDataDoTambah();
      CustomFullScreenLoader.stopLoading();
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Tambah😒',
      );
    }
  }
}
