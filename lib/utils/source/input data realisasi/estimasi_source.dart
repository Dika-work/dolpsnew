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

  // Calculate totalDO (sum of Jumlah column)
  int totalDO = 0;

  // Total column sum
  int totalColumnSum = 0;

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
        final totalKanan = kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 +
            kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 +
            kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 +
            kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;

        // Update totalDO with the jumlah for this row
        totalDO += dataGridRow.jumlah;

        // Add to total column sum
        totalColumnSum += totalKanan;

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
          DataGridCell(columnName: 'TOTAL', value: formatValue(totalKanan)),
        ]);
      },
    ).toList();

    // Add TOTAL row first
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(
            columnName: 'Jumlah',
            value: formatValue(totalDO)), // Set totalDO here
        DataGridCell(columnName: 'Jumlah_M16', value: formatValue(totalM16)),
        DataGridCell(columnName: 'Jumlah_M40', value: formatValue(totalM40)),
        DataGridCell(columnName: 'Jumlah_M64', value: formatValue(totalM64)),
        DataGridCell(columnName: 'Jumlah_M86', value: formatValue(totalM86)),
        DataGridCell(
            columnName: 'Estimation_M16', value: formatValue(totalM16)),
        DataGridCell(
            columnName: 'Estimation_M40', value: formatValue(totalM40)),
        DataGridCell(
            columnName: 'Estimation_M64', value: formatValue(totalM64)),
        DataGridCell(
            columnName: 'Estimation_M86', value: formatValue(totalM86)),
        DataGridCell(columnName: 'TOTAL', value: formatValue('')),
      ]),
    );

    // Add TOTAL DO row below TOTAL row
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL DO'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M16', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M40', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M64', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M86', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M16', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M40', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M64', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M86', value: formatValue('')),
        DataGridCell(columnName: 'TOTAL', value: formatValue('')),
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
    bool isTotalRow = row.getCells().any((cell) => cell.value == 'TOTAL');
    bool isTotalDoRow = row.getCells().any((cell) => cell.value == 'TOTAL DO');

    int totalRowSum = 0; // Sum for the TOTAL row

    if (isTotalRow && !isTotalDoRow) {
      totalRowSum = row
          .getCells()
          .where((cell) =>
              cell.columnName != 'No' &&
              cell.columnName != 'Plant' &&
              cell.columnName != 'Tujuan' &&
              cell.columnName != 'Jumlah') // Sum other columns
          .fold(
              0,
              (prev, cell) =>
                  prev + (int.tryParse(cell.value.toString()) ?? 0));
    }

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((dataGridCell) {
        final String columnName = dataGridCell.columnName;
        final dynamic value = dataGridCell.value;

        Color cellColor = Colors.transparent;

        // Apply green color only to Jumlah Ritase Mobil columns (M-16, M-40, M-64, M-86) in the "TOTAL" row
        if (isTotalRow &&
            (columnName == 'Jumlah_M16' ||
                columnName == 'Jumlah_M40' ||
                columnName == 'Jumlah_M64' ||
                columnName == 'Jumlah_M86')) {
          cellColor = Colors.green[100]!;
        }

        // Apply red color to Total Estimasi Unit Motor columns (M-16, M-40, M-64, M-86) up to the "TOTAL" row, but exclude "TOTAL DO" row
        if (!isTotalRow &&
            !isTotalDoRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.red[100]!;
        }

        // Apply yellow color for the estimation columns in the "TOTAL" row
        if (isTotalRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.yellowAccent[100]!;
        }

        if (columnName == 'TOTAL' && !isTotalRow && !isTotalDoRow) {
          cellColor = Colors.green[100]!;
        }

        if (columnName == 'Jumlah' && isTotalRow) {
          cellColor = Colors.deepPurpleAccent[100]!;
        }

        // Display the sum at the intersection of the TOTAL row and TOTAL column
        if (columnName == 'TOTAL' && isTotalRow) {
          int totalSum = totalColumnSum + totalRowSum;
          return Container(
            alignment: Alignment.center,
            color: Colors.deepOrangeAccent[100]!,
            child: Text(
              formatValue(totalSum).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }

        // Normal handling for other cells
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

class EstimasiYamahaSuzuki extends DataGridSource {
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

  // Calculate totalDO (sum of Jumlah column)
  int totalDO = 0;

  // Total column sum
  int totalColumnSum = 0;

  EstimasiYamahaSuzuki(
      {required List<EstimasiPengambilanModel> estimasiYamahaModel}) {
    estimasiData = validPlants.asMap().entries.map<DataGridRow>(
      (e) {
        int i = e.key;
        int plant = e.value;

        EstimasiPengambilanModel? dataGridRow = estimasiYamahaModel.firstWhere(
          (item) => item.idPlant == plant,
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
        final totalKanan = kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 +
            kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 +
            kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 +
            kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;

        // Update totalDO with the jumlah for this row
        totalDO += dataGridRow.jumlah;

        // Add to total column sum
        totalColumnSum += totalKanan;

        index++;
        return DataGridRow(cells: [
          DataGridCell(columnName: 'No', value: index),
          DataGridCell(columnName: 'Plant', value: plantName[i]),
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
          DataGridCell(columnName: 'TOTAL', value: formatValue(totalKanan)),
        ]);
      },
    ).toList();

    // Add TOTAL row first
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(
            columnName: 'Jumlah',
            value: formatValue(totalDO)), // Set totalDO here
        DataGridCell(columnName: 'Jumlah_M16', value: formatValue(totalM16)),
        DataGridCell(columnName: 'Jumlah_M40', value: formatValue(totalM40)),
        DataGridCell(columnName: 'Jumlah_M64', value: formatValue(totalM64)),
        DataGridCell(columnName: 'Jumlah_M86', value: formatValue(totalM86)),
        DataGridCell(
            columnName: 'Estimation_M16', value: formatValue(totalM16)),
        DataGridCell(
            columnName: 'Estimation_M40', value: formatValue(totalM40)),
        DataGridCell(
            columnName: 'Estimation_M64', value: formatValue(totalM64)),
        DataGridCell(
            columnName: 'Estimation_M86', value: formatValue(totalM86)),
        DataGridCell(columnName: 'TOTAL', value: formatValue('')),
      ]),
    );

    // Add TOTAL DO row below TOTAL row
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL DO'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M16', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M40', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M64', value: formatValue('')),
        DataGridCell(columnName: 'Jumlah_M86', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M16', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M40', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M64', value: formatValue('')),
        DataGridCell(columnName: 'Estimation_M86', value: formatValue('')),
        DataGridCell(columnName: 'TOTAL', value: formatValue('')),
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
    bool isTotalRow = row.getCells().any((cell) => cell.value == 'TOTAL');
    bool isTotalDoRow = row.getCells().any((cell) => cell.value == 'TOTAL DO');

    int totalRowSum = 0; // Sum for the TOTAL row

    if (isTotalRow && !isTotalDoRow) {
      totalRowSum = row
          .getCells()
          .where((cell) =>
              cell.columnName != 'No' &&
              cell.columnName != 'Plant' &&
              cell.columnName != 'Tujuan' &&
              cell.columnName != 'Jumlah') // Sum other columns
          .fold(
              0,
              (prev, cell) =>
                  prev + (int.tryParse(cell.value.toString()) ?? 0));
    }

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((dataGridCell) {
        final String columnName = dataGridCell.columnName;
        final dynamic value = dataGridCell.value;

        Color cellColor = Colors.transparent;

        // Apply green color only to Jumlah Ritase Mobil columns (M-16, M-40, M-64, M-86) in the "TOTAL" row
        if (isTotalRow &&
            (columnName == 'Jumlah_M16' ||
                columnName == 'Jumlah_M40' ||
                columnName == 'Jumlah_M64' ||
                columnName == 'Jumlah_M86')) {
          cellColor = Colors.green[100]!;
        }

        // Apply red color to Total Estimasi Unit Motor columns (M-16, M-40, M-64, M-86) up to the "TOTAL" row, but exclude "TOTAL DO" row
        if (!isTotalRow &&
            !isTotalDoRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.red[100]!;
        }

        // Apply yellow color for the estimation columns in the "TOTAL" row
        if (isTotalRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.yellowAccent[100]!;
        }

        if (columnName == 'TOTAL' && !isTotalRow && !isTotalDoRow) {
          cellColor = Colors.green[100]!;
        }

        if (columnName == 'Jumlah' && isTotalRow) {
          cellColor = Colors.deepPurpleAccent[100]!;
        }

        // Display the sum at the intersection of the TOTAL row and TOTAL column
        if (columnName == 'TOTAL' && isTotalRow) {
          int totalSum = totalColumnSum + totalRowSum;
          return Container(
            alignment: Alignment.center,
            color: Colors.deepOrangeAccent[100]!,
            child: Text(
              formatValue(totalSum).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }

        // Normal handling for other cells
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
