import 'package:get/get.dart';

import '../../repository/input data realisasi/plot_repo.dart';
import '../../utils/popups/snackbar.dart';

class PlotKendaraanController extends GetxController {
  final plotKendaraanRepo = Get.put(PlotRepository());
  RxList<PlotModel> plotModel = <PlotModel>[].obs;
  RxBool isJumlahKendaraanSama = false.obs;

  Future<void> fetchPlot(int idReq, String tgl, int type, String plant,
      int jumlahKendaraan) async {
    try {
      final plot = await plotKendaraanRepo.jumlahPlot(idReq, tgl, type, plant);
      plotModel.assignAll(plot);

      // Log data detail
      print(
          "PlotModel setelah fetch: ${plot.map((e) => e.jumlahPlot).toList()}");

      isJumlahKendaraanSama.value =
          plotModel.isNotEmpty && plotModel.first.jumlahPlot == jumlahKendaraan;

      // Log nilai isJumlahKendaraanSama
      print(
          "isJumlahKendaraanSama setelah fetch: ${isJumlahKendaraanSama.value}");
    } catch (e) {
      print('Error saat mengambil data jumlah plot');
      plotModel.assignAll([]);
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data jumlah plot. Silakan coba lagi.',
      );
    }
  }

  Future<int> getJumlahKendaraan(
      int idReq, String tgl, int type, String plant) async {
    try {
      final plot = await plotKendaraanRepo.jumlahPlot(idReq, tgl, type, plant);
      final jumlahKendaraan = plot.isNotEmpty ? plot.first.jumlahPlot : 0;

      // Log jumlah kendaraan
      print("Jumlah kendaraan: $jumlahKendaraan");

      return jumlahKendaraan;
    } catch (e) {
      print('Error saat menghitung jumlah kendaraan');
      return 0;
    }
  }
}

class PlotModel {
  int jumlahPlot;

  PlotModel({
    required this.jumlahPlot,
  });

  factory PlotModel.fromJson(Map<String, dynamic> json) {
    return PlotModel(
      jumlahPlot: json['jumlah_plot'] ?? 0,
    );
  }
}
