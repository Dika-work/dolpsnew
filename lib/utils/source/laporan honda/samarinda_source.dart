import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/samarinda_model.dart';

class SamarindaSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final List<SamarindaModel> samarindaModel;

  // Constructor menerima input bulan, tahun, dan data model
  SamarindaSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.samarindaModel,
  }) {
    _buildData(); // Memanggil fungsi untuk membangun data row
  }

  List<DataGridRow> samarindaData = [];

  // Fungsi untuk mengkonversi data model menjadi DataGridRow
  void _buildData() {
    const int numberOfMonths = 12; // Jumlah bulan tetap 12

    // DO Global row
    samarindaData.add(
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Daerah', value: 'DO GLOBAL'),
        ...List.generate(
          numberOfMonths,
          (index) => DataGridCell<int>(
              columnName: 'Bulan ${index + 1}',
              value: 0), // Menggunakan 1 sampai 12
        ),
        const DataGridCell<int>(columnName: 'TOTAL', value: 0),
      ]),
    );

    // DO Harian row
    samarindaData.add(
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Daerah', value: 'DO HARIAN'),
        ...List.generate(
          numberOfMonths,
          (index) => DataGridCell<int>(
              columnName: 'Bulan ${index + 1}',
              value: 0), // Menggunakan 1 sampai 12
        ),
        const DataGridCell<int>(columnName: 'TOTAL', value: 0),
      ]),
    );

    // Selisih row
    samarindaData.add(
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Daerah', value: 'SELISIH'),
        ...List.generate(
          numberOfMonths,
          (index) => DataGridCell<int>(
              columnName: 'Bulan ${index + 1}',
              value: 0), // Menggunakan 1 sampai 12
        ),
        const DataGridCell<int>(columnName: 'TOTAL', value: 0),
      ]),
    );
  }

  @override
  List<DataGridRow> get rows => samarindaData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataGridCell.value.toString(),
            style: TextStyle(
              color: (dataGridCell.columnName.contains('Unfilled') &&
                      dataGridCell.value < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
