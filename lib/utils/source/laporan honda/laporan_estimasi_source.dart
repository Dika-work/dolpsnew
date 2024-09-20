import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/laporan_estimasi_model.dart';

class LaporanEstimasiSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanEstimasiModel> laporanEstimasiModel;

  LaporanEstimasiSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanEstimasiModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> estimasiData = [];

  void _buildData() {
    final List<int> doHarian = List.generate(lastDayOfMonth, (index) => 0);
    final List<int> doEstimasi = List.generate(lastDayOfMonth, (index) => 0);

    if (laporanEstimasiModel.isNotEmpty) {
      for (var model in laporanEstimasiModel) {
        final DateTime date = DateTime.parse(model.tgl);

        if (date.year == selectedYear && date.month == selectedMonth) {
          final int dayIndex = date.day - 1;

          doHarian[dayIndex] = model.doHarian;
          doEstimasi[dayIndex] = model.doEstimasi;
        }
      }
    }

    // Add DO Harian Row
    estimasiData.add(
      DataGridRow(
        cells: [
          const DataGridCell<String>(columnName: 'Title', value: 'DO Harian'),
          ...List.generate(lastDayOfMonth, (index) {
            return DataGridCell<int>(
                columnName: '${index + 1}', value: doHarian[index]);
          }),
          DataGridCell<int>(
              columnName: 'Total', value: doHarian.reduce((a, b) => a + b)),
        ],
      ),
    );

    // Add DO Estimasi Row
    estimasiData.add(
      DataGridRow(
        cells: [
          const DataGridCell<String>(columnName: 'Title', value: 'DO Estimasi'),
          ...List.generate(lastDayOfMonth, (index) {
            return DataGridCell<int>(
                columnName: '${index + 1}', value: doEstimasi[index]);
          }),
          DataGridCell<int>(
              columnName: 'Total', value: doEstimasi.reduce((a, b) => a + b)),
        ],
      ),
    );
  }

  @override
  List<DataGridRow> get rows => estimasiData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(dataCell.value.toString()),
        );
      }).toList(),
    );
  }
}

class LaporanEstimasiTentative extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanEstimasiModel> laporanEstimasiModel;

  LaporanEstimasiTentative({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanEstimasiModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> estimasiData = [];

  void _buildData() {
    final List<int> estimasiSRD = List.generate(lastDayOfMonth, (index) => 0);
    final List<int> estimasiMKS = List.generate(lastDayOfMonth, (index) => 0);
    final List<int> estimasiPTK = List.generate(lastDayOfMonth, (index) => 0);

    if (laporanEstimasiModel.isNotEmpty) {
      for (var model in laporanEstimasiModel) {
        final DateTime date = DateTime.parse(model.tgl);

        if (date.year == selectedYear && date.month == selectedMonth) {
          final int dayIndex = date.day - 1;

          estimasiSRD[dayIndex] = model.estimasiSRD;
          estimasiMKS[dayIndex] = model.estimasiMKS;
          estimasiPTK[dayIndex] = model.estimasiPTK;
        }
      }
    }

    // Add DO Estimasi SRD Row
    estimasiData.add(
      DataGridRow(
        cells: [
          const DataGridCell<String>(
              columnName: 'Title', value: 'DO Estimasi SRD'),
          ...List.generate(lastDayOfMonth, (index) {
            return DataGridCell<int>(
                columnName: '${index + 1}', value: estimasiSRD[index]);
          }),
          DataGridCell<int>(
              columnName: 'Total', value: estimasiSRD.reduce((a, b) => a + b)),
        ],
      ),
    );

    // Add DO Estimasi MKS Row
    estimasiData.add(
      DataGridRow(
        cells: [
          const DataGridCell<String>(
              columnName: 'Title', value: 'DO Estimasi MKS'),
          ...List.generate(lastDayOfMonth, (index) {
            return DataGridCell<int>(
                columnName: '${index + 1}', value: estimasiMKS[index]);
          }),
          DataGridCell<int>(
              columnName: 'Total', value: estimasiMKS.reduce((a, b) => a + b)),
        ],
      ),
    );

    // Add DO Estimasi PTK Row
    estimasiData.add(
      DataGridRow(
        cells: [
          const DataGridCell<String>(
              columnName: 'Title', value: 'DO Estimasi PTK'),
          ...List.generate(lastDayOfMonth, (index) {
            return DataGridCell<int>(
                columnName: '${index + 1}', value: estimasiPTK[index]);
          }),
          DataGridCell<int>(
              columnName: 'Total', value: estimasiPTK.reduce((a, b) => a + b)),
        ],
      ),
    );
  }

  @override
  List<DataGridRow> get rows => estimasiData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(dataCell.value.toString()),
        );
      }).toList(),
    );
  }
}
