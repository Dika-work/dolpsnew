import 'package:get/get.dart';

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../repository/input data realisasi/tambah_type_motor_repo.dart';

class TambahTypeMotorController extends GetxController {
  final isLoadingTambahType = Rx<bool>(false);
  RxList<TambahTypeMotorModel> tambahTypeMotorModel =
      <TambahTypeMotorModel>[].obs;
  var formFields = <FormFieldData>[].obs;

  final tambahTypeMotorRepo = Get.put(TambahTypeMotorRepository());

  Future<void> fetchTambahTypeMotor(int id) async {
    try {
      isLoadingTambahType.value = true;
      final getFetchTypeMotor =
          await tambahTypeMotorRepo.fetchTambahTypeMotor(id);
      tambahTypeMotorModel.assignAll(getFetchTypeMotor);
    } catch (e) {
      print('Error while fetching tambah type motor : $e');
      throw Exception('Gagal saat mengambil data tambah type motor');
    } finally {
      isLoadingTambahType.value = false;
    }
  }

  void addField() {
    formFields.add(FormFieldData());
  }

  void removeField(int index) {
    if (formFields.isNotEmpty) {
      formFields.removeAt(index);
    }
  }

  void resetAllFields() {
    formFields.clear();
  }
}
