import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../../helpers/connectivity.dart';
import '../../models/laporan honda/laporan_dealer_model.dart';
import '../../repository/laporan honda/laporan_dealer_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class LaporanDealerController extends GetxController {
  final dealerLoading = Rx<bool>(false);
  final LaporanDealerRepository laporanDealerRepo =
      Get.put(LaporanDealerRepository());
  RxList<LaporanDealerModel> dealerModel = <LaporanDealerModel>[].obs;
  final networkManager = Get.find<NetworkManager>();

  Future<void> fetchLaporanEstimasi(int bulan, int tahun) async {
    try {
      dealerLoading.value = true;
      final getLaporanDealer =
          await laporanDealerRepo.fetchLaporanEstimasi(bulan, tahun);
      dealerModel.assignAll(getLaporanDealer);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan estimasi');
    } finally {
      dealerLoading.value = false;
    }
  }

  Future<void> downloadExcelForDealer(int bulan, int tahun) async {
    try {
      CustomDialogs.loadingIndicator();

      // Periksa koneksi internet
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please try again once connection is available.',
        );
        return;
      }

      // Fetch data dealer dari API
      await fetchLaporanEstimasi(bulan, tahun);

      if (dealerModel.isEmpty) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data is empty, nothing to download.',
        );
        return;
      }

      // Hitung jumlah hari dalam bulan tertentu
      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Filter data berdasarkan sumber
      List<LaporanDealerModel> globalData =
          dealerModel.where((item) => item.sumberData == 'global').toList();
      List<LaporanDealerModel> harianData =
          dealerModel.where((item) => item.sumberData == 'harian').toList();
      List<LaporanDealerModel> realisasiData =
          dealerModel.where((item) => item.sumberData == 'realisasi').toList();

      // Buat instance Excel
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Fungsi untuk menambahkan tabel ke sheet
      void addTableToSheet(
          String tableTitle, List<LaporanDealerModel> tableData) {
        // Header Utama
        sheetObject.appendRow([
          TextCellValue(tableTitle),
          ...List.filled(
              jumlahHari, TextCellValue('')), // Kolom kosong menjaga format
        ]);

        // Sub-header: "Bulan/Tahun" dan Tanggal
        List<CellValue?> subHeaderRow = [
          TextCellValue('Bulan/Tahun'),
          ...List.generate(jumlahHari,
              (index) => IntCellValue(index + 1)), // Tanggal 1 - jumlahHari
        ];
        sheetObject.appendRow(subHeaderRow);

        // Struktur data berdasarkan daerah
        List<String> daerahList =
            tableData.map((item) => item.daerah).toSet().toList();

        // Data tabel
        for (String daerah in daerahList) {
          // Baris per daerah
          List<CellValue?> row = [TextCellValue(daerah)];
          for (int i = 1; i <= jumlahHari; i++) {
            String tanggal =
                '$tahun-${bulan.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}';
            // Cari data jumlah berdasarkan tanggal dan daerah
            int jumlah = tableData
                .where((item) => item.tgl == tanggal && item.daerah == daerah)
                .fold(0, (prev, item) => prev + item.jumlah);
            row.add(IntCellValue(jumlah));
          }
          sheetObject.appendRow(row);
        }

        // Tambahkan baris kosong untuk pemisah antar tabel
        sheetObject.appendRow([]);
        sheetObject.appendRow([]);
      }

      // Tambahkan 3 tabel ke dalam sheet menggunakan data yang sesuai
      addTableToSheet('DO Global Berdasarkan Dealer', globalData);
      addTableToSheet('DO Harian Berdasarkan Dealer', harianData);
      addTableToSheet('DO Realisasi Berdasarkan Dealer', realisasiData);

      // Tentukan direktori penyimpanan file
      Directory downloadDir =
          Directory('/storage/emulated/0/Download/ExcelFiles');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      String filePath =
          '${downloadDir.path}/DO_Global_Dealer_${_getMonthName(bulan)}_$tahun.xlsx';
      File file = File(filePath);

      // Simpan Excel
      file.writeAsBytesSync(excel.save()!);

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'File berhasil disimpan di $filePath',
      );

      OpenFile.open(filePath);

      CustomFullScreenLoader.stopLoading();
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
      );
      print('Error: $e');
    }
  }

// Fungsi untuk mendapatkan nama bulan dalam bahasa Indonesia
  String _getMonthName(int month) {
    List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return bulan[month - 1];
  }
}
