import 'package:get/get.dart';

import '../../models/input data realisasi/sopir_model.dart';
import '../../repository/input data realisasi/sopir_repo.dart';

class FetchSopirController extends GetxController {
  final sopirRepo = Get.put(SopirRepository());
  RxList<SopirModel> sopirModel = <SopirModel>[].obs;
  RxString selectedSopir = ''.obs;

  @override
  void onInit() {
    fetchSopirData();
    super.onInit();
  }

  Future<void> fetchSopirData() async {
    try {
      final dataSopir = await sopirRepo.fetchGlobalHarianContent();
      sopirModel.assignAll(dataSopir);
      if (sopirModel.isNotEmpty) {
        selectedSopir.value =
            '${sopirModel.first.nama} - (${sopirModel.first.namaPanggilan})';
      }
    } catch (e) {
      print('Error while fetching sopir data: $e');
      sopirModel.assignAll([]);
    }
  }
}
