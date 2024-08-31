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
