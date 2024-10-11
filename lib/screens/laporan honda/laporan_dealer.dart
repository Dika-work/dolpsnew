import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/laporan_dealer_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/laporan honda/laporan_dealer_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/laporan honda/laporan_dealer_source.dart';
import '../../widgets/dropdown.dart';

class LaporanDealer extends StatefulWidget {
  const LaporanDealer({super.key});

  @override
  State<LaporanDealer> createState() => _LaporanDealerState();
}

class _LaporanDealerState extends State<LaporanDealer> {
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

  LaporanGlobalSource? dealerSource;
  LaporanHarianSource? dealerHarianSource;
  LaporanRealisasiSource? dealerRealisasiSource;

  final controller = Get.put(LaporanDealerController());
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
      _setTableDataToZero(); // Set table data to zero if not connected
      return;
    }

    String formattedMonth =
        (months.indexOf(selectedMonth) + 1).toString().padLeft(2, '0');
    print('ini format bulan nya : $formattedMonth');
    await controller.fetchLaporanEstimasi(formattedMonth, selectedYear);
    _updateLaporanSource();
    _updateLaporanHarianSource();
    _updateLaporanRealisasiSource();
  }

  void _setTableDataToZero() {
    setState(() {
      // Setting up the LaporanGlobalSource with zero data
      dealerSource = LaporanGlobalSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: _generateZeroData(),
      );

      // Similarly set other sources to zero data
      dealerHarianSource = LaporanHarianSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: _generateZeroData(),
      );

      dealerRealisasiSource = LaporanRealisasiSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: _generateZeroData(),
      );
    });
  }

// Helper function to generate zero data for the table
  List<LaporanDealerModel> _generateZeroData() {
    List<LaporanDealerModel> zeroData = [];
    for (int day = 1;
        day <=
            DateTime(int.parse(selectedYear), months.indexOf(selectedMonth) + 1,
                    0)
                .day;
        day++) {
      zeroData.add(LaporanDealerModel(
        tgl: DateTime(
                int.parse(selectedYear), months.indexOf(selectedMonth) + 1, day)
            .toIso8601String(),
        daerah: 'SAMARINDA', // Adjust the region here based on your needs
        jumlah: 0,
        sumberData:
            'global', // Adjust this field as necessary for other sources
      ));
      zeroData.add(LaporanDealerModel(
        tgl: DateTime(
                int.parse(selectedYear), months.indexOf(selectedMonth) + 1, day)
            .toIso8601String(),
        daerah: 'MAKASAR',
        jumlah: 0,
        sumberData: 'global',
      ));
      zeroData.add(LaporanDealerModel(
        tgl: DateTime(
                int.parse(selectedYear), months.indexOf(selectedMonth) + 1, day)
            .toIso8601String(),
        daerah: 'PONTIANAK',
        jumlah: 0,
        sumberData: 'global',
      ));
      zeroData.add(LaporanDealerModel(
        tgl: DateTime(
                int.parse(selectedYear), months.indexOf(selectedMonth) + 1, day)
            .toIso8601String(),
        daerah: 'BANJARMASIN',
        jumlah: 0,
        sumberData: 'global',
      ));
    }
    return zeroData;
  }

  void _updateLaporanSource() {
    // Call setState only once when the source is updated
    setState(() {
      dealerSource = LaporanGlobalSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: controller.dealerModel,
      );
    });
  }

  void _updateLaporanHarianSource() {
    // Call setState only once when the source is updated
    setState(() {
      dealerHarianSource = LaporanHarianSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: controller.dealerModel,
      );
    });
  }

  void _updateLaporanRealisasiSource() {
    // Call setState only once when the source is updated
    setState(() {
      dealerRealisasiSource = LaporanRealisasiSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        laporanDealerModel: controller.dealerModel,
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

    const double gridHeight = headerHeight + (rowHeight * 6);

    final List<String> dayColumnNames = [
      for (int day = 1; day <= (dealerSource?.lastDayOfMonth ?? 30); day++)
        'Day $day'
    ];

    final List<String> dayColumnHarianNames = [
      for (int day = 1;
          day <= (dealerHarianSource?.lastDayOfMonth ?? 30);
          day++)
        'Day $day'
    ];

    final List<String> dayColumnRealisasiNames = [
      for (int day = 1;
          day <= (dealerRealisasiSource?.lastDayOfMonth ?? 30);
          day++)
        'Day $day'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Dealer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchDataAndRefreshSource(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              CustomSize.sm, CustomSize.sm, CustomSize.sm, 0),
          children: [
            Row(
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
                      padding:
                          const EdgeInsets.symmetric(vertical: CustomSize.md),
                    ),
                    child: const Icon(Iconsax.calendar_search),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            dealerSource != null
                ? SizedBox(
                    height: gridHeight,
                    child: SfDataGrid(
                      source: dealerSource!,
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
                                'DO GLOBAL BERDASARKAN DEALER', // Display selected plant here
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomCircularLoader(),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            dealerHarianSource != null
                ? SizedBox(
                    height: gridHeight,
                    child: SfDataGrid(
                      source: dealerHarianSource!,
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
                            columnNames: [
                              'Title',
                              ...dayColumnHarianNames,
                              'Total'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'DO HARIAN BERDASARKAN DEALER', // Display selected plant here
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
                            columnNames: dayColumnHarianNames,
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
                        for (int day = 1;
                            day <= dealerHarianSource!.lastDayOfMonth;
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomCircularLoader(),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            dealerRealisasiSource != null
                ? SizedBox(
                    height: gridHeight,
                    child: SfDataGrid(
                      source: dealerRealisasiSource!,
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
                            columnNames: [
                              'Title',
                              ...dayColumnRealisasiNames,
                              'Total'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'DO REALISASI BERDASARKAN DEALER', // Display selected plant here
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
                            columnNames: dayColumnRealisasiNames,
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
                        for (int day = 1;
                            day <= dealerRealisasiSource!.lastDayOfMonth;
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomCircularLoader(),
          ],
        ),
      ),
    );
  }
}
