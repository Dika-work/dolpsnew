import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/kirim_kendaraan_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/kirim_kendaraan_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import 'fetch_kendaraan_controller.dart';
import 'fetch_sopir_controller.dart';
import 'plot_kendaraan_controller.dart';
import 'request_kendaraan_controller.dart';

class KirimKendaraanController extends GetxController {
  final isLoadingKendaraan = Rx<bool>(false);
  final storageUtil = StorageUtil();
  RxList<KirimKendaraanModel> kirimKendaraanModel = <KirimKendaraanModel>[].obs;
  final kirimKendaraanRepo = Get.put(KirimKendaraanRepository());
  final jumlahPlotKendaraan = Get.put(PlotKendaraanController());
  final noPolisiController = Get.put(FetchKendaraanController());
  final supirController = Get.put(FetchSopirController());
  final plotController = Get.put(PlotKendaraanController());
  final reqController = Get.put(RequestKendaraanController());

  GlobalKey<FormState> kirimKendaraanKey = GlobalKey<FormState>();

  RxString selectedPlant = '1300'.obs;
  RxString selectedTujuan = 'Cibitung'.obs;
  String roleUser = '';

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    '1900': 'Bekasi'
  };

  @override
  void onInit() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleUser = user.tipe;
      print("User Role: $roleUser");
    }
    super.onInit();
  }

  Future<void> fetchDataKirimKendaraan(
      int type, String plant, int idReq) async {
    try {
      isLoadingKendaraan.value = true;
      final getKirimKendaraan =
          await kirimKendaraanRepo.fetchKirimKendaraan(type, plant, idReq);
      kirimKendaraanModel.assignAll(getKirimKendaraan);
    } catch (e) {
      print('Error while fetching data kirim kendaraan: $e');
      kirimKendaraanModel.assignAll([]);
    } finally {
      isLoadingKendaraan.value = false;
    }
  }

  void updateSelectedPlant(String plant) {
    selectedPlant.value = plant;
    selectedTujuan.value = tujuanMap[plant] ?? '';
  }

  Future<void> addKirimKendaraanContent(
    int idReq,
    int jumlahKendaraan,
    String plant,
    String tujuan,
    String plant2,
    String tujuan2,
    int type,
    int kendaraan,
    String supir,
    String jam,
    String tgl,
    int bulan,
    int tahun,
    String user,
  ) async {
    CustomDialogs.loadingIndicator();

    if (!kirimKendaraanKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    // Menambahkan plot kendaraan sesuai jumlah
    await jumlahPlotKendaraan.fetchPlot(
        idReq, tgl, type, plant, jumlahKendaraan);
    final jumlahPlot = jumlahPlotKendaraan.plotModel.first.jumlahPlot;
    if (jumlahKendaraan != jumlahPlot) {
      await kirimKendaraanRepo.addKirimKendaraan(
        idReq,
        plant,
        tujuan,
        plant2,
        tujuan2,
        type,
        kendaraan,
        supir,
        jam,
        tgl,
        bulan,
        tahun,
        user,
      );

      noPolisiController.resetSelectedKendaraan();
      supirController.resetSelectedSopir();
      await plotController.fetchPlot(idReq, tgl, type, plant, jumlahKendaraan);
      await fetchDataKirimKendaraan(type, plant, idReq);

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data do realisasi..',
      );
      CustomFullScreenLoader.stopLoading();
    } else {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.successSnackBar(
        title: 'Gagal',
        message: 'Jumlah kendaraan dan jumlah plot sudah sesuai..',
      );
    }
  }

  Future<void> hapusKirimKendaraan(
      int idReq, String tgl, int type, String plant, int id) async {
    CustomDialogs.loadingIndicator();
    print("Mulai hapus kirim kendaraan...");
    await kirimKendaraanRepo.hapusKirimKendaraan(id);

    final jumlahKendaraan =
        await plotController.getJumlahKendaraan(idReq, tgl, type, plant);
    await plotController.fetchPlot(idReq, tgl, type, plant, jumlahKendaraan);
    plotController.isJumlahKendaraanSama.value = false;

    // Debug: Periksa status setelah fetchPlot
    print(
        "isJumlahKendaraanSama setelah hapus: ${plotController.isJumlahKendaraanSama.value}");

    await fetchDataKirimKendaraan(type, plant, idReq);
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> selesaiKirimKendaraan(int idReq) async {
    CustomDialogs.loadingIndicator();
    await kirimKendaraanRepo.selesaiKirimKendaraan(idReq);
    await reqController.fetchRequestKendaraan();

    CustomFullScreenLoader.stopLoading();
  }
}
