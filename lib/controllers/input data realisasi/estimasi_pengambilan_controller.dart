import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/estimasi_penambilan_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class EstimasiPengambilanController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingEstimasi = Rx<bool>(false);

  RxList<EstimasiPengambilanModel> estimasiPengambilanModel =
      <EstimasiPengambilanModel>[].obs;

  final estimasiPengambilanRepo = Get.put(EstimasiPenambilanRepository());

  GlobalKey<FormState> addEstimasiPmKey = GlobalKey<FormState>();

  final tgl = CustomHelperFunctions.getFormattedDateDatabase(DateTime.now());
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  final typeDO = 'REGULER'.obs;
  final typeDOValue = 0.obs;
  final jenisKendaraan = 'MOBIL MOTOR 16'.obs;

  String namaUser = '';
  TextEditingController jumlahController = TextEditingController();

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

  final Map<String, int> typeDOMap = {
    'REGULER': 0,
    'MUTASI': 1,
  };

  final List<String> jenisKendaraanList = [
    'MOBIL MOTOR 16',
    'MOBIL MOTOR 40',
    'MOBIL MOTOR 64',
    'MOBIL MOTOR 86',
  ];

  String get tujuanDisplayValue => tujuanMap[plant.value] ?? '';

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
    }
    ever(plant, (_) {
      idplant.value = idPlantMap[plant.value] ?? '1';
    });
    ever(typeDO, (_) {
      typeDOValue.value = typeDOMap[typeDO.value] ?? 0;
    });
  }

  Future<void> loadDataEstimasiPengambilan() async {
    try {
      isLoadingEstimasi.value = true;
      final estimasiPengambilan =
          await estimasiPengambilanRepo.fetchEstimasiPengambilan();
      estimasiPengambilanModel.assignAll(estimasiPengambilan);
    } catch (e) {
      estimasiPengambilanModel.assignAll([]);
    } finally {
      isLoadingEstimasi.value = false;
    }
  }

  Future<void> addEstimasiPengambilanMotor() async {
    CustomDialogs.loadingIndicator();

    if (!addEstimasiPmKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    await estimasiPengambilanRepo.addEstimasiPengambilanMotor(
        idplant.value,
        tujuanDisplayValue,
        typeDOValue.value,
        jenisKendaraan.value,
        jumlahController.text.trim(),
        namaUser,
        CustomHelperFunctions.formattedTime,
        tgl);

    jumlahController.clear();
    plant.value = '1100';
    await loadDataEstimasiPengambilan();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan estimasi pengambilan motor baru..',
    );
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editEstimasiPengambilanMotor(
      int idPlot,
      int idPlant,
      String tujuan,
      int type,
      String jenisKen,
      int jumlah,
      String user,
      String jam,
      String tgl) async {
    CustomDialogs.loadingIndicator();

    await estimasiPengambilanRepo.editEstimasiPengambilanMotor(
      idPlot,
      idPlant,
      tujuan,
      type,
      jenisKen,
      jumlah,
      user,
      jam,
      tgl,
    );

    await loadDataEstimasiPengambilan();
    CustomFullScreenLoader.stopLoading();
    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Berhasil memperbarui estimasi pengambilan motor.',
    );
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusEstimasiPengambilan(int idPlot) async {
    CustomDialogs.loadingIndicator();
    await estimasiPengambilanRepo.deleteEstimasiPengambilanMotor(idPlot);

    await loadDataEstimasiPengambilan();
    CustomFullScreenLoader.stopLoading();
  }
}
