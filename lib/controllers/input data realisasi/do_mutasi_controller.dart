import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../repository/input data realisasi/do_mutasi_repo.dart';

class DoMutasiController extends GetxController {
  final isLoadingMutasi = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doMutasiRepo = Get.put(DoMutasiRepository());

  @override
  void onInit() {
    super.onInit();
    fetchMutasiContent();
  }

  Future<void> fetchMutasiContent() async {
    try {
      isLoadingMutasi.value = true;
      final getMutasiDo = await doMutasiRepo.fetchDoMutasiData();
      doRealisasiModel.assignAll(getMutasiDo);
    } catch (e) {
      print('Error while fetching data do Mutasi: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingMutasi.value = false;
    }
  }
}
