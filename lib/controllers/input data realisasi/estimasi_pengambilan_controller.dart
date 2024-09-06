import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../repository/input data realisasi/estimasi_penambilan_repo.dart';

class EstimasiPengambilanController extends GetxController {
  final isLoadingEstimasi = Rx<bool>(false);
  RxList<EstimasiPengambilanModel> estimasiPengambilanModel =
      <EstimasiPengambilanModel>[].obs;
  final estimasiPengambilanRepo = Get.put(EstimasiPenambilanRepository());
  GlobalKey<FormState> estimasiKey = GlobalKey<FormState>();

  @override
  void onInit() {
    loadDataEstimasiPengambilan();
    super.onInit();
  }

  Future<void> loadDataEstimasiPengambilan() async {
    try {
      isLoadingEstimasi.value = true;
      final estimasiPengambilan =
          await estimasiPengambilanRepo.fetchEstimasiPengambilan();
      estimasiPengambilanModel.assignAll(estimasiPengambilan);
    } catch (e) {
      estimasiPengambilanModel.assignAll([]);
    } finally {
      isLoadingEstimasi.value = false;
    }
  }
}
