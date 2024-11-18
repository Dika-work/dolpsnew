import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

      List<int> doGlobalValues = List.filled(12, 0);
      List<int> doHarianValues = List.filled(12, 0);
      int totalGlobal = 0;
      int totalHarian = 0;

      for (var item in samarindaModel) {
        if (item.sumberData == "do_global") {
          doGlobalValues[item.bulan - 1] = item.hasil;
          totalGlobal += item.hasil;
        } else if (item.sumberData == "do_harian") {
          doHarianValues[item.bulan - 1] = item.hasil;
          totalHarian += item.hasil;
        }
      }

      List<CellValue?> doGlobalRow = [
        TextCellValue("DO GLOBAL"),
        ...doGlobalValues.map((value) => IntCellValue(value)),
        IntCellValue(totalGlobal),
      ];
      sheetObject.appendRow(doGlobalRow);

      List<CellValue?> doHarianRow = [
        TextCellValue("DO HARIAN"),
        ...doHarianValues.map((value) => IntCellValue(value)),
        IntCellValue(totalHarian),
      ];
      sheetObject.appendRow(doHarianRow);

      List<int> selisihValues =
          List.generate(12, (i) => doGlobalValues[i] - doHarianValues[i]);
      int selisihTotal = totalGlobal - totalHarian;

      List<CellValue?> selisihRow = [
        TextCellValue('SELISIH'),
        ...selisihValues.map((value) => IntCellValue(value)),
        IntCellValue(selisihTotal),
      ];
      sheetObject.appendRow(selisihRow);

      // Tentukan folder unduhan untuk menyimpan file Excel
      Directory downloadDir =
          Directory('/storage/emulated/0/Download/ExcelFiles');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true); // Buat folder jika belum ada
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

      String filePath = join(downloadDir.path, 'Lap-Samarinda-$tahun.xlsx');
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      SnackbarLoader.successSnackBar(
        title: 'Success',
        message: 'Excel file saved in directory ./Download/ExcelFiles',
      );

      print('Excel file saved in directory ${downloadDir.path}');
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

  Future<Uint8List> generatePDF(int tahun, {bool withHeader = true}) async {
    print('Starting PDF generation...');
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'No Internet Connection',
        message: 'Please try again once connection is available.',
      );
      return Uint8List(0); // Return empty bytes if there's no connection
    }

    await fetchLaporanSamarinda(tahun);
    if (samarindaModel.isEmpty) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Data is empty, nothing to download.',
      );
      return Uint8List(0); // Return empty bytes if data is empty
    }

    final pdf = pw.Document();

    // Load fonts
    final regularFont =
        await rootBundle.load("assets/fonts/Urbanist-Regular.ttf");
    final ttfRegular = pw.Font.ttf(regularFont);
    final boldFont = await rootBundle.load("assets/fonts/Urbanist-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFont);

    // Load image from assets
    final ByteData imageData = await rootBundle.load('assets/images/lps.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);

    // Column headers
    final headers = [
      'Sumber',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Des',
      'TOTAL'
    ];

    // Prepare data for rows
    List<int> doGlobalValues = List.filled(12, 0);
    List<int> doHarianValues = List.filled(12, 0);
    int totalGlobal = 0;
    int totalHarian = 0;

    // Populate data for DO GLOBAL and DO HARIAN
    for (var item in samarindaModel) {
      if (item.sumberData == "do_global") {
        doGlobalValues[item.bulan - 1] = item.hasil;
        totalGlobal += item.hasil;
      } else if (item.sumberData == "do_harian") {
        doHarianValues[item.bulan - 1] = item.hasil;
        totalHarian += item.hasil;
      }
    }

    // Calculate SELISIH values
    List<int> selisihValues =
        List.generate(12, (i) => doGlobalValues[i] - doHarianValues[i]);
    int selisihTotal = totalGlobal - totalHarian;

    if (withHeader) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
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
                pw.Divider(),
                pw.SizedBox(height: 15),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Laporan Samarinda',
                          style: pw.TextStyle(fontSize: 14, font: ttfBold)),
                      pw.Text('$tahun',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 14, font: ttfRegular))
                    ]),
                pw.SizedBox(height: 15),
                pw.Text(
                    '   Hasil di bawah ini disusun berdasarkan kalkulasi dan analisis data yang diperoleh sepanjang tahun ini, mencerminkan pencapaian khusus untuk wilayah Samarinda.',
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
                pw.SizedBox(height: 20),
                // Table with headers and data
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2), // Sumber Data column
                    for (var i = 1; i < 13; i++)
                      i: const pw.FlexColumnWidth(1), // Months
                    13: const pw.FixedColumnWidth(45), // TOTAL column
                  },
                  children: [
                    // Header row with padding and center alignment
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: headers.map((header) {
                        return pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(font: ttfBold, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // DO GLOBAL row with padding and center alignment
                    pw.TableRow(
                      children: [
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Global',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        ...doGlobalValues.map((value) => pw.Center(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(
                                  value.toString(),
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 10),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )),
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              totalGlobal.toString(),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // DO HARIAN row with padding and center alignment
                    pw.TableRow(
                      children: [
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Harian',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        ...doHarianValues.map((value) => pw.Center(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(
                                  value.toString(),
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 10),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )),
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              totalHarian.toString(),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SELISIH row with padding and center alignment
                    pw.TableRow(
                      children: [
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'SELISIH',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        ...selisihValues.map((value) => pw.Center(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(
                                  value.toString(),
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 10),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )),
                        pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              selisihTotal.toString(),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 25),
                pw.Text(
                    '   Laporan ini diharapkan menjadi dasar untuk keputusan strategis ke depan. Terima kasih kepada tim Samarinda atas dedikasi dan kontribusinya dalam pencapaian ini.',
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
                pw.Spacer(),
                pw.Text('Sekian,',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
                pw.Text('Terimakasih',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 14, font: ttfRegular))
              ],
            ),
          );
        },
      ));
    } else {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Laporan Samarinda',
                        style: pw.TextStyle(fontSize: 14, font: ttfBold)),
                    pw.Text('$tahun',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 14, font: ttfRegular))
                  ]),
              pw.SizedBox(height: 15),
              pw.Text(
                  '   Hasil di bawah ini disusun berdasarkan kalkulasi dan analisis data yang diperoleh sepanjang tahun ini, mencerminkan pencapaian khusus untuk wilayah Samarinda.',
                  textAlign: pw.TextAlign.justify,
                  style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
              pw.SizedBox(height: 20),
              // Table with headers and data
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2), // Sumber Data column
                  for (var i = 1; i < 13; i++)
                    i: const pw.FlexColumnWidth(1), // Months
                  13: const pw.FixedColumnWidth(45), // TOTAL column
                },
                children: [
                  // Header row with padding and center alignment
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: headers.map((header) {
                      return pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            header,
                            style: pw.TextStyle(font: ttfBold, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // DO GLOBAL row with padding and center alignment
                  pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            'Global',
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      ...doGlobalValues.map((value) => pw.Center(
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                value.toString(),
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 10),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          )),
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            totalGlobal.toString(),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DO HARIAN row with padding and center alignment
                  pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            'Harian',
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      ...doHarianValues.map((value) => pw.Center(
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                value.toString(),
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 10),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          )),
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            totalHarian.toString(),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SELISIH row with padding and center alignment
                  pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            'SELISIH',
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      ...selisihValues.map((value) => pw.Center(
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                value.toString(),
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 10),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          )),
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            selisihTotal.toString(),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Text(
                  '   Laporan ini diharapkan menjadi dasar untuk keputusan strategis ke depan. Terima kasih kepada tim Samarinda atas dedikasi dan kontribusinya dalam pencapaian ini.',
                  textAlign: pw.TextAlign.justify,
                  style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('Sekian,',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 14, font: ttfRegular)),
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('Terimakasih',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 14, font: ttfRegular)))
            ],
          );
        },
      ));
    }

    CustomFullScreenLoader.stopLoading();

    return pdf.save(); // Return PDF as bytes for preview
  }
}
