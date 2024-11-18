import 'dart:io';
import 'dart:typed_data';

import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../helpers/connectivity.dart';
import '../../models/laporan honda/laporan_realisasi_model.dart';
import '../../repository/laporan honda/laporan_realisasi_repo.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class LaporanRealisasiController extends GetxController {
  final isLoading = Rx<bool>(false);
  final LaporanRealisasiRepository laporanRealisasiRepo =
      Get.put(LaporanRealisasiRepository());
  RxList<LaporanRealisasiModel> laporanRealisasiModel =
      <LaporanRealisasiModel>[].obs;

  final networkManager = Get.find<NetworkManager>();

  Future<void> fetchLaporanRealisasi(int bulan, int tahun) async {
    try {
      isLoading.value = true;
      final getLaporanRealisasi =
          await laporanRealisasiRepo.fetchLaporanRealisasi(bulan, tahun);
      laporanRealisasiModel.assignAll(getLaporanRealisasi);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan realisasi untuk saat ini');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadExcelForRealisasi(int bulan, int tahun) async {
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

      // Fetch data laporan realisasi
      await fetchLaporanRealisasi(bulan, tahun);

      if (laporanRealisasiModel.isEmpty) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data is empty, nothing to download.',
        );
        return;
      }

      // Hitung jumlah hari dalam bulan
      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Buat instance Excel
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Laporan Realisasi'];

      // Fungsi untuk menghitung jumlah per kategori
      int calculateJumlah(LaporanRealisasiModel item, String kategori) {
        if (kategori == 'Global') return item.jumlahGlobal.toInt();
        if (kategori == 'Harian') return item.jumlahHarian.toInt();
        if (kategori == 'Kompetitor') {
          return (item.jumlahGlobal - item.jumlahHarian)
              .toInt(); // Kompetitor = Global - Harian
        }
        if (kategori == 'Realisasi') return item.jumlahRealisasi.toInt();
        if (kategori == 'Unfilled') {
          return (item.jumlahHarian - item.jumlahRealisasi)
              .toInt(); // Unfilled = Harian - Realisasi
        }
        return 0;
      }

      // Fungsi untuk menambahkan tabel ke Excel
      void addTableToSheet(
          String title, List<String> kategoriList, int jumlahHari) {
        // Tambahkan header utama
        sheetObject.appendRow([
          TextCellValue(title),
          ...List.filled(jumlahHari + 1, TextCellValue('')), // Kolom kosong
        ]);

        // Tambahkan sub-header: Bulan/Tahun, tanggal, dan kolom Total
        List<CellValue?> subHeaderRow = [
          TextCellValue('$bulan/${tahun.toString().substring(2)}'),
          ...List.generate(
              jumlahHari, (index) => IntCellValue(index + 1)), // Tanggal
          TextCellValue('Total') // Kolom Total
        ];
        sheetObject.appendRow(subHeaderRow);

        // Tambahkan data kategori
        for (String kategori in kategoriList) {
          List<CellValue?> row = [TextCellValue(kategori)]; // Nama kategori
          int totalPerRow = 0;

          for (int i = 1; i <= jumlahHari; i++) {
            String tanggal =
                '$tahun-${bulan.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}';

            // Hitung jumlah untuk kategori pada tanggal tertentu
            int jumlah = laporanRealisasiModel
                .where((item) => item.tgl == tanggal)
                .fold(
                    0, (prev, item) => prev + calculateJumlah(item, kategori));

            totalPerRow += jumlah; // Tambahkan ke total baris
            row.add(IntCellValue(jumlah));
          }

          // Tambahkan kolom Total di akhir baris
          row.add(IntCellValue(totalPerRow));
          sheetObject.appendRow(row);
        }

        // Tambahkan baris kosong untuk memisahkan tabel
        sheetObject.appendRow([]);
      }

      // Tambahkan tabel Kompetitor
      addTableToSheet(
        'Laporan Realisasi Kompetitor',
        ['Global', 'Harian', 'Kompetitor'],
        jumlahHari,
      );

      // Tambahkan tabel Unfilled
      addTableToSheet(
        'Laporan Realisasi Unfilled',
        ['Harian', 'Realisasi', 'Unfilled'],
        jumlahHari,
      );

      // Tentukan direktori penyimpanan file
      Directory downloadDir =
          Directory('/storage/emulated/0/Download/LaporanRealisasi');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true); // Buat folder jika belum ada
      }

      String filePath =
          '${downloadDir.path}/LaporanRealisasi_${bulan.toString().padLeft(2, '0')}_$tahun.xlsx';
      File file = File(filePath);

      // Simpan Excel
      file.writeAsBytesSync(excel.save()!);

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'File berhasil disimpan di ./Download/LaporanRealisasi',
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

  Future<Uint8List> createPDF(int bulan, int tahun,
      {bool withHeader = true}) async {
    CustomDialogs.loadingIndicator();

    try {
      // Periksa koneksi internet
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please try again once connection is available.',
        );
        return Uint8List(0);
      }

      // Fetch data laporan realisasi
      await fetchLaporanRealisasi(bulan, tahun);

      if (laporanRealisasiModel.isEmpty) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data is empty, nothing to download.',
        );
        return Uint8List(0);
      }

      // Buat dokumen PDF
      final pdf = pw.Document();

      // Load fonts
      final regularFont =
          await rootBundle.load("assets/fonts/Urbanist-Regular.ttf");
      final ttfRegular = pw.Font.ttf(regularFont);
      final boldFont = await rootBundle.load("assets/fonts/Urbanist-Bold.ttf");
      final ttfBold = pw.Font.ttf(boldFont);

      final ByteData imageData = await rootBundle.load('assets/images/lps.png');
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final image = pw.MemoryImage(imageBytes);

      // Jumlah hari dalam bulan
      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Fungsi untuk membuat tabel Kompetitor
      pw.Widget createKompetitorTable(String title) {
        // Header tabel
        final tableHeaders = [
          '$bulan/${tahun.toString().substring(2)}', // Bulan/Tahun
          ...List.generate(
              jumlahHari, (index) => (index + 1).toString()), // Tanggal
          'Total'
        ];

        // Daftar kategori
        List<String> kompetitorList = ['Global', 'Harian', 'Kompe'];

        // Data tabel
        final tableRows = kompetitorList.map((kategori) {
          int totalPerRow = 0;
          final List<String> row = [
            kategori, // Kolom kategori
            ...List.generate(jumlahHari, (i) {
              String tanggal =
                  '$tahun-${bulan.toString().padLeft(2, '0')}-${(i + 1).toString().padLeft(2, '0')}';

              int jumlah = 0;
              if (kategori == 'Global') {
                jumlah = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahGlobal);
              } else if (kategori == 'Harian') {
                jumlah = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahHarian);
              } else if (kategori == 'Kompe') {
                int jumlahGlobal = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahGlobal);
                int jumlahHarian = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahHarian);
                jumlah =
                    jumlahGlobal - jumlahHarian; // Kompetitor = Global - Harian
              }

              totalPerRow += jumlah;
              return jumlah.toString();
            }),
            totalPerRow.toString() // Total di akhir baris
          ];
          return row;
        }).toList();

        // Bangun widget tabel
        return pw.Column(
          children: [
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              child: pw.Text(
                title,
                style: pw.TextStyle(font: ttfBold, fontSize: 12),
              ),
            ),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(2), // Kolom kategori
                for (int i = 1; i <= jumlahHari; i++)
                  i: const pw.FlexColumnWidth(1), // Kolom tanggal
                jumlahHari + 1: const pw.FlexColumnWidth(1.5), // Kolom total
              },
              children: [
                // Header tabel
                pw.TableRow(
                  children: tableHeaders.map((header) {
                    return pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.all(5),
                      color: PdfColors.yellow,
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(font: ttfBold, fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
                // Baris data
                ...tableRows.map((row) {
                  return pw.TableRow(
                    children: row.map((cell) {
                      return pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(5),
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
            pw.SizedBox(height: 20),
          ],
        );
      }

      // Func untuk membuat table Unfilled
      pw.Widget createUnfilledTable(String title) {
        // Header tabel
        final tableHeaders = [
          '$bulan/${tahun.toString().substring(2)}', // Bulan/Tahun
          ...List.generate(
              jumlahHari, (index) => (index + 1).toString()), // Tanggal
          'Total'
        ];

        // Daftar kategori
        List<String> kompetitorList = ['Harian', 'Realisasi', 'Unfill'];

        // Data tabel
        final tableRows = kompetitorList.map((kategori) {
          int totalPerRow = 0;
          final List<String> row = [
            kategori, // Kolom kategori
            ...List.generate(jumlahHari, (i) {
              String tanggal =
                  '$tahun-${bulan.toString().padLeft(2, '0')}-${(i + 1).toString().padLeft(2, '0')}';

              int jumlah = 0;
              if (kategori == 'Harian') {
                jumlah = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahHarian);
              } else if (kategori == 'Realisasi') {
                jumlah = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahRealisasi);
              } else if (kategori == 'Unfill') {
                int jumlahGlobal = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahHarian);
                int jumlahHarian = laporanRealisasiModel
                    .where((item) => item.tgl == tanggal)
                    .fold(0, (prev, item) => prev + item.jumlahRealisasi);
                jumlah =
                    jumlahGlobal - jumlahHarian; // Kompetitor = Global - Harian
              }

              totalPerRow += jumlah;
              return jumlah.toString();
            }),
            totalPerRow.toString() // Total di akhir baris
          ];
          return row;
        }).toList();

        // Bangun widget tabel
        return pw.Column(
          children: [
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              child: pw.Text(
                title,
                style: pw.TextStyle(font: ttfBold, fontSize: 12),
              ),
            ),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(2), // Kolom kategori
                for (int i = 1; i <= jumlahHari; i++)
                  i: const pw.FlexColumnWidth(1), // Kolom tanggal
                jumlahHari + 1: const pw.FlexColumnWidth(1.5), // Kolom total
              },
              children: [
                // Header tabel
                pw.TableRow(
                  children: tableHeaders.map((header) {
                    return pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.all(5),
                      color: PdfColors.yellow,
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(font: ttfBold, fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
                // Baris data
                ...tableRows.map((row) {
                  return pw.TableRow(
                    children: row.map((cell) {
                      return pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(5),
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
            pw.SizedBox(height: 20),
          ],
        );
      }

      // Tambahkan tabel ke dokumen PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(10),
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (withHeader)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(image, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text('Langgeng Pranamas Sentosa',
                              style: pw.TextStyle(fontSize: 24, font: ttfBold)),
                          pw.SizedBox(width: 16),
                          pw.Text(
                              'Jl. Komp. Babek TN Jl. Rorotan No.3 Blok C, RT.1/RW.10, Rorotan,\nKec. Cakung, Jkt Utara, Daerah Khusus Ibukota Jakarta 14140',
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(fontSize: 14, font: ttfRegular))
                        ],
                      )
                    ],
                  ),
                if (withHeader) pw.SizedBox(height: 10),
                if (withHeader) pw.Divider(),
                if (withHeader) pw.SizedBox(height: 10),
                createKompetitorTable('Laporan Realisasi Kompetitor'),
                if (withHeader) pw.SizedBox(height: 10),
                createUnfilledTable('Laporan Realisasi Unfilled')
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
}
