import 'package:get/get.dart';

import '../../models/input data realisasi/kendaraan_model.dart';
import '../../repository/input data realisasi/kendaraan_repo.dart';

class FetchKendaraanController extends GetxController {
  final kendaraanRepo = Get.put(KendaraanRepository());
  RxList<KendaraanModel> kendaraanModel = <KendaraanModel>[].obs;
  RxString selectedKendaraan = ''.obs;

  @override
  void onInit() {
    fetchKendaraanData();
    super.onInit();
  }

  Future<void> fetchKendaraanData() async {
    try {
      final dataKendaraan = await kendaraanRepo.fetchKendaraanContent();
      kendaraanModel.assignAll(dataKendaraan);
      if (selectedKendaraan.isNotEmpty) {
        selectedKendaraan.value = kendaraanModel.first.noPolisi;
      }
    } catch (e) {
      print('Error while fetching kendaraan data : $e');
      kendaraanModel.assignAll([]);
    }
  }
}
