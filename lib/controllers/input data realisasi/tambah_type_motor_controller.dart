import 'package:get/get.dart';

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../repository/input data realisasi/tambah_type_motor_repo.dart';
import '../../screens/input data realisasi/component/tambah_type_kendaraan.dart';

class TambahTypeMotorController extends GetxController {
  final isLoadingTambahType = Rx<bool>(false);
  RxList<TambahTypeMotorModel> tambahTypeMotorModel =
      <TambahTypeMotorModel>[].obs;

  // Data form terpisah untuk setiap tab
  final formFieldsPerTab = RxMap<TabDaerahTujuan, List<FormFieldData>>({
    TabDaerahTujuan.srd: [],
    TabDaerahTujuan.mks: [],
    TabDaerahTujuan.ptk: [],
    TabDaerahTujuan.bjm: [],
  });

  // Data TextFormField terpisah untuk setiap tab
  final textFieldValuesPerTab = RxMap<TabDaerahTujuan, List<String?>>({
    TabDaerahTujuan.srd: [],
    TabDaerahTujuan.mks: [],
    TabDaerahTujuan.ptk: [],
    TabDaerahTujuan.bjm: [],
  });

  final tambahTypeMotorRepo = Get.put(TambahTypeMotorRepository());

  Future<void> fetchTambahTypeMotor(int id) async {
    try {
      isLoadingTambahType.value = true;
      final getFetchTypeMotor =
          await tambahTypeMotorRepo.fetchTambahTypeMotor(id);
      tambahTypeMotorModel.assignAll(getFetchTypeMotor);
    } catch (e) {
      print('Error while fetching tambah type motor: $e');
      throw Exception('Gagal saat mengambil data tambah type motor');
    } finally {
      isLoadingTambahType.value = false;
    }
  }

  void addField(TabDaerahTujuan tab) {
    final fields = formFieldsPerTab[tab] ?? [];
    fields.add(FormFieldData());
    formFieldsPerTab[tab] =
        List.from(fields); // Create a new list to ensure update is recognized

    final textFieldValues = textFieldValuesPerTab[tab] ?? [];
    textFieldValues.add(null); // Add a new null value for the new field
    textFieldValuesPerTab[tab] =
        List.from(textFieldValues); // Ensure update is recognized

    print("Added field to tab $tab: ${formFieldsPerTab[tab]}"); // Debugging
  }

  void removeField(TabDaerahTujuan tab, int index) {
    final fields = formFieldsPerTab[tab] ?? [];
    if (index >= 0 && index < fields.length) {
      fields.removeAt(index);
      formFieldsPerTab[tab] =
          List.from(fields); // Create a new list to ensure update is recognized

      final textFieldValues = textFieldValuesPerTab[tab] ?? [];
      if (index >= 0 && index < textFieldValues.length) {
        textFieldValues.removeAt(index);
        textFieldValuesPerTab[tab] =
            List.from(textFieldValues); // Ensure update is recognized
      }

      print(
          "Removed field from tab $tab: ${formFieldsPerTab[tab]}"); // Debugging
    }
  }

  void resetFields(TabDaerahTujuan tab) {
    // Reset fields and text field values for the specified tab
    formFieldsPerTab[tab] = [];
    textFieldValuesPerTab[tab] = [];

    print("Reset fields for tab $tab"); // Debugging
  }

  void updateTextFieldValue(TabDaerahTujuan tab, int index, String? value) {
    final textFieldValues = textFieldValuesPerTab[tab] ?? [];
    if (index >= 0 && index < textFieldValues.length) {
      // Update the value for the specific tab and index
      textFieldValues[index] = value;
      textFieldValuesPerTab[tab] =
          List.from(textFieldValues); // Ensure the update is recognized
      update(); // Trigger the UI update
    }
  }
}
