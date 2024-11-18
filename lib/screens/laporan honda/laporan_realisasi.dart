import 'package:doplsnew/helpers/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/laporan_realisasi_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/laporan honda/laporan_realisasi_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';
import 'pdf_preview/pdf_preview.dart';

class LaporanRealisasi extends StatefulWidget {
  const LaporanRealisasi({super.key});

  @override
  State<LaporanRealisasi> createState() => _LaporanRealisasiState();
}

class _LaporanRealisasiState extends State<LaporanRealisasi> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> years = ['2021', '2022', '2023', '2024', '2025'];

  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());

  LaporanRealisasiSource? source;
  LaporanRealisasiUnfieldSource? sourceUnfielld;

  final controller = Get.put(LaporanRealisasiController());
  final networkConn = Get.find<NetworkManager>();

  final isConnected = true.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _fetchDataAndRefreshSource();
      },
    );
  }

  Future<void> _fetchDataAndRefreshSource() async {
    if (!await networkConn.isConnected()) {
      isConnected.value = false;
      return;
    }

    String formattedMonth =
        (months.indexOf(selectedMonth) + 1).toString().padLeft(2, '0');
    await controller.fetchLaporanRealisasi(
        int.parse(formattedMonth), int.parse(selectedYear));
    _updateLaporanSource();
    _updateLaporanUnfilledSource();
  }

  void _updateLaporanSource() {
    setState(() {
      source = LaporanRealisasiSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanEstimasiModel: controller.laporanRealisasiModel,
      );
    });
  }

  void _updateLaporanUnfilledSource() {
    setState(() {
      sourceUnfielld = LaporanRealisasiUnfieldSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanRealisasiUnfielld: controller.laporanRealisasiModel,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'Title': 135,
      'Day': double.nan,
      'Total': double.nan,
    };

    const double rowHeight = 50.0;
    const double headerHeight = 65.0;
    const double gridHeight = headerHeight + (rowHeight * 4);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Laporan Realisasi',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: networkConn.isConnected(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomCircularLoader());
          } else if (snapshot.hasError || !snapshot.data!) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomAnimationLoaderWidget(
                    text:
                        'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
                    animation: 'assets/animations/404.json',
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () async {
                      if (await networkConn.isConnected()) {
                        await _fetchDataAndRefreshSource();
                      } else {
                        SnackbarLoader.errorSnackBar(
                          title: 'Tidak ada internet',
                          message:
                              'Silahkan coba lagi setelah koneksi tersedia',
                        );
                      }
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            // Cek apakah source dan sourceUnfielld sudah diinisialisasi sebelum mengakses lastDayOfMonth
            if (source == null || sourceUnfielld == null) {
              return const Center(child: CustomCircularLoader());
            }

            final List<String> dayColumnNames = [
              for (int day = 1; day <= source!.lastDayOfMonth; day++) 'Day $day'
            ];

            final List<String> dayColumnNamesUnfilled = [
              for (int day = 1; day <= sourceUnfielld!.lastDayOfMonth; day++)
                'Day $day'
            ];

            return RefreshIndicator(
              onRefresh: () async => _fetchDataAndRefreshSource(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(CustomSize.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropDownWidget(
                            value: selectedMonth,
                            items: months,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedMonth = newValue!;
                                _fetchDataAndRefreshSource();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: CustomSize.sm),
                        Expanded(
                          flex: 2,
                          child: DropDownWidget(
                            value: selectedYear,
                            items: years,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedYear = newValue!;
                                _fetchDataAndRefreshSource();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: CustomSize.sm),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () async {
                              await _fetchDataAndRefreshSource();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: CustomSize.md),
                            ),
                            child: const Icon(Iconsax.calendar_search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: CustomSize.spaceBtwInputFields),
                  SizedBox(
                    height: gridHeight,
                    child: source != null
                        ? SfDataGrid(
                            source: source!,
                            frozenColumnsCount: 1,
                            columnWidthMode: ColumnWidthMode.fitByColumnName,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            verticalScrollPhysics:
                                const NeverScrollableScrollPhysics(),
                            allowColumnsResizing: true,
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              return true;
                            },
                            stackedHeaderRows: [
                              StackedHeaderRow(cells: [
                                StackedHeaderCell(
                                  columnNames: dayColumnNames,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: const Text(
                                      'Tanggal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                            columns: [
                              GridColumn(
                                columnName: 'Title',
                                width: columnWidths['Title']!,
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    '${selectedMonth.substring(0, 3)} / $selectedYear',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              for (int day = 1;
                                  day <= source!.lastDayOfMonth;
                                  day++)
                                GridColumn(
                                  width: columnWidths['Day']!,
                                  columnName: 'Day $day',
                                  label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      '$day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: day == DateTime.now().day
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                    ),
                                  ),
                                ),
                              GridColumn(
                                width: columnWidths['Total']!,
                                columnName: 'Total',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: const Text(
                                    'TOTAL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CustomCircularLoader()),
                  ),
                  const SizedBox(height: CustomSize.spaceBtwInputFields),
                  SizedBox(
                    height: gridHeight,
                    child: sourceUnfielld != null
                        ? SfDataGrid(
                            source: sourceUnfielld!,
                            frozenColumnsCount: 1,
                            columnWidthMode: ColumnWidthMode.fitByColumnName,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            verticalScrollPhysics:
                                const NeverScrollableScrollPhysics(),
                            allowColumnsResizing: true,
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              return true;
                            },
                            stackedHeaderRows: [
                              StackedHeaderRow(cells: [
                                StackedHeaderCell(
                                  columnNames: dayColumnNamesUnfilled,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: const Text(
                                      'Tanggal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                            columns: [
                              GridColumn(
                                columnName: 'Title',
                                width: columnWidths['Title']!,
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    '${selectedMonth.substring(0, 3)} / $selectedYear',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              for (int day = 1;
                                  day <= sourceUnfielld!.lastDayOfMonth;
                                  day++)
                                GridColumn(
                                  width: columnWidths['Day']!,
                                  columnName: 'Day $day',
                                  label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      '$day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: day == DateTime.now().day
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                    ),
                                  ),
                                ),
                              GridColumn(
                                width: columnWidths['Total']!,
                                columnName: 'Total',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: const Text(
                                    'TOTAL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CustomCircularLoader()),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        CustomSize.md, 0, CustomSize.md, CustomSize.sm),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text('Kembali')),
                        ),
                        const SizedBox(width: CustomSize.md),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () async {
                              String formattedMonth =
                                  (months.indexOf(selectedMonth) + 1)
                                      .toString()
                                      .padLeft(2, '0');

                              print('Ini bulan pdf dealer $formattedMonth');

                              // Generate dua jenis PDF
                              final pdfBytesWithHeader =
                                  await controller.createPDF(
                                      int.parse(formattedMonth),
                                      int.parse(selectedYear),
                                      withHeader: true);

                              final pdfBytesWithoutHeader =
                                  await controller.createPDF(
                                      int.parse(formattedMonth),
                                      int.parse(selectedYear),
                                      withHeader: false);

                              // Navigasi ke layar preview PDF
                              if (pdfBytesWithHeader.isNotEmpty &&
                                  pdfBytesWithoutHeader.isNotEmpty) {
                                Get.to(
                                  () => PdfPreviewScreen(
                                    pdfBytesWithHeader: pdfBytesWithHeader,
                                    pdfBytesWithoutHeader:
                                        pdfBytesWithoutHeader,
                                    fileName:
                                        'Laporan-Dealer-$formattedMonth-$selectedYear.pdf',
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                            child: const Icon(FontAwesomeIcons.solidFilePdf),
                          ),
                        ),
                        const SizedBox(width: CustomSize.md),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                String formattedMonth =
                                    (months.indexOf(selectedMonth) + 1)
                                        .toString()
                                        .padLeft(2, '0');

                                controller.downloadExcelForRealisasi(
                                    int.parse(formattedMonth),
                                    int.parse(selectedYear));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success),
                              child: const Icon(Iconsax.document_download)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
