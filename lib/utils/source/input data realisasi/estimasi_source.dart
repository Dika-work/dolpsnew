import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/input data realisasi/estimasi_pengambilan_model.dart';

class EstimasiSource extends DataGridSource {
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

  // Vehicle capacity multipliers
  final Map<String, int> kapasitasMap = {
    'MOBIL MOTOR 16': 14,
    'MOBIL MOTOR 40': 35,
    'MOBIL MOTOR 64': 56,
    'MOBIL MOTOR 86': 76,
  };

  int index = 0;
  List<DataGridRow> estimasiData = [];
  int totalM16 = 0,
      totalM40 = 0,
      totalM64 = 0,
      totalM86 = 0,
      totalEstimation = 0;

  EstimasiSource({required List<EstimasiPengambilanModel> estimasiModel}) {
    estimasiData = validPlants.asMap().entries.map<DataGridRow>(
      (e) {
        int i = e.key;
        int plant = e.value;

        EstimasiPengambilanModel? dataGridRow = estimasiModel.firstWhere(
          (item) => item.plant1 == plant.toString(),
          orElse: () => EstimasiPengambilanModel(
              idPlant: plant,
              tujuan: validTujuans[i],
              type: 0,
              jenisKen: '',
              jumlah: 0,
              user: '',
              jam: '',
              tgl: '',
              status: 0,
              plant1: ''),
        );

        // Calculate total estimations
        int totalEstimationPerRow = 0;
        int jumlahM16 = 0, jumlahM40 = 0, jumlahM64 = 0, jumlahM86 = 0;

        if (dataGridRow.jenisKen.toUpperCase() == 'MOBIL MOTOR 16') {
          jumlahM16 = dataGridRow.jumlah;
          totalEstimationPerRow = kapasitasMap['MOBIL MOTOR 16']! * jumlahM16;
          totalM16 += jumlahM16;
        } else if (dataGridRow.jenisKen.toUpperCase() == 'MOBIL MOTOR 40') {
          jumlahM40 = dataGridRow.jumlah;
          totalEstimationPerRow = kapasitasMap['MOBIL MOTOR 40']! * jumlahM40;
          totalM40 += jumlahM40;
        } else if (dataGridRow.jenisKen.toUpperCase() == 'MOBIL MOTOR 64') {
          jumlahM64 = dataGridRow.jumlah;
          totalEstimationPerRow = kapasitasMap['MOBIL MOTOR 64']! * jumlahM64;
          totalM64 += jumlahM64;
        } else if (dataGridRow.jenisKen.toUpperCase() == 'MOBIL MOTOR 86') {
          jumlahM86 = dataGridRow.jumlah;
          totalEstimationPerRow = kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;
          totalM86 += jumlahM86;
        }

        totalEstimation += totalEstimationPerRow;

        index++;
        return DataGridRow(cells: [
          DataGridCell(columnName: 'No', value: index),
          DataGridCell(columnName: 'Plant', value: plant),
          DataGridCell(columnName: 'Tujuan', value: validTujuans[i]),
          DataGridCell(
              columnName: 'Jumlah', value: formatValue(dataGridRow.jumlah)),

          // Show 'Jumlah' for M-16, M-40, M-64, M-86
          DataGridCell(columnName: 'Jumlah_M16', value: formatValue(jumlahM16)),
          DataGridCell(columnName: 'Jumlah_M40', value: formatValue(jumlahM40)),
          DataGridCell(columnName: 'Jumlah_M64', value: formatValue(jumlahM64)),
          DataGridCell(columnName: 'Jumlah_M86', value: formatValue(jumlahM86)),

          // Show 'Total Estimasi' for M-16, M-40, M-64, M-86 (capacity * jumlah)
          DataGridCell(
              columnName: 'Estimation_M16',
              value: formatValue(kapasitasMap['MOBIL MOTOR 16']! * jumlahM16)),
          DataGridCell(
              columnName: 'Estimation_M40',
              value: formatValue(kapasitasMap['MOBIL MOTOR 40']! * jumlahM40)),
          DataGridCell(
              columnName: 'Estimation_M64',
              value: formatValue(kapasitasMap['MOBIL MOTOR 64']! * jumlahM64)),
          DataGridCell(
              columnName: 'Estimation_M86',
              value: formatValue(kapasitasMap['MOBIL MOTOR 86']! * jumlahM86)),
        ]);
      },
    ).toList();

    // Add total row at the bottom
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        const DataGridCell(columnName: 'Jumlah', value: ''),
        DataGridCell(columnName: 'Jumlah_M16', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M40', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M64', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M86', value: formatValue('')),
        DataGridCell(
            columnName: 'Estimation_M16', value: formatValue(totalM16)),
        DataGridCell(
            columnName: 'Estimation_M40', value: formatValue(totalM40)),
        DataGridCell(
            columnName: 'Estimation_M64', value: formatValue(totalM64)),
        DataGridCell(
            columnName: 'Estimation_M86', value: formatValue(totalM86)),
      ]),
    );
  }

  // Helper function to format the values, replacing 0 with '-'
  String formatValue(dynamic value) {
    if (value == 0 || value == null) {
      return '-';
    }
    return value.toString();
  }

  @override
  List<DataGridRow> get rows => estimasiData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = estimasiData.indexOf(row);
    bool isTotalRow = rowIndex == estimasiData.length - 1;

    return DataGridRowAdapter(
      color: isTotalRow
          ? Colors.green[100]
          : (rowIndex % 2 == 0 ? Colors.white : Colors.grey[200]),
      cells: row.getCells().map<Widget>((dataGridCell) {
        final String columnName = dataGridCell.columnName;
        final dynamic value = dataGridCell.value;

        Color cellColor = Colors.transparent;

        // Color the "Total Estimasi" cells in red
        if (isTotalRow) {
          cellColor = Colors.green[100]!;
        } else if (columnName == 'Estimation_M16' ||
            columnName == 'Estimation_M40' ||
            columnName == 'Estimation_M64' ||
            columnName == 'Estimation_M86') {
          cellColor = Colors.red[100]!;
        }

        return Container(
          alignment: Alignment.center,
          color: cellColor,
          child: Text(
            value.toString(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
