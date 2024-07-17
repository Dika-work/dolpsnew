import 'package:doplsnew/models/home/do_harian_home.dart';
import 'package:doplsnew/repository/home/do_harian_home_repo.dart';
import 'package:get/get.dart';

class DataDOHarianHomeController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianHomeModel> doGlobalHarianModel = <DoHarianHomeModel>[].obs;
  final dataGlobalHarianRepo = Get.put(DoHarianHomeRepository());

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
