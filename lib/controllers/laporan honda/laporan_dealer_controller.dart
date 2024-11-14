import 'package:get/get.dart';

import '../../models/laporan honda/laporan_dealer_model.dart';
import '../../repository/laporan honda/laporan_dealer_repo.dart';

class LaporanDealerController extends GetxController {
  final dealerLoading = Rx<bool>(false);
  final LaporanDealerRepository laporanDealerRepo =
      Get.put(LaporanDealerRepository());
  RxList<LaporanDealerModel> dealerModel = <LaporanDealerModel>[].obs;

  Future<void> fetchLaporanEstimasi(String bulan, String tahun) async {
    try {
      dealerLoading.value = true;
      final getLaporanDealer =
          await laporanDealerRepo.fetchLaporanEstimasi(bulan, tahun);
      dealerModel.assignAll(getLaporanDealer);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan estimasi');
    } finally {
      dealerLoading.value = false;
    }
  }

  // Future<void> downloadExcelForDealer(int)
}
