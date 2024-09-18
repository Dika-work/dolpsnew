import 'package:get/get.dart';

import '../../models/laporan honda/laporan_plant_model.dart';
import '../../repository/laporan honda/laporan_plant_repo.dart';

class LaporanPlantController extends GetxController {
  final isLoading = Rx<bool>(false);
  final isLoadingRealisasi = Rx<bool>(false);
  final LaporanPlantRepository laporanPlantRepo =
      Get.put(LaporanPlantRepository());
  RxList<LaporanPlantModel> laporanModel = <LaporanPlantModel>[].obs;
  RxList<LaporanDoRealisasiModel> laporanRealisasiModel =
      <LaporanDoRealisasiModel>[].obs;

  Future<void> fetchLaporanPlant(String bulan, String tahun) async {
    try {
      isLoading.value = true;
      final getLaporan = await laporanPlantRepo.fetchLaporanPlant(bulan, tahun);
      laporanModel.assignAll(getLaporan);
    } catch (e) {
      print('Error while fetching laporan plant: $e');
      throw Exception('Gagal mengambil data laporan plant');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLaporanRealisasi(String bulan, String tahun) async {
    try {
      isLoadingRealisasi.value = true;
      final getLaporanRealisasi =
          await laporanPlantRepo.fetchLaporanRealisasi(bulan, tahun);
      laporanRealisasiModel.assignAll(getLaporanRealisasi);
    } catch (e) {
      print('Error while fetching laporan do realisasi: $e');
      throw Exception('Gagal mengambil data laporan realisasi');
    } finally {
      isLoadingRealisasi.value = false;
    }
  }
}
