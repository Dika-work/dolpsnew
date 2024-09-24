import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/laporan_dealer_model.dart';

class LaporanGlobalSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final List<LaporanDealerModel> laporanDealerModel;

  LaporanGlobalSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanDealerModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> globalData = [];
  final int lastDayOfMonth;

  void _buildData() {
    final Map<String, List<int>> doGlobal = {
      "DO Global SRD": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global MKS": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global PTK": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global BJM": List.generate(lastDayOfMonth, (index) => 0),
    };

    // Process each model entry
    for (var model in laporanDealerModel) {
      final DateTime date = DateTime.parse(model.tgl);

      if (date.year == selectedYear &&
          date.month == selectedMonth &&
          model.sumberData == 'global') {
        final int dayIndex = date.day - 1;
        switch (model.daerah) {
          case 'SAMARINDA':
            doGlobal["DO Global SRD"]![dayIndex] += model.jumlah;
            break;
          case 'MAKASAR':
            doGlobal["DO Global MKS"]![dayIndex] += model.jumlah;
            break;
          case 'PONTIANAK':
            doGlobal["DO Global PTK"]![dayIndex] += model.jumlah;
            break;
          case 'BANJARMASIN':
            doGlobal["DO Global BJM"]![dayIndex] += model.jumlah;
            break;
        }
      }
    }

    // Add DO Global data for each region (SRD, MKS, PTK, BJM)
    doGlobal.forEach((region, data) {
      final int total = data.reduce((a, b) => a + b);
      globalData.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Title', value: region),
        ...List.generate(lastDayOfMonth, (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: data[index]);
        }),
        DataGridCell<int>(columnName: 'Total', value: total),
      ]));
    });
  }

  @override
  List<DataGridRow> get rows => globalData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataCell.value.toString(),
            style: TextStyle(
              color: (dataCell.value is int && dataCell.value < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class LaporanHarianSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final List<LaporanDealerModel> laporanDealerModel;

  LaporanHarianSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanDealerModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> globalData = [];
  final int lastDayOfMonth;

  void _buildData() {
    final Map<String, List<int>> doGlobal = {
      "DO Global SRD": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global MKS": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global PTK": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global BJM": List.generate(lastDayOfMonth, (index) => 0),
    };

    // Process each model entry
    for (var model in laporanDealerModel) {
      final DateTime date = DateTime.parse(model.tgl);

      if (date.year == selectedYear &&
          date.month == selectedMonth &&
          model.sumberData == 'harian') {
        final int dayIndex = date.day - 1;
        switch (model.daerah) {
          case 'SAMARINDA':
            doGlobal["DO Global SRD"]![dayIndex] += model.jumlah;
            break;
          case 'MAKASAR':
            doGlobal["DO Global MKS"]![dayIndex] += model.jumlah;
            break;
          case 'PONTIANAK':
            doGlobal["DO Global PTK"]![dayIndex] += model.jumlah;
            break;
          case 'BANJARMASIN':
            doGlobal["DO Global BJM"]![dayIndex] += model.jumlah;
            break;
        }
      }
    }

    // Add DO Global data for each region (SRD, MKS, PTK, BJM)
    doGlobal.forEach((region, data) {
      final int total = data.reduce((a, b) => a + b);
      globalData.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Title', value: region),
        ...List.generate(lastDayOfMonth, (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: data[index]);
        }),
        DataGridCell<int>(columnName: 'Total', value: total),
      ]));
    });
  }

  @override
  List<DataGridRow> get rows => globalData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataCell.value.toString(),
            style: TextStyle(
              color: (dataCell.value is int && dataCell.value < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class LaporanRealisasiSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final List<LaporanDealerModel> laporanDealerModel;

  LaporanRealisasiSource({
    required this.selectedYear,
    required this.selectedMonth,
    required this.laporanDealerModel,
  }) : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> globalData = [];
  final int lastDayOfMonth;

  void _buildData() {
    final Map<String, List<int>> doGlobal = {
      "DO Global SRD": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global MKS": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global PTK": List.generate(lastDayOfMonth, (index) => 0),
      "DO Global BJM": List.generate(lastDayOfMonth, (index) => 0),
    };

    // Process each model entry
    for (var model in laporanDealerModel) {
      final DateTime date = DateTime.parse(model.tgl);

      if (date.year == selectedYear &&
          date.month == selectedMonth &&
          model.sumberData == 'realisasi') {
        final int dayIndex = date.day - 1;
        switch (model.daerah) {
          case 'SAMARINDA':
            doGlobal["DO Global SRD"]![dayIndex] += model.jumlah;
            break;
          case 'MAKASAR':
            doGlobal["DO Global MKS"]![dayIndex] += model.jumlah;
            break;
          case 'PONTIANAK':
            doGlobal["DO Global PTK"]![dayIndex] += model.jumlah;
            break;
          case 'BANJARMASIN':
            doGlobal["DO Global BJM"]![dayIndex] += model.jumlah;
            break;
        }
      }
    }

    // Add DO Global data for each region (SRD, MKS, PTK, BJM)
    doGlobal.forEach((region, data) {
      final int total = data.reduce((a, b) => a + b);
      globalData.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Title', value: region),
        ...List.generate(lastDayOfMonth, (index) {
          return DataGridCell<int>(
              columnName: '${index + 1}', value: data[index]);
        }),
        DataGridCell<int>(columnName: 'Total', value: total),
      ]));
    });
  }

  @override
  List<DataGridRow> get rows => globalData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataCell.value.toString(),
            style: TextStyle(
              color: (dataCell.value is int && dataCell.value < 0)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
