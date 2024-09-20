import 'package:get/get.dart';

import '../../models/laporan honda/laporan_realisasi_model.dart';
import '../../repository/laporan honda/laporan_realisasi_repo.dart';

class LaporanRealisasiController extends GetxController {
  final isLoading = Rx<bool>(false);
  final LaporanRealisasiRepository laporanRealisasiRepo =
      Get.put(LaporanRealisasiRepository());
  RxList<LaporanRealisasiModel> laporanRealisasiModel =
      <LaporanRealisasiModel>[].obs;

  Future<void> fetchLaporanRealisasi(String bulan, String tahun) async {
    try {
      isLoading.value = true;
      final getLaporanRealisasi =
          await laporanRealisasiRepo.fetchLaporanRealisasi(bulan, tahun);
      laporanRealisasiModel.assignAll(getLaporanRealisasi);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan realisasi untuk saat ini');
    } finally {
      isLoading.value = false;
    }
  }
}
