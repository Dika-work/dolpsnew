import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/constant/custom_size.dart';
import '../../utils/source/laporan honda/laporan_plant_source.dart';

class LaporanPlant extends StatefulWidget {
  const LaporanPlant({super.key});

  @override
  State<LaporanPlant> createState() => _LaporanPlantState();
}

class _LaporanPlantState extends State<LaporanPlant> {
  List<String> plant = [
    'PLANT 1100',
    'PLANT 1200',
    'PLANT 1300',
    'PLANT 1350',
    'PLANT 1700',
    'PLANT 1800',
    'PLANT 1900',
  ];

  int? selectedIndex;
  String selectedPlant = '';

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      selectedPlant = Get.arguments as String;
      selectedIndex = plant.indexOf(selectedPlant);
    }
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

    final nowMoth = DateFormat('MMM-yyyy').format(DateTime.now());
    final int selectedYear = DateTime.now().year;
    final int selectedMonth = DateTime.now().month;

    final LaporanPlantSource laporanPlantSource = LaporanPlantSource(
      selectedYear: selectedYear,
      selectedMonth: selectedMonth,
    );

    final List<String> dayColumnNames = [
      for (int day = 1; day <= laporanPlantSource.lastDayOfMonth; day++)
        'Day $day'
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
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
            const SizedBox(height: CustomSize.spaceBtwSections),
            SizedBox(
              height: gridHeight,
              child: SfDataGrid(
                source: laporanPlantSource,
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
                      columnNames: ['Daerah', ...dayColumnNames, 'TOTAL'],
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          selectedPlant, // Display selected plant here
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
                        nowMoth,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  for (int day = 1;
                      day <= laporanPlantSource.lastDayOfMonth;
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
