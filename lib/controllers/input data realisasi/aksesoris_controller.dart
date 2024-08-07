import 'package:get/get.dart';

import '../../models/input data realisasi/aksesoris_model.dart';
import '../../repository/input data realisasi/aksesoris_repo.dart';

class AksesorisController extends GetxController {
  final isLoadingAksesoris = Rx<bool>(false);
  final AksesorisRepository aksesorisRepo = Get.put(AksesorisRepository());
  RxList<AksesorisModel> aksesorisModel = <AksesorisModel>[].obs;
  RxList<bool> checkboxStatus = RxList<bool>.filled(
      10, false); // Sesuaikan panjang list sesuai jumlah checkbox

  Future<void> fetchAksesoris(int id) async {
    try {
      isLoadingAksesoris.value = true;
      final getAksesoris = await aksesorisRepo.fetchAksesoris(id);
      aksesorisModel.assignAll(getAksesoris);
    } catch (e) {
      print('Error while fetching aksesoris: $e');
    } finally {
      isLoadingAksesoris.value = false;
    }
  }

  bool get areAllCheckboxesChecked =>
      checkboxStatus.every((status) => status == true);
}
