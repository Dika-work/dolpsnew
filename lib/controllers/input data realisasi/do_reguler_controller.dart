import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../repository/input data realisasi/do_reguler_repo.dart';

class DoRegulerController extends GetxController {
  final isLoadingReguler = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  final doRegulerRepo = Get.put(DoRegulerRepository());

  @override
  void onInit() {
    super.onInit();
    fetchRegulerContent();
  }

  Future<void> fetchRegulerContent() async {
    try {
      isLoadingReguler.value = true;
      final getRegulerDo = await doRegulerRepo.fetchDoRegulerData();
      doRealisasiModel.assignAll(getRegulerDo);
    } catch (e) {
      print('Error while fetching data do reguler: $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingReguler.value = false;
    }
  }
}
