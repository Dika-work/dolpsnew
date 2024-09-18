import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/samarinda_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/source/laporan honda/samarinda_source.dart';
import '../../widgets/dropdown.dart';

class LaporanSamarinda extends StatefulWidget {
  const LaporanSamarinda({super.key});

  @override
  State<LaporanSamarinda> createState() => _LaporanSamarindaState();
}

class _LaporanSamarindaState extends State<LaporanSamarinda> {
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
    'Des'
  ];

  List<String> years = ['2021', '2022', '2023', '2024', '2025'];

  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = ""; // Jangan diinisialisasi langsung

  SamarindaSource? samarindaSource;
  final controller = Get.put(SamarindaController());

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
    await controller.fetchLaporanSamarinda(int.parse(selectedYear));
    print("Data diambil: ${controller.samarindaModel.length} entri");
    setState(() {
      _updateLaporanSource();
    });
  }

  void _updateLaporanSource() {
    setState(() {
      samarindaSource = SamarindaSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        samarindaModel: controller.samarindaModel,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'Daerah': 135,
      'Bulan': double.nan,
      'TOTAL': double.nan,
    };

    const double rowHeight = 50.0;
    const double headerHeight = 65.0;

    const double gridHeight = headerHeight + (rowHeight * 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan samarinda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _fetchDataAndRefreshSource(),
        child: ListView(
          padding: const EdgeInsets.only(
              left: CustomSize.sm, right: CustomSize.sm, top: CustomSize.sm),
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
                    onPressed: () {
                      _fetchDataAndRefreshSource();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: CustomSize.md)),
                    child: const Icon(Iconsax.calendar_search),
                  ),
                )
              ],
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            SizedBox(
              height: gridHeight,
              child: samarindaSource != null
                  ? SfDataGrid(
                      source: samarindaSource!,
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
                              'Bulan 1',
                              'Bulan 2',
                              'Bulan 3',
                              'Bulan 4',
                              'Bulan 5',
                              'Bulan 6',
                              'Bulan 7',
                              'Bulan 8',
                              'Bulan 9',
                              'Bulan 10',
                              'Bulan 11',
                              'Bulan 12'
                            ], // Kolom bulan yang sesuai
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Bulan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ],
                      columns: [
                        GridColumn(
                          width: columnWidths['Daerah']!,
                          columnName: 'Daerah',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              '${selectedMonth.substring(0, 3)} / $selectedYear',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        for (int i = 0; i < 12; i++)
                          GridColumn(
                            width: columnWidths['Bulan']!,
                            columnName: 'Bulan ${i + 1}',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                months[
                                    i], // Menampilkan nama bulan (Jan, Feb, dst.)
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          (i == months.indexOf(selectedMonth))
                                              ? Colors.red
                                              : Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        GridColumn(
                          width: columnWidths['TOTAL']!,
                          columnName: 'TOTAL',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'TOTAL',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child:
                          CircularProgressIndicator()), // Tampilkan loading jika null
            )
          ],
        ),
      ),
    );
  }
}
