import 'package:flutter/material.dart';
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
  final controllersPerTab =
      RxMap<TabDaerahTujuan, List<TextEditingController>>({
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
    // Add form field data...
    final fields = formFieldsPerTab[tab] ?? [];
    fields.add(FormFieldData());
    formFieldsPerTab[tab] = List.from(fields);

    // Add a new TextEditingController
    final controllers = controllersPerTab[tab] ?? [];
    controllers.add(TextEditingController());
    controllersPerTab[tab] = List.from(controllers);
  }

  void removeField(TabDaerahTujuan tab, int index) {
    // Remove form field data...
    final fields = formFieldsPerTab[tab] ?? [];
    if (index >= 0 && index < fields.length) {
      fields.removeAt(index);
      formFieldsPerTab[tab] = List.from(fields);

      // Remove TextEditingController
      final controllers = controllersPerTab[tab] ?? [];
      if (index >= 0 && index < controllers.length) {
        controllers[index]
            .dispose(); // Dispose controller to prevent memory leaks
        controllers.removeAt(index);
        controllersPerTab[tab] = List.from(controllers);
      }
    }
  }

  void resetFields(TabDaerahTujuan tab) {
    // Reset fields and text field values for the specified tab
    formFieldsPerTab[tab] = [];

    // Dispose all controllers associated with the tab
    final controllers = controllersPerTab[tab] ?? [];
    for (var controller in controllers) {
      controller.dispose(); // Properly dispose to avoid memory leaks
    }
    controllersPerTab[tab] = [];

    print("Reset fields for tab $tab"); // Debugging
  }

  void updateTextFieldValue(TabDaerahTujuan tab, int index, String? value) {
    final controllers = controllersPerTab[tab] ?? [];
    if (index >= 0 && index < controllers.length) {
      controllers[index].text = value ?? '';
    }
  }
}
