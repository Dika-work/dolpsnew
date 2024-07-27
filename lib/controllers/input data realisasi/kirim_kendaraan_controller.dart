import 'package:doplsnew/controllers/input%20data%20realisasi/fetch_kendaraan_controller.dart';
import 'package:doplsnew/controllers/input%20data%20realisasi/fetch_sopir_controller.dart';
import 'package:doplsnew/controllers/input%20data%20realisasi/plot_kendaraan_controller.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/kirim_kendaraan_model.dart';
import '../../repository/input data realisasi/kirim_kendaraan_repo.dart';

class KirimKendaraanController extends GetxController {
  final isLoadingKendaraan = Rx<bool>(false);
  RxList<KirimKendaraanModel> kirimKendaraanModel = <KirimKendaraanModel>[].obs;
  final kirimKendaraanRepo = Get.put(KirimKendaraanRepository());
  final jumlahPlotKendaraan = Get.put(PlotKendaraanController());
  final noPolisiController = Get.put(FetchKendaraanController());
  final supirController = Get.put(FetchSopirController());
  final plotController = Get.put(PlotKendaraanController());

  RxString selectedPlant = '1300'.obs;
  RxString selectedTujuan = 'Cibitung'.obs;

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    '1900': 'Bekasi'
  };

  // @override
  // void onInit() {
  //   fetchDataKirimKendaraan();
  //   super.onInit();
  // }

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
    isLoadingKendaraan.value = true;

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
    } else {
      SnackbarLoader.successSnackBar(
        title: 'Gagal',
        message: 'Jumlah kendaraan dan jumlah plot sudah sesuai..',
      );
    }
    isLoadingKendaraan.value = false;
  }

  Future<void> hapusKirimKendaraan(
      int idReq, String tgl, int type, String plant, int id) async {
    try {
      isLoadingKendaraan.value = true;

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
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus kirim kendaraan😒',
      );
    } finally {
      isLoadingKendaraan.value = false;
    }
  }
}
