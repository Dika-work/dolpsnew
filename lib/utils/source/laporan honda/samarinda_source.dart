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
    Map<int, int> doGlobalResults =
        {}; // Untuk menyimpan hasil DO Global per bulan
    Map<int, int> doHarianResults =
        {}; // Untuk menyimpan hasil DO Harian per bulan

    // Memasukkan data dari samarindaModel ke dalam map sesuai dengan sumber_data dan bulan
    for (var data in samarindaModel) {
      if (data.sumberData == "do_global") {
        doGlobalResults[data.bulan] = data.hasil;
      } else if (data.sumberData == "do_harian") {
        doHarianResults[data.bulan] = data.hasil;
      }
    }

    // DO Global row
    List<DataGridCell> doGlobalCells = [
      const DataGridCell<String>(columnName: 'Daerah', value: 'DO GLOBAL'),
    ];

    List<DataGridCell> doHarianCells = [
      const DataGridCell<String>(columnName: 'Daerah', value: 'DO HARIAN'),
    ];

    List<DataGridCell> selisihCells = [
      const DataGridCell<String>(columnName: 'Daerah', value: 'SELISIH'),
    ];

    int totalGlobal = 0;
    int totalHarian = 0;

    for (int i = 1; i <= numberOfMonths; i++) {
      // Mengisi nilai DO Global
      int globalResult = doGlobalResults[i] ?? 0;
      doGlobalCells
          .add(DataGridCell<int>(columnName: 'Bulan $i', value: globalResult));
      totalGlobal += globalResult;

      // Mengisi nilai DO Harian
      int harianResult = doHarianResults[i] ?? 0;
      doHarianCells
          .add(DataGridCell<int>(columnName: 'Bulan $i', value: harianResult));
      totalHarian += harianResult;

      // Menghitung selisih (DO Harian - DO Global)
      int selisih = globalResult - harianResult;
      selisihCells
          .add(DataGridCell<int>(columnName: 'Bulan $i', value: selisih));
    }

    // Tambahkan total di akhir
    doGlobalCells
        .add(DataGridCell<int>(columnName: 'TOTAL', value: totalGlobal));
    doHarianCells
        .add(DataGridCell<int>(columnName: 'TOTAL', value: totalHarian));
    selisihCells.add(DataGridCell<int>(
        columnName: 'TOTAL', value: totalGlobal - totalHarian));

    // Tambahkan row ke DataGrid
    samarindaData.add(DataGridRow(cells: doGlobalCells));
    samarindaData.add(DataGridRow(cells: doHarianCells));
    samarindaData.add(DataGridRow(cells: selisihCells));
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
              color: (dataGridCell.value is int && dataGridCell.value < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
