import 'package:get/get.dart';

import '../../models/input data realisasi/lihat_kendaraan_model.dart';
import '../../repository/input data realisasi/lihat_kendaraan_repo.dart';

class LihatKendaraanController extends GetxController {
  final isLoadingLihat = Rx<bool>(false);

  final lihatKendaraanRepo = Get.put(LihatKendaraanRepository());
  RxList<LihatKendaraanModel> lihatModel = <LihatKendaraanModel>[].obs;

  Future<void> fetchLihatKendaraan(int type, String plant, int idReq) async {
    try {
      isLoadingLihat.value = true;

      final dataLihat =
          await lihatKendaraanRepo.fetchLihatKendaraan(type, plant, idReq);
      lihatModel.assignAll(dataLihat);
    } catch (e) {
      print('Error while fetch lihat kendaraan : $e');
      lihatModel.assignAll([]);
    } finally {
      isLoadingLihat.value = false;
    }
  }
}
