import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data do/do_tambah_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data do/do_tambah_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../home/do_harian_home_bsk_controller.dart';
import '../home/do_harian_home_controller.dart';

class DataDoTambahanController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingTambah = Rx<bool>(false);
  RxList<DoTambahModel> doTambahModel = <DoTambahModel>[].obs;
  final dataTambahRepo = Get.put(DataDoTambahRepository());
  GlobalKey<FormState> addTambahKey = GlobalKey<FormState>();

  final dataHarianHomeController = Get.put(DataDOHarianHomeController());
  final dataHarianHomeBskController = Get.put(DoHarianHomeBskController());

  final tujuan = '1'.obs;
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  String namaUser = '';

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;
  String roleUser = '';
  String rolePlant = '';

  bool get isAdmin => roleUser == 'admin';

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
    fetchDataDoTambah();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
      roleUser = user.tipe;
      rolePlant = user.plant;

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

  Future<void> fetchDataDoTambah() async {
    try {
      isLoadingTambah.value = true;
      final dataTambah = await dataTambahRepo.fetchDataTambahContent();
      if (dataTambah.isNotEmpty) {
        if (isAdmin) {
          doTambahModel.assignAll(dataTambah);
        } else {
          doTambahModel.assignAll(
              dataTambah.where((e) => e.plant == rolePlant).toList());
        }
      } else {
        doTambahModel.assignAll([]);
      }
    } catch (e) {
      print('Error fetching data do harian : $e');
      throw Exception('Gagal saat mengambil data do harian');
    } finally {
      isLoadingTambah.value = false;
    }
  }

  Future<void> addDataDoTambah() async {
    CustomDialogs.loadingIndicator();

    if (!addTambahKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
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

    await dataTambahRepo.addDataTambah(
        idplant.value,
        tujuanDisplayValue,
        tgl.value,
        CustomHelperFunctions.formattedTime,
        srdController.text.trim(),
        mksController.text.trim(),
        ptkController.text.trim(),
        bjmController.text.trim(),
        jumlah5.text.trim(),
        jumlah6.text.trim(),
        namaUser,
        plant.value);

    srdController.clear();
    mksController.clear();
    ptkController.clear();
    bjmController.clear();

    plant.value = '1100';
    tujuan.value = '1';

    await fetchDataDoTambah();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do tambah baru..',
    );
    CustomFullScreenLoader.stopLoading();
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
    CustomDialogs.loadingIndicator();
    await dataTambahRepo.editDOTambahContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoTambah();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOTambah(
    int id,
  ) async {
    CustomDialogs.loadingIndicator();
    await dataTambahRepo.deleteDOTambahContent(id);

    await fetchDataDoTambah();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }
}
