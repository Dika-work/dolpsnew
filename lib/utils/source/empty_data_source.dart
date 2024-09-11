import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../constant/storage_util.dart';

class EmptyDataSource extends DataGridSource {
  final storageUtil = StorageUtil();
  final List<int> validPlants = [1100, 1200, 1300, 1350, 1700, 1800, 1900];
  final List<String> validTujuans = [
    'Sunter',
    'Pegangsaan',
    'Cibitung',
    'Cibitung',
    'Dawuan',
    'Dawuan',
    'Bekasi'
  ];

  List<Map<String, dynamic>> data = [];
  final dynamic user;

  EmptyDataSource({
    required bool isAdmin,
    required String userPlant,
  }) : user = StorageUtil().getUserDetails() {
    // Jika admin, tampilkan semua plant, jika tidak, filter berdasarkan plant user
    final filteredPlants = isAdmin
        ? validPlants
        : validPlants.where((plant) => plant.toString() == userPlant).toList();

    // Tambahkan data placeholder untuk admin
    for (int i = 0; i < filteredPlants.length; i++) {
      int plant = filteredPlants[i];
      Map<String, dynamic> rowData = {
        'No': i + 1,
        'Plant': plant,
        'Tujuan': validTujuans[validPlants.indexOf(plant)],
        'Jumlah': '-',
      };

      if (user.wilayah == 1 || user.wilayah == 0) rowData['HSO - SRD'] = '-';
      if (user.wilayah == 2 || user.wilayah == 0) rowData['HSO - MKS'] = '-';
      if (user.wilayah == 3 || user.wilayah == 0) rowData['HSO - PTK'] = '-';
      if (user.wilayah == 4 || user.wilayah == 0) rowData['BJM'] = '-';

      data.add(rowData);
    }
  }

