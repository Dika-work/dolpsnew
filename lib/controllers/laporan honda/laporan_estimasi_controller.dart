import 'package:get/get.dart';

import '../../models/laporan honda/laporan_estimasi_model.dart';
import '../../repository/laporan honda/laporan_estimasi_repo.dart';

class LaporanEstimasiController extends GetxController {
  final loadingLaporanEstimasi = Rx<bool>(false);
  final LaporanEstimasiRepository laporanEstimasiRepository =
      Get.put(LaporanEstimasiRepository());
  RxList<LaporanEstimasiModel> laporanEstimasiModel =
      <LaporanEstimasiModel>[].obs;

  Future<void> fetchLaporanEstimasi(String bulan, String tahun) async {
    try {
      loadingLaporanEstimasi.value = true;
      final getLaporanEstimasi =
          await laporanEstimasiRepository.fetchLaporanEstimasi(bulan, tahun);
      laporanEstimasiModel.assignAll(getLaporanEstimasi);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan estimasi');
    } finally {
      loadingLaporanEstimasi.value = false;
    }
  }
}
