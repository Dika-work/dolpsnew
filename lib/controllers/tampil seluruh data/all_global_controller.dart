import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_global_all.dart';
import '../../repository/tampil seluruh data/global_all_repo.dart';

class DataAllGlobalController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoGlobalAllModel> doAllGlobalModel = <DoGlobalAllModel>[].obs;
  final dataGlobalAllRepo = Get.put(GlobalAllRepository());

  @override
  void onInit() {
    fetchAllGlobalData();
    super.onInit();
  }

  Future<void> fetchAllGlobalData() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalAllRepo.fetchGlobalHarianContent();
      doAllGlobalModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doAllGlobalModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }
}
