import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/laporan_dealer_model.dart';

class LaporanDealerSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanDealerModel> dealerModel;

  LaporanDealerSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.dealerModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> dealerData = [];

  // Helper method to initialize a map with days in the month set to 0
  Map<int, int> _initializeMapForDays() {
    return {
      for (var item in List.generate(lastDayOfMonth, (index) => index + 1))
        item: 0
    };
  }

  void _buildData() {
    // Group data by sumber and daerah
    Map<String, Map<String, Map<int, int>>> groupedData = {};

    if (dealerModel.isNotEmpty) {
      for (var model in dealerModel) {
        final DateTime date = DateTime.parse(model.tgl);
        if (date.year == selectedYear && date.month == selectedMonth) {
          final String daerah = model.daerah;
          final String sumber = model.sumberData;
          final int dayIndex = date.day;

          // Initialize the region if not yet present
          if (!groupedData.containsKey(sumber)) {
            groupedData[sumber] = {};
          }

          // Initialize the area if not yet present
          if (!groupedData[sumber]!.containsKey(daerah)) {
            groupedData[sumber]![daerah] = _initializeMapForDays();
          }

          // Add the jumlah to the correct day, ensuring non-null values
          groupedData[sumber]![daerah]![dayIndex] =
              (groupedData[sumber]![daerah]![dayIndex] ?? 0) + (model.jumlah);
        }
      }
    }

    // Now build the rows dynamically based on the grouped data
    for (var sumber in groupedData.keys) {
      for (var daerah in groupedData[sumber]!.keys) {
        final List<DataGridCell> rowCells = [
          DataGridCell<String>(columnName: 'Title', value: '$sumber $daerah'),
        ];

        int total = 0;
        for (int day = 1; day <= lastDayOfMonth; day++) {
          final int jumlah = groupedData[sumber]![daerah]![day] ?? 0;
          rowCells.add(DataGridCell<int>(columnName: '$day', value: jumlah));
          total += jumlah;
        }

        // Add the total cell at the end
        rowCells.add(DataGridCell<int>(columnName: 'Total', value: total));

        dealerData.add(DataGridRow(cells: rowCells));
      }
    }
  }

  @override
  List<DataGridRow> get rows => dealerData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value.toString(),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
