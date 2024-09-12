import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LaporanPlantSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;

  LaporanPlantSource({required this.selectedYear, required this.selectedMonth})
      : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> laporanData = [];

  void _buildData() {
    // Daftar daerah
    List<String> regions = ['SRD', 'MKS', 'PTK', 'BJM'];

    // Generate data untuk setiap daerah
    for (String region in regions) {
      List<int> totalDO = List.generate(lastDayOfMonth, (index) => 0);
      List<int> realisasiDO = List.generate(lastDayOfMonth, (index) => 0);
      List<int> unfilledDO = List.generate(lastDayOfMonth, (index) => 0);

      // Hitung total untuk setiap kategori
      int totalDOHarian = totalDO.reduce((a, b) => a + b);
      int totalRealisasiDO = realisasiDO.reduce((a, b) => a + b);
      int totalUnfilledDO = unfilledDO.reduce((a, b) => a + b);

      // Tambahkan tiga baris untuk setiap daerah
      laporanData.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Daerah', value: region),
          ...List.generate(
              lastDayOfMonth,
              (index) => DataGridCell<int>(
                  columnName: 'Total DO $index', value: totalDO[index])),
          DataGridCell<int>(
              columnName: 'TOTAL', value: totalDOHarian), // Tambahkan total
        ]),
      );

      // Tambahkan row untuk TOTAL DO HARIAN
      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'TOTAL DO HARIAN'),
          ...List.generate(
              lastDayOfMonth,
              (index) => DataGridCell<int>(
                  columnName: 'Total DO Harian $index', value: totalDO[index])),
          DataGridCell<int>(
              columnName: 'TOTAL', value: totalDOHarian), // Total Harian
        ]),
      );

      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'DO REALISASI'),
          ...List.generate(
              lastDayOfMonth,
              (index) => DataGridCell<int>(
                  columnName: 'Realisasi DO $index',
                  value: realisasiDO[index])),
          DataGridCell<int>(
              columnName: 'TOTAL', value: totalRealisasiDO), // Tambahkan total
        ]),
      );

      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'DO UNFILLED'),
          ...List.generate(
              lastDayOfMonth,
              (index) => DataGridCell<int>(
                  columnName: 'Unfilled DO $index', value: unfilledDO[index])),
          DataGridCell<int>(
              columnName: 'TOTAL', value: totalUnfilledDO), // Tambahkan total
        ]),
      );
    }
  }

  @override
  List<DataGridRow> get rows => laporanData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final region = row.getCells().first.value.toString();

    Color backgroundColor;
    switch (region) {
      case 'SRD':
        backgroundColor = Colors.yellow.shade300; // Warna untuk SRD
        break;
      case 'MKS':
        backgroundColor = Colors.red.shade300; // Warna untuk MKS
        break;
      case 'PTK':
        backgroundColor = Colors.green.shade300; // Warna untuk PTK
        break;
      case 'BJM':
        backgroundColor = Colors.blue.shade300; // Warna untuk BJM
        break;
      default:
        backgroundColor = Colors.white; // Default color jika tidak sesuai
    }

    return DataGridRowAdapter(
        color: backgroundColor,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              dataGridCell.value.toString(),
              style: TextStyle(
                  color: (dataGridCell.columnName.contains('Unfilled') &&
                          dataGridCell.value < 0)
                      ? Colors.red
                      : Colors.black),
            ),
          );
        }).toList());
  }
}
