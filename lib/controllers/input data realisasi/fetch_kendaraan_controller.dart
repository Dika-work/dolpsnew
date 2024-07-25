import 'package:get/get.dart';

import '../../models/input data realisasi/kendaraan_model.dart';
import '../../repository/input data realisasi/kendaraan_repo.dart';

class FetchKendaraanController extends GetxController {
  final kendaraanRepo = Get.put(KendaraanRepository());
  RxList<KendaraanModel> kendaraanModel = <KendaraanModel>[].obs;
  RxString selectedKendaraan = ''.obs;
  RxString selectedJenisKendaraan = ''.obs;
  RxInt selectedKendaraanId = 0.obs;

  @override
  void onInit() {
    fetchKendaraanData();
    super.onInit();
  }

  Future<void> fetchKendaraanData() async {
    try {
      final dataKendaraan = await kendaraanRepo.fetchKendaraanContent();
      kendaraanModel.assignAll(dataKendaraan);
    } catch (e) {
      print('Error while fetching kendaraan data : $e');
      kendaraanModel.assignAll([]);
    }
  }

  List<KendaraanModel> get filteredKendaraanModel {
    if (selectedJenisKendaraan.value.isEmpty) {
      return kendaraanModel;
    }
    return kendaraanModel
        .where(
          (kendaraan) => kendaraan.jenisKendaraan
              .toLowerCase()
              .contains(selectedJenisKendaraan.value.toLowerCase()),
        )
        .toList();
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredKendaraanModel.firstWhere(
      (kendaraan) => kendaraan.noPolisi == value,
      orElse: () => KendaraanModel(
        idKendaraan: 0,
        noPolisi: '',
        jenisKendaraan: '',
        kapasitas: '',
        merek: '',
        type: '',
      ),
    );

    selectedKendaraan.value = kendaraan.noPolisi;
    selectedKendaraanId.value = kendaraan.idKendaraan;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedJenisKendaraan.value = jenis;
    updateSelectedKendaraan(selectedKendaraan.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedKendaraan.value = '';
    selectedKendaraanId.value = 0;
  }
}
