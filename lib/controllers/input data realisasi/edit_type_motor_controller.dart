import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/edit_type_motor_model.dart';
import '../../repository/input data realisasi/edit_type_motor_repo.dart';
import '../../utils/popups/full_screen_loader.dart';

class EditTypeMotorController extends GetxController {
  final isLoadingType = Rx<bool>(false);
  RxList<EditTypeMotorModel> doRealisasiModel = <EditTypeMotorModel>[].obs;
  final editMotorRepo = Get.put(EditTypeMotorRepository());

  Future<void> fetchAllTypeMotorById(int id) async {
    try {
      isLoadingType.value = true;
      final getSRD = await editMotorRepo.fetchAllTypeMotor(id);
      doRealisasiModel.assignAll(getSRD);
      print(
          "Data fetched: ${doRealisasiModel.length} items"); // Add this to check
    } catch (e) {
      print('Error while fetching jumlah type SRD : $e');
      doRealisasiModel.assignAll([]);
    } finally {
      isLoadingType.value = false;
    }
  }

  Future<void> editTypeMotorContent(int id, int idPacking, String typeMotor,
      String daerah, int jumlah, Function fetchTotalPlot) async {
    CustomDialogs.loadingIndicator();

    await editMotorRepo.editTypeMotor(idPacking, typeMotor, daerah, jumlah);
    CustomFullScreenLoader.stopLoading();

    await fetchAllTypeMotorById(id);
    fetchTotalPlot(); // Panggil fetchTotalPlot setelah edit selesai
    CustomFullScreenLoader.stopLoading();

    Get.back(result: true);
  }

  Future<void> hapusTypeMotorContent(
      int id, int idPacking, Function fetchTotalPlot) async {
    CustomDialogs.loadingIndicator();

    await editMotorRepo.hapusTypeMotor(idPacking);
    await fetchAllTypeMotorById(id);
    fetchTotalPlot(); // Panggil fetchTotalPlot setelah delete selesai
    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }
}
