import 'package:get/get.dart';

import '../../repository/input data realisasi/plot_repo.dart';

class PlotKendaraanController extends GetxController {
  final plotKendaraanRepo = Get.put(PlotRepository());
  RxList<PlotModel> plotModel = <PlotModel>[].obs;
  RxBool isJumlahKendaraanSama = false.obs;

  Future<void> fetchPlot(int idReq, String tgl, int type, String plant,
      int jumlahKendaraan) async {
    try {
      final plot = await plotKendaraanRepo.jumlahPlot(idReq, tgl, type, plant);
      plotModel.assignAll(plot);
      isJumlahKendaraanSama.value =
          plotModel.isNotEmpty && plotModel.first.jumlahPlot == jumlahKendaraan;
    } catch (e) {
      print('error saat mengambil data jumlah plot');
      plotModel.assignAll([]);
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
