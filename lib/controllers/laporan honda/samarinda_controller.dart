import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/connectivity.dart';
import '../../models/laporan honda/samarinda_model.dart';
import '../../repository/laporan honda/samarinda_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class SamarindaController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<SamarindaModel> samarindaModel = <SamarindaModel>[].obs;
  final SamarindaRepository samarindaRepo = Get.put(SamarindaRepository());
  final networkManager = Get.find<NetworkManager>();

  Future<void> fetchLaporanSamarinda(int tahun) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchLaporanSamarinda(tahun);
      samarindaModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadExcelForDooring(int tahun) async {
    try {
      print('Starting Excel download...');
      CustomDialogs.loadingIndicator();

      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please try again once connection is available.',
        );
        return;
      }

      await fetchLaporanSamarinda(tahun);
      if (samarindaModel.isEmpty) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data is empty, nothing to download.',
        );
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      List<CellValue?> headerRow = [
        TextCellValue('No'),
        TextCellValue('Sumber Data'),
        TextCellValue('Jan'),
        TextCellValue('Feb'),
        TextCellValue('Mar'),
        TextCellValue('Apr'),
        TextCellValue('May'),
        TextCellValue('Jun'),
        TextCellValue('Jul'),
        TextCellValue('Aug'),
        TextCellValue('Sep'),
        TextCellValue('Oct'),
        TextCellValue('Nov'),
        TextCellValue('Des'),
        TextCellValue('TOTAL'),
      ];
      sheetObject.appendRow(headerRow);

      int index = 1;

      // Initialize lists for storing DO GLOBAL and DO HARIAN monthly values
      List<int> doGlobalValues = List.filled(12, 0);
      List<int> doHarianValues = List.filled(12, 0);
      int totalGlobal = 0;
      int totalHarian = 0;

      for (var item in samarindaModel) {
        print(
            'sumberData: ${item.sumberData}, bulan: ${item.bulan}, hasil: ${item.hasil}');
        if (item.sumberData == "do_global") {
          doGlobalValues[item.bulan - 1] = item.hasil;
          totalGlobal += item.hasil;
        } else if (item.sumberData == "do_harian") {
          doHarianValues[item.bulan - 1] = item.hasil;
          totalHarian += item.hasil;
        }
      }

      // Populate DO GLOBAL row
      List<CellValue?> doGlobalRow = [
        IntCellValue(index++), // No
        TextCellValue("DO GLOBAL"), // Sumber Data
        ...doGlobalValues
            .map((value) => IntCellValue(value)), // Jan - Dec values
        IntCellValue(totalGlobal) // TOTAL for DO GLOBAL
      ];
      sheetObject.appendRow(doGlobalRow);

      // Populate DO HARIAN row
      List<CellValue?> doHarianRow = [
        IntCellValue(index++), // No
        TextCellValue("DO HARIAN"), // Sumber Data
        ...doHarianValues
            .map((value) => IntCellValue(value)), // Jan - Dec values
        IntCellValue(totalHarian) // TOTAL for DO HARIAN
      ];
      sheetObject.appendRow(doHarianRow);

      // Calculate SELISIH row (DO GLOBAL - DO HARIAN)
      List<int> selisihValues =
          List.generate(12, (i) => doGlobalValues[i] - doHarianValues[i]);
      int selisihTotal = totalGlobal - totalHarian;
      print('SELISIH Values: $selisihValues, SELISIH Total: $selisihTotal');

      // Populate SELISIH row
      List<CellValue?> selisihRow = [
        IntCellValue(index), // No for SELISIH row
        TextCellValue('SELISIH'), // Label as "SELISIH"
        ...selisihValues
            .map((value) => IntCellValue(value)), // Jan - Dec for SELISIH
        IntCellValue(selisihTotal) // TOTAL for SELISIH
      ];
      sheetObject.appendRow(selisihRow);

      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      var fileBytes = excel.save();
      if (fileBytes == null) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Failed to save Excel file, invalid data.',
        );
        return;
      }

      String filePath = join(directory!.path, 'Lap-Samarinda-$tahun.xlsx');
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      SnackbarLoader.successSnackBar(
        title: 'Success',
        message: 'File saved successfully',
      );

      print('Excel file saved in directory ${directory.path}');
      OpenFile.open(filePath);

      CustomFullScreenLoader.stopLoading();
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Failed to download Excel file: $e',
      );
      print('Error: $e');
      CustomFullScreenLoader.stopLoading();
    }
  }
}
