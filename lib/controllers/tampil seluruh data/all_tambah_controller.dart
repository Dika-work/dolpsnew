import 'package:doplsnew/models/tampil%20seluruh%20data/do_tambah_all.dart';
import 'package:doplsnew/repository/tampil%20seluruh%20data/tambah_all_repo.dart';
import 'package:get/get.dart';

class DataAllTambahController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoTambahAllModel> doGlobalHarianModel = <DoTambahAllModel>[].obs;
  final dataGlobalHarianRepo = Get.put(TambahAllRepository());

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
