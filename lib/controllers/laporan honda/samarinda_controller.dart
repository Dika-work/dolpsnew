import 'package:get/get.dart';

import '../../models/laporan honda/samarinda_model.dart';
import '../../repository/laporan honda/samarinda_repo.dart';

class SamarindaController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<SamarindaModel> samarindaModel = <SamarindaModel>[].obs;
  final SamarindaRepository samarindaRepo = Get.put(SamarindaRepository());

  Future<void> fetchLaporanSamarinda(int tahun) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchLaporanSamarinda(tahun);
      samarindaModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }
}
