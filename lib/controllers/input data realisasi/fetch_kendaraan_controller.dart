import 'package:get/get.dart';

import '../../models/input data realisasi/kendaraan_model.dart';
import '../../repository/input data realisasi/kendaraan_repo.dart';

class FetchKendaraanController extends GetxController {
  final kendaraanRepo = Get.put(KendaraanRepository());
  RxList<KendaraanModel> kendaraanModel = <KendaraanModel>[].obs;
  RxString selectedKendaraan = ''.obs;
  RxString selectedJenisKendaraan = ''.obs;

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

  List<KendaraanModel> get filteredKendaraanModel {
    if (selectedJenisKendaraan.isEmpty) {
      return [];
    }
    return kendaraanModel.where((kendaraan) {
      return kendaraan.jenisKendaraan == selectedJenisKendaraan.value;
    }).toList();
  }

  void updateSelectedKendaraan() {
    if (filteredKendaraanModel.isNotEmpty) {
      selectedKendaraan.value = filteredKendaraanModel.first.noPolisi;
    } else {
      selectedKendaraan.value = '';
    }
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedJenisKendaraan.value = jenis;
    updateSelectedKendaraan();
  }
}
