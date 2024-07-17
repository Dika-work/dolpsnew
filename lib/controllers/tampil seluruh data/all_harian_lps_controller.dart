import 'package:doplsnew/models/tampil%20seluruh%20data/do_harian_all_lps.dart';
import 'package:doplsnew/repository/tampil%20seluruh%20data/harian_all_lps_repo.dart';
import 'package:get/get.dart';

class DataAllHarianLpsController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianAllLpsModel> doGlobalHarianModel = <DoHarianAllLpsModel>[].obs;
  final dataGlobalHarianRepo = Get.put(GlobalHarianAllLpsRepository());

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
