import 'package:doplsnew/models/home/do_harian_home_bsk.dart';
import 'package:doplsnew/repository/home/do_harian_home_bsk_repo.dart';
import 'package:get/get.dart';

class DoHarianHomeBskController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoHarianHomeBskModel> doGlobalHarianModel =
      <DoHarianHomeBskModel>[].obs;
  final dataGlobalHarianRepo = Get.put(DoHarianHomeBskRepository());

  @override
  void onInit() {
    fetchHarianBesok();
    super.onInit();
  }

  Future<void> fetchHarianBesok() async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian =
          await dataGlobalHarianRepo.fetchGlobalHarianBesokContent();
      doGlobalHarianModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }
}
