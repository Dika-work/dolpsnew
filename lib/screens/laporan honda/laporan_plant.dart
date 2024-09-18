import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan honda/laporan_plant_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/source/laporan honda/laporan_plant_source.dart';
import '../../widgets/dropdown.dart';

class LaporanPlant extends StatefulWidget {
  const LaporanPlant({super.key});

  @override
  State<LaporanPlant> createState() => _LaporanPlantState();
}

class _LaporanPlantState extends State<LaporanPlant> {
  List<String> plant = [
    '1100',
    '1200',
    '1300',
    '1350',
    '1700',
    '1800',
    '1900',
  ];

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

  int? selectedIndex;
  String selectedPlant = '';

  LaporanPlantSource? laporanPlantSource;
  final controller = Get.put(LaporanPlantController());

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      selectedPlant = Get.arguments as String;
      selectedIndex = plant.indexOf(selectedPlant);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataAndRefreshSource();
    });
  }

  Future<void> _fetchDataAndRefreshSource() async {
    String formattedMonth =
        (months.indexOf(selectedMonth) + 1).toString().padLeft(2, '0');
    await controller.fetchLaporanPlant(formattedMonth, selectedYear);
    await controller.fetchLaporanRealisasi(formattedMonth, selectedYear);
    _updateLaporanSource();
  }

  void _updateLaporanSource() {
    setState(() {
      laporanPlantSource = LaporanPlantSource(
        selectedYear: int.parse(selectedYear),
        selectedMonth: months.indexOf(selectedMonth) + 1,
        plantModel: controller.laporanModel,
        plantRealisasi: controller.laporanRealisasiModel,
        selectedPlant: selectedPlant,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'Daerah': 135,
      'Day': double.nan,
      'TOTAL': double.nan,
    };

    const double rowHeight = 50.0;
    const double headerHeight = 56.0;

    const double gridHeight = headerHeight + (rowHeight * 18);

    final List<String> dayColumnNames = [
      for (int day = 1;
          day <= (laporanPlantSource?.lastDayOfMonth ?? 30);
          day++)
        'Day $day'
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _fetchDataAndRefreshSource(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.sm),
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
            Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children: List.generate(plant.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                        selectedPlant = plant[index];
                        _fetchDataAndRefreshSource(); // Panggil fungsi ini untuk memperbarui tabel
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CustomSize.sm)),
                    child: Text(plant[index],
                        style: Theme.of(context).textTheme.titleMedium?.apply(
                              color: selectedIndex == index
                                  ? Colors.red
                                  : Colors.white,
                            )),
                  );
                }),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            SizedBox(
              height: gridHeight,
              child: laporanPlantSource != null
                  ? SfDataGrid(
                      source: laporanPlantSource!,
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
                            columnNames: ['Daerah', ...dayColumnNames, 'TOTAL'],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'PLANT $selectedPlant', // Display selected plant here
                                style: const TextStyle(
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
                          width: columnWidths['Daerah']!,
                          columnName: 'Daerah',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              '${selectedMonth.substring(0, 3)}-$selectedYear', // Tampilkan bulan dan tahun yang telah diperbarui
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        for (int day = 1;
                            day <= laporanPlantSource!.lastDayOfMonth;
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
                          CircularProgressIndicator()), // Tampilkan loading spinner jika source masih null
            ),
          ],
        ),
      ),
    );
  }
}
