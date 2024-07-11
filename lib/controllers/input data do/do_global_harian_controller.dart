import 'package:doplsnew/models/do_global_harian.dart';
import 'package:doplsnew/repository/do_global_harian_repo.dart';
import 'package:get/get.dart';

import '../../utils/constant/storage_util.dart';

class DataDOGlobalHarianController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoGlobalHarianModel> doGlobalHarianModel = <DoGlobalHarianModel>[].obs;
  final dataGlobalHarianRepo = Get.put(DoGlobalHarianRepository());

  @override
  void onInit() {
    fetchDataDoGlobal();
    super.onInit();
  }

  Future<void> fetchDataDoGlobal() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();
      doGlobalHarianModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }
}
