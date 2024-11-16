import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
      print('ini jumlah data yg udah nampil: ${dealerModel.length}');
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
          ...List.filled(jumlahHari + 1,
              TextCellValue('')), // Kolom tambahan untuk "Total"
        ]);

        // Sub-header: "Bulan/Tahun", Tanggal, dan Total
        List<CellValue?> subHeaderRow = [
          TextCellValue('$bulan/$tahun'),
          ...List.generate(jumlahHari,
              (index) => IntCellValue(index + 1)), // Tanggal 1 - jumlahHari
          TextCellValue('Total') // Kolom tambahan untuk Total
        ];
        sheetObject.appendRow(subHeaderRow);

        // Daftar tetap daerah
        List<String> daerahList = [
          'SAMARINDA',
          'MAKASAR',
          'PONTIANAK',
          'BANJARMASIN'
        ];

        // Data tabel
        for (String daerah in daerahList) {
          // Baris per daerah
          List<CellValue?> row = [TextCellValue(daerah)];
          int totalPerRow = 0;

          for (int i = 1; i <= jumlahHari; i++) {
            String tanggal =
                '$tahun-${bulan.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}';

            // Cari data jumlah berdasarkan tanggal dan daerah
            int jumlah = tableData
                .where((item) => item.tgl == tanggal && item.daerah == daerah)
                .fold(0, (prev, item) => prev + item.jumlah);

            totalPerRow += jumlah; // Tambahkan ke total baris
            row.add(IntCellValue(jumlah));
          }

          // Tambahkan kolom "Total" di akhir baris
          row.add(IntCellValue(totalPerRow));
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
        message:
            "File telah berhasil diunduh. Silakan periksa folder 'ExcelFiles' di dalam folder 'Download'",
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

  // generate pdf
  Future<Uint8List> generatePDF(int bulan, int tahun) async {
    CustomDialogs.loadingIndicator();

    try {
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please try again once connection is available.',
        );
        return Uint8List(0);
      }

      await fetchLaporanEstimasi(bulan, tahun);

      if (dealerModel.isEmpty) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data is empty, nothing to download.',
        );
        return Uint8List(0);
      }

      final pdf = pw.Document();

      final regularFont =
          await rootBundle.load("assets/fonts/Urbanist-Regular.ttf");
      final ttfRegular = pw.Font.ttf(regularFont);
      final boldFont = await rootBundle.load("assets/fonts/Urbanist-Bold.ttf");
      final ttfBold = pw.Font.ttf(boldFont);

      final ByteData imageData = await rootBundle.load('assets/images/lps.png');
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final image = pw.MemoryImage(imageBytes);

      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Filter data berdasarkan sumber
      List<LaporanDealerModel> globalData =
          dealerModel.where((item) => item.sumberData == 'global').toList();
      List<LaporanDealerModel> harianData =
          dealerModel.where((item) => item.sumberData == 'harian').toList();
      List<LaporanDealerModel> realisasiData =
          dealerModel.where((item) => item.sumberData == 'realisasi').toList();

      // Fungsi untuk membuat widget tabel
      pw.Widget createTable(String title, List<LaporanDealerModel> data) {
        // Mapping daerah dengan singkatannya
        Map<String, String> daerahMapping = {
          'SRD': 'SAMARINDA',
          'MKS': 'MAKASAR',
          'PTK': 'PONTIANAK',
          'BJM': 'BANJARMASIN',
        };

        // Daftar singkatan daerah
        List<String> daerahList = ['SRD', 'MKS', 'PTK', 'BJM'];

        // Header tabel
        final tableHeaders = [
          '$bulan/${tahun.toString().substring(2)}',
          ...List.generate(jumlahHari, (index) => (index + 1).toString()),
          'Total'
        ];

        // Baris data
        final tableRows = daerahList.map((singkatan) {
          String daerah = daerahMapping[singkatan]!;
          int totalPerRow = 0;
          final List<String> row = [
            singkatan, // Gunakan singkatan untuk tampilan
            ...List.generate(jumlahHari, (i) {
              String tanggal =
                  '$tahun-${bulan.toString().padLeft(2, '0')}-${(i + 1).toString().padLeft(2, '0')}';
              print('Mencari data untuk $daerah pada $tanggal');

              // Filter data untuk tanggal dan daerah tertentu
              final filteredData = data
                  .where((item) => item.tgl == tanggal && item.daerah == daerah)
                  .toList();
              print('Filtered data untuk $daerah pada $tanggal: $filteredData');

              // Hitung jumlah
              int jumlah =
                  filteredData.fold(0, (prev, item) => prev + item.jumlah);
              print('Jumlah untuk $daerah pada $tanggal: $jumlah');

              totalPerRow += jumlah;
              return jumlah.toString();
            }),
            totalPerRow.toString()
          ];
          return row;
        }).toList();

        return pw.Column(
          children: [
            // Baris judul tabel (merge manual dengan Container)
            pw.Container(
              width: double.infinity, // Penuhi lebar tabel
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
                border: pw.Border(
                  bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
                ),
              ),
              child: pw.Text(
                title,
                style: pw.TextStyle(font: ttfBold, fontSize: 12),
                textAlign: pw.TextAlign.center,
              ),
            ),

            // Header tabel
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5), // Kolom pertama
                for (int i = 1; i <= jumlahHari; i++)
                  i: const pw.FlexColumnWidth(1),
                jumlahHari + 1: const pw.FlexColumnWidth(1.5), // Kolom Total
              },
              children: [
                // Header
                pw.TableRow(
                  children: [
                    // Kolom Bulan/Tahun (warna kuning)
                    pw.Container(
                      alignment: pw.Alignment.center,
                      color: PdfColors.yellow,
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        tableHeaders.first,
                        style: pw.TextStyle(font: ttfBold, fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    // Kolom Tanggal (warna biru)
                    ...tableHeaders.skip(1).map((header) {
                      return pw.Container(
                        alignment: pw.Alignment.center,
                        color: PdfColors.blue,
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          header,
                          style: pw.TextStyle(font: ttfBold, fontSize: 10),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }),
                  ],
                ),
                // Baris data
                ...tableRows.map((row) {
                  int index = 0; // Keep track of the index manually
                  return pw.TableRow(
                    children: row.map((cell) {
                      final isPurpleColumn =
                          index == 0; // First column (daerah)
                      index++;
                      return pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(5),
                        color: isPurpleColumn ? PdfColors.purple100 : null,
                        child: pw.Text(
                          cell,
                          style: pw.TextStyle(font: ttfRegular, fontSize: 8),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 10), // Jarak antar tabel
          ],
        );
      }

      // Buat halaman PDF dengan tiga tabel
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(10),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header Dokumen
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(image, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text('Langgeng Pranamas Sentosa',
                                style:
                                    pw.TextStyle(fontSize: 24, font: ttfBold)),
                            pw.SizedBox(width: 16),
                            pw.Text(
                                'Jl. Komp. Babek TN Jl. Rorotan No.3 Blok C, RT.1/RW.10, Rorotan,\nKec. Cakung, Jkt Utara, Daerah Khusus Ibukota Jakarta 14140',
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontSize: 14, font: ttfRegular))
                          ])
                    ]),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 10),
                // Tambahkan tabel satu per satu
                createTable('DO Global Berdasarkan Dealer', globalData),
                pw.SizedBox(height: 10),
                createTable('DO Harian Berdasarkan Dealer', harianData),
                pw.SizedBox(height: 10),
                createTable('DO Realisasi Berdasarkan Dealer', realisasiData),
                pw.Row(children: [
                  pw.Text('Note :'),
                  pw.SizedBox(width: 10),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('SRD : SAMARINDA'),
                        pw.Text('MKS : MAKASAR'),
                      ]),
                  pw.SizedBox(width: 10),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('PTK : PONTIANAK'),
                        pw.Text('BJM : BANJARMASIN'),
                      ])
                ])
              ],
            );
          },
        ),
      );

      CustomFullScreenLoader.stopLoading();
      return pdf.save();
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Failed to generate PDF: $e',
      );
      print('Error: $e');
      return Uint8List(0);
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
