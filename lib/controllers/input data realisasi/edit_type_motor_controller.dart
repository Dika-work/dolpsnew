import 'package:get/get.dart';

import '../../models/input data realisasi/edit_type_motor_model.dart';
import '../../repository/input data realisasi/edit_type_motor_repo.dart';

class EditTypeMotorController extends GetxController {
  final isLoadingType = Rx<bool>(false);
  RxList<EditTypeMotorModel> doRealisasiModel = <EditTypeMotorModel>[].obs;
  final editMotorRepo = Get.put(EditTypeMotorRepository());

  Future<void> fetchAllTypeMotorById(int id) async {
    try {
      isLoadingType.value = true;
      final getSRD = await editMotorRepo.fetchAllTypeMotor(id);
      doRealisasiModel.assignAll(getSRD);
    } catch (e) {
      print('Error while fetching jumlah type SRD : $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingType.value = false;
    }
  }
}
