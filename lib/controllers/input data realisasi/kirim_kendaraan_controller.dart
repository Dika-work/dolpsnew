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

  RxString selectedPlant = '1100'.obs;
  RxString selectedTujuan = 'Sunter'.obs;

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    '1900': 'Bekasi'
  };

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

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data do realisasi..',
      );
      isLoadingKendaraan.value = false;
    } else {
      SnackbarLoader.successSnackBar(
        title: 'Gagal',
        message: 'Jumlah kendaraan dan jumlah plot sudah sesuai..',
      );
      isLoadingKendaraan.value = false;
      Get.back();
    }
  }
}
