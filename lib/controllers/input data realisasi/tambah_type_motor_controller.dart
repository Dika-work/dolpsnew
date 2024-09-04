import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../repository/input data realisasi/tambah_type_motor_repo.dart';
import '../../screens/input data realisasi/component/tambah_type_kendaraan.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import 'do_reguler_controller.dart';

class TambahTypeMotorController extends GetxController {
  final storageUtil = StorageUtil();
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
  final doRegulerController = Get.put(DoRegulerController());

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

  // Fungsi untuk mengirim data dari semua tab
  Future<void> submitAllTabs(int idRealisasi, int jumlahMotor) async {
    try {
      CustomDialogs.loadingIndicator();

      List<String> jamDetail = [];
      List<String> tglDetail = [];
      List<String> daerah = [];
      List<String> typeMotor = [];
      List<String> jumlah = [];

      for (var tab in TabDaerahTujuan.values) {
        final formData = formFieldsPerTab[tab];
        final controllers = controllersPerTab[tab];

        if (formData != null && formData.isNotEmpty && controllers != null) {
          for (int i = 0; i < formData.length; i++) {
            final typeMotorValue = formData[i].dropdownValue ?? '';
            final jumlahValue = int.tryParse(controllers[i].text) ?? 0;
            final daerahValue = getNamaDaerah(tab); // Nama daerah lengkap
            final jamDetailValue = CustomHelperFunctions.formattedTime;
            final tglDetailValue =
                CustomHelperFunctions.getFormattedDateDatabase(DateTime.now());

            jamDetail.add(jamDetailValue);
            tglDetail.add(tglDetailValue);
            daerah.add(daerahValue);
            typeMotor.add(typeMotorValue);
            jumlah.add(jumlahValue.toString());
          }
        }
      }

      // Struktur data yang dikirimkan ke API
      final dataToSend = {
        "id_realisasi": idRealisasi.toString(),
        "jam_detail": jamDetail,
        "tgl_detail": tglDetail,
        "daerah": daerah,
        "type_motor": typeMotor,
        "jumlah": jumlah
      };

      // Kirim data ke API
      final response = await http.post(
        Uri.parse(
            '${storageUtil.baseURL}/DO/api/api_packing_list_motor.php?action=Testing'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dataToSend),
      );

      if (response.statusCode == 200) {
        await plotRealisasiController.fetchPlotRealisasi(
            idRealisasi, jumlahMotor);
        await fetchTambahTypeMotor(idRealisasi);
        resetAllFields(); // Reset semua form
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Data berhasil dikirim.',
        );
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😢',
          message: 'Gagal mengirim data. Coba lagi.',
        );
      }
    } catch (e) {
      print('Error while sending data for all tabs: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat mengirim data.',
      );
    } finally {
      CustomFullScreenLoader.stopLoading();
    }
  }

  // Selesaikan type motor
  Future<void> selesaiTypeMotor(int idRealisasi) async {
    CustomDialogs.loadingIndicator();
    await tambahTypeMotorRepo.changeStatusTypeMotor(idRealisasi, 3);
    await doRegulerController.fetchRegulerContent();
    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> selesaiAllTypeMotor(int idRealisasi) async {
    CustomDialogs.loadingIndicator();
    await tambahTypeMotorRepo.changeStatusTypeMotor(idRealisasi, 3);
    await doRegulerController.fetchRegulerAllContent();
    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  // Batal Jalan
  Future<void> batalJalan(int idRealisasi) async {
    CustomDialogs.loadingIndicator();
    await tambahTypeMotorRepo.changeStatusTypeMotor(idRealisasi, 9);
    await doRegulerController.fetchRegulerContent();
    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
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

  String getNamaDaerah(TabDaerahTujuan tab) {
    switch (tab) {
      case TabDaerahTujuan.srd:
        return "SAMARINDA";
      case TabDaerahTujuan.mks:
        return "MAKASAR";
      case TabDaerahTujuan.ptk:
        return "PONTIANAK";
      case TabDaerahTujuan.bjm:
        return "BANJARMASIN";
      default:
        return "";
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

      if (plotModelRealisasi.isNotEmpty) {
        int fetchedJumlahPlot = plotModelRealisasi.first.jumlahPlot;
        print(
            'Fetched jumlahPlot: $fetchedJumlahPlot, jumlahMotor: $jumlahMotor');
        isJumlahPlotEqual.value = fetchedJumlahPlot == jumlahMotor;
        print('isJumlahPlotEqual set to: ${isJumlahPlotEqual.value}');
      } else {
        isJumlahPlotEqual.value = false;
        print('No plot data available, setting isJumlahPlotEqual to false.');
      }
    } catch (e) {
      print('Error saat mengambil data jumlah plot realisasi motor: $e');
      plotModelRealisasi.assignAll([]);
      isJumlahPlotEqual.value = false; // Pastikan ini di-reset jika ada error
      print('Setting isJumlahPlotEqual to false due to error.');
    }
  }
}
