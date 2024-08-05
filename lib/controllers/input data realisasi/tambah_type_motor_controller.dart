import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../repository/input data realisasi/tambah_type_motor_repo.dart';
import '../../screens/input data realisasi/component/tambah_type_kendaraan.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

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
  final plotRealisasiController = Get.put(PlotRealisasiController());

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

  Future<void> addTypeMotorDaerah(int idRealisasi, String jamDetail,
      String tglDetail, String daerah, String typeMotor, int jumlah) async {
    CustomDialogs.loadingIndicator();

    // menambahkan jumlah plot
    await plotRealisasiController.fetchPlotRealisasi(idRealisasi, jumlah);
    final jumlahPlotRealisasi =
        plotRealisasiController.plotModelRealisasi.first.jumlahPlot;
    if (jumlah != jumlahPlotRealisasi) {
      await tambahTypeMotorRepo.addTypeMotorDaerah(
          idRealisasi, jamDetail, tglDetail, daerah, typeMotor, jumlah);
      // harusnya ini reset value dari dropdown dan textfield yg ada di tambah type motor
      await plotRealisasiController.fetchPlotRealisasi(idRealisasi, jumlah);
      await fetchTambahTypeMotor(idRealisasi);

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data type motor..',
      );
      CustomFullScreenLoader.stopLoading();
    } else {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.successSnackBar(
        title: 'Gagal',
        message: 'Jumlah kendaraan dan jumlah plot sudah sesuai..',
      );
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

  void resetAllFields() {
    for (var tab in TabDaerahTujuan.values) {
      resetFields(tab); // Panggil resetFields untuk setiap tab
    }
  }

  void updateTextFieldValue(TabDaerahTujuan tab, int index, String? value) {
    final controllers = controllersPerTab[tab] ?? [];
    if (index >= 0 && index < controllers.length) {
      controllers[index].text = value ?? '';
    }
  }

  // collect all value dropdown and textformfield on each tab
  void collectData() {
    for (var tab in TabDaerahTujuan.values) {
      final fields = formFieldsPerTab[tab] ?? [];
      final controllers = controllersPerTab[tab] ?? [];

      for (var i = 0; i < fields.length; i++) {
        final dropdownValue = fields[i].dropdownValue;
        final textFieldValue = controllers[i].text;

        print(
            'Tab: $tab, Field Index: $i, Dropdown Value: $dropdownValue, TextField Value: $textFieldValue');
      }
    }
  }
}

class PlotRealisasiController extends GetxController {
  RxList<PlotModelRealisasi> plotModelRealisasi = <PlotModelRealisasi>[].obs;
  RxBool isJumlahPlotEqual = false.obs;
  final tambahTypeMotorRepo = Get.put(TambahTypeMotorRepository());

  // fetch jumlah plot realisasi
  Future<void> fetchPlotRealisasi(int idRealisasi, int jumlahMotor) async {
    try {
      final plotRealisasi =
          await tambahTypeMotorRepo.jumlahPlotRealisasi(idRealisasi);
      plotModelRealisasi.assignAll(plotRealisasi);

      print('Plot Model Realisasi setelah fetch: ${plotModelRealisasi.map(
        (element) => element.jumlahPlot,
      )}');
      isJumlahPlotEqual.value = plotModelRealisasi.isNotEmpty &&
          plotModelRealisasi.first.jumlahPlot == jumlahMotor;

      print('isJumlahPlotEqual setelah fetch ${isJumlahPlotEqual.value}');
    } catch (e) {
      print('Error saat mengambil data jumlah plot realisasi motor');
      plotModelRealisasi.assignAll([]);
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message:
            'Gagal mengambil data jumlah plot realisasi. Silakan coba lagi.',
      );
    }
  }
}
