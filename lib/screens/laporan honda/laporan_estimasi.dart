import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/laporan_estimasi_controller.dart';
import '../../helpers/connectivity.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/source/laporan honda/laporan_estimasi_source.dart';
import '../../widgets/dropdown.dart';

class LaporanEstimasi extends StatefulWidget {
  const LaporanEstimasi({super.key});

  @override
  State<LaporanEstimasi> createState() => _LaporanEstimasiState();
}

class _LaporanEstimasiState extends State<LaporanEstimasi> {
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

  LaporanEstimasiSource? source;
  LaporanEstimasiTentative? sourceTentative;
  final controller = Get.put(LaporanEstimasiController());
  final networkConn = Get.find<NetworkManager>();

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
      SnackbarLoader.errorSnackBar(
        title: 'Koneksi Terputus',
        message: 'Anda telah kehilangan koneksi internet.',
      );
    }
    String formattedMonth =
        (months.indexOf(selectedMonth) + 1).toString().padLeft(2, '0');

    try {
      await controller.fetchLaporanEstimasi(formattedMonth, selectedYear);
      _updateLaporanSource();
      _updateLaporanTentativeSource();
    } catch (error) {
      // Handle error (e.g., no internet)
      print('Error fetching data: $error');
      // Fallback with empty data (zeros) for the table
      _updateLaporanSourceWithDefaultValues();
      _updateLaporanTentativeSourceWithDefaultValues();
    }
  }

  void _updateLaporanSourceWithDefaultValues() {
    setState(() {
      source = LaporanEstimasiSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanEstimasiModel: [], // Pass an empty list to represent no data
      );
    });
  }

  void _updateLaporanTentativeSourceWithDefaultValues() {
    setState(() {
      sourceTentative = LaporanEstimasiTentative(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanEstimasiModel: [], // Pass an empty list to represent no data
      );
    });
  }

  void _updateLaporanSource() {
    // Call setState only once when the source is updated
    setState(() {
      source = LaporanEstimasiSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanEstimasiModel: controller.laporanEstimasiModel,
      );
    });
  }

  void _updateLaporanTentativeSource() {
    // Call setState only once when the source is updated
    setState(() {
      sourceTentative = LaporanEstimasiTentative(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanEstimasiModel: controller.laporanEstimasiModel,
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
    const double headerHeight = 73.0;

    const double gridHeight = headerHeight + (rowHeight * 4);
    const double gridTentativeHeight = headerHeight + (rowHeight * 5);

    final List<String> dayColumnNames = [
      for (int day = 1; day <= (source?.lastDayOfMonth ?? 30); day++) 'Day $day'
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          'Laporan Estimasi',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchDataAndRefreshSource(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(CustomSize.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: DropDownWidget(
                      value: selectedMonth, // Gunakan variabel sementara
                      items: months,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                          print('INI BULAN YANG DI PILIH $selectedMonth');
                          _fetchDataAndRefreshSource();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: CustomSize.sm),
                  Expanded(
                    flex: 2,
                    child: DropDownWidget(
                      value: selectedYear, // Gunakan variabel sementara
                      items: years,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                          print('INI TAHUN YANG DI PILIH $selectedYear');
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
                        await _fetchDataAndRefreshSource(); // Pastikan tombol memperbarui nilai di dalam setState
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: CustomSize.md)),
                      child: const Icon(Iconsax.calendar_search),
                    ),
                  )
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
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: ['Title', ...dayColumnNames, 'Total'],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'DO ESTIMASI (TENTATIVE) & DO HARIAN', // Display selected plant here
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ]),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        for (int day = 1; day <= source!.lastDayOfMonth; day++)
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
                                            : Colors.black),
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
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            SizedBox(
              height: gridTentativeHeight,
              child: sourceTentative != null
                  ? SfDataGrid(
                      source: sourceTentative!,
                      frozenColumnsCount: 1,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: ['Title', ...dayColumnNames, 'Total'],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'DO ESTIMASI (TENTATIVE) & DO HARIAN', // Display selected plant here
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ]),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        for (int day = 1; day <= source!.lastDayOfMonth; day++)
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
                                            : Colors.black),
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
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
