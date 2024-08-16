import 'package:get/get.dart';

import '../../models/input data realisasi/hutang_reguler_model.dart';
import '../../repository/input data realisasi/hutang_repo.dart';

class HutangRegulerController extends GetxController {
  final isLoadingHutang = Rx<bool>(false);
  RxList<HutangRegulerModel> doHutang = <HutangRegulerModel>[].obs;
  RxList<AlatKelengkapanModel> doKelengkapan = <AlatKelengkapanModel>[].obs;
  final hutangRepo = Get.put(HutangRepository());

  Future<void> fetchHutang(int id) async {
    try {
      isLoadingHutang.value = true;
      final getHutang = await hutangRepo.fetchHutang(id);
      doHutang.assignAll(getHutang);
    } catch (e) {
      print('Error while fetching data do Mutasi: $e');
      doHutang.assignAll([]);
    } finally {
      isLoadingHutang.value = false;
    }
  }

  Future<void> fetchKelengkapan(int id) async {
    try {
      isLoadingHutang.value = true;
      final getKelengkapan = await hutangRepo.fetchKelengkapan(id);
      doKelengkapan.assignAll(getKelengkapan);
      print('Data Kelengkapan Diterima: ${doKelengkapan.length} items');
    } catch (e) {
      print('Error while fetching data do Mutasi: $e');
      doKelengkapan.assignAll([]);
    } finally {
      isLoadingHutang.value = false;
    }
  }
}
