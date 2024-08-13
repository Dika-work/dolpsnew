import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../repository/input data realisasi/tambah_type_motor_mutasi_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../master data/type_motor_controller.dart';
import 'do_mutasi_controller.dart';
import 'tambah_type_motor_controller.dart';

class TambahTypeMotorMutasiController extends GetxController {
  final isLoadingMutasi = Rx<bool>(false);
  RxList<TambahTypeMotorMutasiModel> tambahTypeMotorMutasiModel =
      <TambahTypeMotorMutasiModel>[].obs;

  final tambahTypeMotorMutasiRepo = Get.put(TambahTypeMotorMutasiRepo());
  final plotRealisasiController = Get.put(PlotRealisasiController());
  final doMutasiController = Get.put(DoMutasiController());
  final typeMotorHondaController = Get.put(TypeMotorHondaController());

  // List to hold the data for each form field
  RxList<FormFieldData> formFields = <FormFieldData>[].obs;

  // List to hold the text controllers for each form field
  RxList<TextEditingController> textControllers = <TextEditingController>[].obs;

  Future<void> fetchTambahTypeMotorMutasi(int id) async {
    try {
      isLoadingMutasi.value = true;
      final getFetchMutasi =
          await tambahTypeMotorMutasiRepo.fetchTambahTypeMotor(id);
      tambahTypeMotorMutasiModel.assignAll(getFetchMutasi);
    } catch (e) {
      print('Error while fetching tambah type motor mutasi: $e');
      throw Exception('Gagal saat mengambil data tambah type motor mutasi');
    } finally {
      isLoadingMutasi.value = false;
    }
  }

  void addField() {
    final newField = FormFieldData();

    newField.dropdownValue = null;
    newField.textFieldValue = '';

    final newController = TextEditingController();

    formFields.add(newField);
    textControllers.add(newController);
  }

  void removeField(int index) {
    if (index >= 0 && index < formFields.length) {
      formFields.removeAt(index);
      textControllers[index].dispose();
      textControllers.removeAt(index);
    }
  }

  void resetFields() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    formFields.clear();
    textControllers.clear();
  }

  @override
  void onClose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> submitAllMutasi(int idRealisasi, int jumlahMotor) async {
    try {
      CustomDialogs.loadingIndicator();

      List<String> jamDetail = [];
      List<String> tglDetail = [];
      List<String> daerah = [];
      List<String> typeMotor = [];
      List<String> jumlah = [];

      // Iterate over form fields and controllers
      for (int i = 0; i < formFields.length; i++) {
        final typeMotorValue = formFields[i].dropdownValue ?? '';
        final jumlahValue = int.tryParse(textControllers[i].text) ?? 0;
        const daerahValue = "-";
        final jamDetailValue = CustomHelperFunctions.formattedTime;
        final tglDetailValue =
            CustomHelperFunctions.getFormattedDateDatabase(DateTime.now());

        jamDetail.add(jamDetailValue);
        tglDetail.add(tglDetailValue);
        daerah.add(daerahValue);
        typeMotor.add(typeMotorValue);
        jumlah.add(jumlahValue.toString());
      }

      // Structure data to be sent to the API
      final dataToSend = {
        "id_realisasi": idRealisasi.toString(),
        "jam_detail": jamDetail,
        "tgl_detail": tglDetail,
        "daerah": daerah,
        "type_motor": typeMotor,
        "jumlah": jumlah
      };

      // Send data to the API
      final response = await http.post(
        Uri.parse(
            'http://langgeng.dyndns.biz/DO/api/api_packing_list_motor.php?action=Testing'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dataToSend),
      );

      if (response.statusCode == 200) {
        await plotRealisasiController.fetchPlotRealisasi(
            idRealisasi, jumlahMotor);
        await fetchTambahTypeMotorMutasi(idRealisasi);
        resetFields(); // Reset all form fields
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
}