  @override
  List<DataGridRow> get rows => data.map((data) {
        List<DataGridCell> cells = [
          DataGridCell<int>(columnName: 'No', value: data['No']),
          DataGridCell<int>(columnName: 'Plant', value: data['Plant']),
          DataGridCell<String>(columnName: 'Tujuan', value: data['Tujuan']),
          DataGridCell<String>(columnName: 'Jumlah', value: data['Jumlah']),
        ];

        if (user.wilayah == 1 || user.wilayah == 0) {
          cells.add(DataGridCell<String>(
              columnName: 'HSO - SRD', value: data['HSO - SRD']));
        }

        if (user.wilayah == 2 || user.wilayah == 0) {
          cells.add(DataGridCell<String>(
              columnName: 'HSO - MKS', value: data['HSO - MKS']));
        }

        if (user.wilayah == 3 || user.wilayah == 0) {
          cells.add(DataGridCell<String>(
              columnName: 'HSO - PTK', value: data['HSO - PTK']));
        }

        if (user.wilayah == 4 || user.wilayah == 0) {
          cells
              .add(DataGridCell<String>(columnName: 'BJM', value: data['BJM']));
        }

        return DataGridRow(cells: cells);
      }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Center(
          child: Text(
            cell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}

class EmptyAllDataSource extends DataGridSource {
  final List<int> validPlants = [1100, 1200, 1300, 1350, 1700, 1800, 1900];
  final List<String> validTujuans = [
    'Sunter',
    'Pegangsaan',
    'Cibitung',
    'Cibitung',
    'Dawuan',
    'Dawuan',
    'Bekasi'
  ];

  List<Map<String, dynamic>> data = [];

  EmptyAllDataSource() {
    // Generate data based on validPlants and validTujuans
    for (int i = 0; i < validPlants.length; i++) {
      data.add({
        'No': i + 1,
        'Plant': validPlants[i],
        'Tujuan': validTujuans[i],
        'Tanggal': '-',
        'HSO - SRD': '-',
        'HSO - MKS': '-',
        'HSO - PTK': '-',
        'BJM': '-',
        'Edit': '-',
        'Hapus': '-'
      });
    }
  }

  @override
  List<DataGridRow> get rows => data
      .map((data) => DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: data['No']),
            DataGridCell<int>(columnName: 'Plant', value: data['Plant']),
            DataGridCell<String>(columnName: 'Tujuan', value: data['Tujuan']),
            DataGridCell<String>(columnName: 'Tanggal', value: data['Tanggal']),
            DataGridCell<String>(
                columnName: 'HSO - SRD', value: data['HSO - SRD']),
            DataGridCell<String>(
                columnName: 'HSO - MKS', value: data['HSO - MKS']),
            DataGridCell<String>(
                columnName: 'HSO - PTK', value: data['HSO - PTK']),
            DataGridCell<String>(columnName: 'BJM', value: data['BJM']),
            DataGridCell<String>(columnName: 'Edit', value: data['Edit']),
            DataGridCell<String>(columnName: 'Hapus', value: data['Hapus']),
          ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            cell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}

class EmptyEstimasiSource extends DataGridSource {
  final List<int> validPlants = [
    1100,
    1200,
    1300,
    1350,
    1700,
    1800,
    1900,
  ];

  final List<String> validTujuans = [
    'Sunter',
    'Pegangsaan',
    'Cibitung',
    'Cibitung',
    'Dawuan',
    'Dawuan',
    'Cikarang',
  ];

  List<Map<String, dynamic>> data = [];

  EmptyEstimasiSource() {
    for (int i = 0; i < validPlants.length; i++) {
      data.add({
        'No': i + 1,
        'Plant': validPlants[i],
        'Tujuan': validTujuans[i],
        'Jumlah': '-',
        'Jumlah_M16': '-',
        'Jumlah_M40': '-',
        'Jumlah_M64': '-',
        'Jumlah_M86': '-',
        'Estimation_M16': '-',
        'Estimation_M40': '-',
        'Estimation_M64': '-',
        'Estimation_M86': '-',
        'TOTAL': '-'
      });
    }
  }

  @override
  List<DataGridRow> get rows {
    print("Empty rows: ${data.length}");
    return data
        .map(
          (data) => DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: data['No']),
            DataGridCell<int>(columnName: 'Plant', value: data['Plant']),
            DataGridCell<String>(columnName: 'Tujuan', value: data['Tujuan']),
            DataGridCell<String>(columnName: 'Jumlah', value: data['Jumlah']),
            DataGridCell<String>(
                columnName: 'Jumlah_M16', value: data['Jumlah_M16']),
            DataGridCell<String>(
                columnName: 'Jumlah_M40', value: data['Jumlah_M40']),
            DataGridCell<String>(
                columnName: 'Jumlah_M64', value: data['Jumlah_M64']),
            DataGridCell<String>(
                columnName: 'Jumlah_M86', value: data['Jumlah_M86']),
            DataGridCell<String>(
                columnName: 'Estimation_M16', value: data['Estimation_M16']),
            DataGridCell<String>(
                columnName: 'Estimation_M40', value: data['Estimation_M40']),
            DataGridCell<String>(
                columnName: 'Estimation_M64', value: data['Estimation_M64']),
            DataGridCell<String>(
                columnName: 'Estimation_M86', value: data['Estimation_M86']),
            DataGridCell<String>(columnName: 'TOTAL', value: data['TOTAL']),
          ]),
        )
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        final String columnName = cell.columnName;
        Color cellColor = Colors.transparent;

        // Apply green color only to Jumlah Ritase Mobil columns (M-16, M-40, M-64, M-86) in the "TOTAL" row
        if ((columnName == 'Jumlah_M16' ||
            columnName == 'Jumlah_M40' ||
            columnName == 'Jumlah_M64' ||
            columnName == 'Jumlah_M86')) {
          cellColor = Colors.green[100]!;
        }

        // Apply red color to Total Estimasi Unit Motor columns (M-16, M-40, M-64, M-86) up to the "TOTAL" row, but exclude "TOTAL DO" row
        if ((columnName == 'Estimation_M16' ||
            columnName == 'Estimation_M40' ||
            columnName == 'Estimation_M64' ||
            columnName == 'Estimation_M86')) {
          cellColor = Colors.red[100]!;
        }

        if (columnName == 'Jumlah') {
          cellColor = Colors.deepPurpleAccent[100]!;
        }

        if (columnName == 'TOTAL') {
          cellColor = Colors.green[100]!;
        }

        return Container(
          alignment: Alignment.center,
          color: cellColor,
          child: Text(
            cell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}

class EmptyEstimasiYamahaSuzukiSource extends DataGridSource {
  final List<String> plantName = [
    'DC (Pondok Ungu)',
    'TB (Tambun Bekasi)',
  ];

  final List<int> validPlants = [
    7,
    8,
  ];

  final List<String> validTujuans = [
    'Pondok Ungu',
    'Tambun Bekasi',
  ];

  List<Map<String, dynamic>> data = [];

  EmptyEstimasiYamahaSuzukiSource() {
    for (int i = 0; i < validPlants.length; i++) {
      data.add({
        'No': i + 1,
        'Plant': plantName[i],
        'PlantID': validPlants[i], // Plant ID for reference
        'Tujuan': validTujuans[i],
        'Jumlah': '-',
        'Jumlah_M16': '-',
        'Jumlah_M40': '-',
        'Jumlah_M64': '-',
        'Jumlah_M86': '-',
        'Estimation_M16': '-',
        'Estimation_M40': '-',
        'Estimation_M64': '-',
        'Estimation_M86': '-',
        'TOTAL': '-'
      });
    }
  }

  @override
  List<DataGridRow> get rows {
    print("Empty rows: ${data.length}");
    return data
        .map(
          (data) => DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: data['No']),
            DataGridCell<String>(columnName: 'Plant', value: data['Plant']),
            DataGridCell<String>(columnName: 'Tujuan', value: data['Tujuan']),
            DataGridCell<String>(columnName: 'Jumlah', value: data['Jumlah']),
            DataGridCell<String>(
                columnName: 'Jumlah_M16', value: data['Jumlah_M16']),
            DataGridCell<String>(
                columnName: 'Jumlah_M40', value: data['Jumlah_M40']),
            DataGridCell<String>(
                columnName: 'Jumlah_M64', value: data['Jumlah_M64']),
            DataGridCell<String>(
                columnName: 'Jumlah_M86', value: data['Jumlah_M86']),
            DataGridCell<String>(
                columnName: 'Estimation_M16', value: data['Estimation_M16']),
            DataGridCell<String>(
                columnName: 'Estimation_M40', value: data['Estimation_M40']),
            DataGridCell<String>(
                columnName: 'Estimation_M64', value: data['Estimation_M64']),
            DataGridCell<String>(
                columnName: 'Estimation_M86', value: data['Estimation_M86']),
            DataGridCell<String>(columnName: 'TOTAL', value: data['TOTAL']),
          ]),
        )
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        final String columnName = cell.columnName;
        Color cellColor = Colors.transparent;

        // Apply green color only to Jumlah Ritase Mobil columns (M-16, M-40, M-64, M-86) in the "TOTAL" row
        if ((columnName == 'Jumlah_M16' ||
            columnName == 'Jumlah_M40' ||
            columnName == 'Jumlah_M64' ||
            columnName == 'Jumlah_M86')) {
          cellColor = Colors.green[100]!;
        }

        // Apply red color to Total Estimasi Unit Motor columns (M-16, M-40, M-64, M-86) up to the "TOTAL" row, but exclude "TOTAL DO" row
        if ((columnName == 'Estimation_M16' ||
            columnName == 'Estimation_M40' ||
            columnName == 'Estimation_M64' ||
            columnName == 'Estimation_M86')) {
          cellColor = Colors.red[100]!;
        }

        if (columnName == 'Jumlah') {
          cellColor = Colors.deepPurpleAccent[100]!;
        }

        if (columnName == 'TOTAL') {
          cellColor = Colors.greenAccent[100]!;
        }

        return Container(
          alignment: Alignment.center,
          color: cellColor,
          child: Text(
            cell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}
