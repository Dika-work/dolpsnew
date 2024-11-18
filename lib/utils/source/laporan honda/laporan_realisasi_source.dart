import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/laporan_realisasi_model.dart';

class LaporanRealisasiSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanRealisasiModel> laporanEstimasiModel;

  LaporanRealisasiSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanEstimasiModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> realisasiData = [];

  void _buildData() {
    final List<int> doGlobal = List.generate(lastDayOfMonth, (index) => 0);
    final List<int> doHarian = List.generate(lastDayOfMonth, (index) => 0);

    for (var model in laporanEstimasiModel) {
      final DateTime date = DateTime.parse(model.tgl);

      if (date.year == selectedYear && date.month == selectedMonth) {
        final int dayIndex = date.day - 1;

        doGlobal[dayIndex] = model.jumlahGlobal;
        doHarian[dayIndex] = model.jumlahHarian;
      }
    }

    // Menghitung total dan rata-rata DO Global (dengan pembulatan ke int)
    final int totalGlobal = doGlobal.reduce((a, b) => a + b);
    // final int avgGlobal = totalGlobal ~/ lastDayOfMonth;

    // Menghitung total dan rata-rata DO Harian (dengan pembulatan ke int)
    final int totalHarian = doHarian.reduce((a, b) => a + b);
    // final int avgHarian = totalHarian ~/ lastDayOfMonth;

    // add DO Global
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Global'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: doGlobal[index]);
        },
      ),
      // DataGridCell<int>(columnName: 'Avg', value: avgGlobal),
      DataGridCell<int>(columnName: 'Total', value: totalGlobal),
    ]));

    // add DO Harian
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Harian'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: doHarian[index]);
        },
      ),
      // DataGridCell<int>(columnName: 'Avg', value: avgHarian),
      DataGridCell<int>(columnName: 'Total', value: totalHarian),
    ]));

    // add DO Kompetitor
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Kompetitor'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}',
              value: doGlobal[index] - doHarian[index]);
        },
      ),
      // const DataGridCell<String>(columnName: 'Avg', value: ''),
      DataGridCell<int>(columnName: 'Total', value: totalGlobal - totalHarian),
    ]));
  }

  @override
  List<DataGridRow> get rows => realisasiData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        final dynamic cellValue = dataCell.value;

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataCell.value.toString(),
            style: TextStyle(
              color: (cellValue is int && cellValue < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class LaporanRealisasiUnfieldSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanRealisasiModel> laporanRealisasiUnfielld;

  LaporanRealisasiUnfieldSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanRealisasiUnfielld,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> realisasiData = [];

  void _buildData() {
    final List<int> doHarian = List.generate(lastDayOfMonth, (index) => 0);
    final List<int> doRealisasi = List.generate(lastDayOfMonth, (index) => 0);

    for (var model in laporanRealisasiUnfielld) {
      final DateTime date = DateTime.parse(model.tgl);

      if (date.year == selectedYear && date.month == selectedMonth) {
        final int dayIndex = date.day - 1;

        doHarian[dayIndex] = model.jumlahHarian;
        doRealisasi[dayIndex] = model.jumlahRealisasi;
      }
    }

    // Menghitung total dan rata-rata DO Global (dengan pembulatan ke int)
    final int totalGlobal = doRealisasi.reduce((a, b) => a + b);
    // final int avgGlobal = totalGlobal ~/ lastDayOfMonth;

    // Menghitung total dan rata-rata DO Harian (dengan pembulatan ke int)
    final int totalHarian = doHarian.reduce((a, b) => a + b);
    // final int avgHarian = totalHarian ~/ lastDayOfMonth;

    // add DO Global
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Harian'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: doHarian[index]);
        },
      ),
      // DataGridCell<int>(columnName: 'Avg', value: avgGlobal),
      DataGridCell<int>(columnName: 'Total', value: totalHarian),
    ]));

    // add DO Harian
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Realisasi'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: doRealisasi[index]);
        },
      ),
      // DataGridCell<int>(columnName: 'Avg', value: avgHarian),
      DataGridCell<int>(columnName: 'Total', value: totalGlobal),
    ]));

    // add DO Kompetitor
    realisasiData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'Title', value: 'DO Unfilled'),
      ...List.generate(
        lastDayOfMonth,
        (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}',
              value: doHarian[index] - doRealisasi[index]);
        },
      ),
      // const DataGridCell<String>(columnName: 'Avg', value: ''),
      DataGridCell<int>(columnName: 'Total', value: totalHarian - totalGlobal),
    ]));
  }

  @override
  List<DataGridRow> get rows => realisasiData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        final dynamic cellValue = dataCell.value;

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataCell.value.toString(),
            style: TextStyle(
              color: (cellValue is int && cellValue < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
