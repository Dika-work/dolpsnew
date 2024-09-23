import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/laporan_dealer_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/laporan honda/laporan_dealer_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/laporan honda/laporan_dealer_source.dart';
import '../../widgets/dropdown.dart';

class LaporanDealer extends StatefulWidget {
  const LaporanDealer({super.key});

  @override
  State<LaporanDealer> createState() => _LaporanDealerState();
}

class _LaporanDealerState extends State<LaporanDealer> {
  List<String> months = [
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
    'Dec'
  ];

  List<String> years = ['2021', '2022', '2023', '2024', '2025'];

  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = ""; // Jangan diinisialisasi langsung

  LaporanDealerSource? dealerSource;
  final controller = Get.put(LaporanDealerController());
  final networkConn = Get.find<NetworkManager>();

  @override
  void initState() {
    super.initState();
    // Inisialisasi selectedMonth di dalam initState()
    selectedMonth = months[DateTime.now().month - 1];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataAndRefreshSource();
    });
  }

  Future<void> _fetchDataAndRefreshSource() async {
    if (!await networkConn.isConnected()) {
      SnackbarLoader.errorSnackBar(
        title: 'Koneksi Terputus',
        message: 'Anda telah kehilangan koneksi internet.',
      );
      return;
    }

    try {
      await controller.fetchLaporanEstimasi(selectedMonth, selectedYear);

      final filteredData = controller.dealerModel.where((data) {
        DateTime date = DateTime.parse(data.tgl);

        // Filter data yang memiliki tahun dan bulan yang sesuai dengan pilihan pengguna
        return date.year == int.parse(selectedYear) &&
            date.month == (months.indexOf(selectedMonth) + 1);
      }).toList();

      controller.dealerModel.assignAll(filteredData);
    } catch (e) {
      controller.dealerModel.assignAll(_generateDefaultData());
    }

    // Memperbarui sumber data untuk tampilan
    _updateLaporanSource();
  }

  List<LaporanDealerModel> _generateDefaultData() {
    // Dapatkan bulan dan tahun sekarang
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

    List<LaporanDealerModel> defaultData = [];
    final lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    for (int i = 1; i <= lastDayOfMonth; i++) {
      defaultData.add(LaporanDealerModel(
        tgl:
            '$currentYear-${currentMonth.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}',
        daerah: 'Samarinda',
        sumberData: 'do_global',
        jumlah: 0,
      ));
    }

    return defaultData;
  }

  void _updateLaporanSource() {
    setState(() {
      dealerSource = LaporanDealerSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        dealerModel: controller.dealerModel,
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

    final List<String> dayColumnNames = [
      for (int day = 1; day <= (dealerSource?.lastDayOfMonth ?? 30); day++)
        'Day $day'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Samarinda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            CustomSize.sm, CustomSize.sm, CustomSize.sm, 0),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: DropDownWidget(
                  value: selectedYear,
                  items: years,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue!;
                      print('INI TAHUN YANG DIPILIH $selectedYear');
                      _fetchDataAndRefreshSource();
                    });
                  },
                ),
              ),
              const SizedBox(width: CustomSize.sm),
              Expanded(
                flex: 2,
                child: DropDownWidget(
                  value: selectedMonth,
                  items: months,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                      print('INI BULAN YANG DIPILIH $selectedMonth');
                      _fetchDataAndRefreshSource();
                    });
                  },
                ),
              ),
              const SizedBox(width: CustomSize.sm),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    _fetchDataAndRefreshSource();
                  },
                  style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: CustomSize.md)),
                  child: const Icon(Iconsax.calendar_search),
                ),
              ),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwInputFields),
          // Here you can place the table or list that shows the filtered data
          dealerSource != null
              ? SizedBox(
                  height: gridHeight,
                  child: SfDataGrid(
                    source: dealerSource!,
                    frozenColumnsCount: 1,
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                    allowColumnsResizing: true,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
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
                              'DO BERDASARKAN DEALER', // Display selected plant here
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      for (int day = 1;
                          day <= dealerSource!.lastDayOfMonth;
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
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
