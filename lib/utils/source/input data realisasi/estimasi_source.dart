import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../constant/custom_size.dart';

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

  final Map<String, int> kapasitasMap = {
    'MOBIL MOTOR 16': 14,
    'MOBIL MOTOR 40': 35,
    'MOBIL MOTOR 64': 56,
    'MOBIL MOTOR 86': 76,
  };

  List<DataGridRow> estimasiData = [];
  int totalM16 = 0, totalM40 = 0, totalM64 = 0, totalM86 = 0;
  int totalDO = 0, totalColumnSum = 0, totalEstimation = 0;

  EstimasiSource({required List<EstimasiPengambilanModel> estimasiModel}) {
    estimasiData = validPlants.asMap().entries.map<DataGridRow>((e) {
      int i = e.key;
      int plant = e.value;

      List<EstimasiPengambilanModel> plantData = estimasiModel
          .where((item) => item.plant1 == plant.toString())
          .toList();

      if (plantData.isEmpty) {
        return DataGridRow(cells: [
          DataGridCell(columnName: 'No', value: i + 1),
          DataGridCell(columnName: 'Plant', value: plant),
          DataGridCell(columnName: 'Tujuan', value: validTujuans[i]),
          const DataGridCell(columnName: 'Jumlah', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M16', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M40', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M64', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M86', value: '-'),
          const DataGridCell(columnName: 'Estimation_M16', value: '-'),
          const DataGridCell(columnName: 'Estimation_M40', value: '-'),
          const DataGridCell(columnName: 'Estimation_M64', value: '-'),
          const DataGridCell(columnName: 'Estimation_M86', value: '-'),
          const DataGridCell(columnName: 'TOTAL', value: '-'),
        ]);
      }

      int jumlahM16 = 0, jumlahM40 = 0, jumlahM64 = 0, jumlahM86 = 0;
      int totalEstimationPerRow = 0;

      for (var dataGridRow in plantData) {
        if (dataGridRow.jenisKen.toUpperCase().contains('MOBIL MOTOR 16')) {
          jumlahM16 = dataGridRow.jumlah;
          totalEstimationPerRow += kapasitasMap['MOBIL MOTOR 16']! * jumlahM16;
          totalM16 += jumlahM16;
        }
        if (dataGridRow.jenisKen.toUpperCase().contains('MOBIL MOTOR 40')) {
          jumlahM40 = dataGridRow.jumlah;
          totalEstimationPerRow += kapasitasMap['MOBIL MOTOR 40']! * jumlahM40;
          totalM40 += jumlahM40;
        }
        if (dataGridRow.jenisKen.toUpperCase().contains('MOBIL MOTOR 64')) {
          jumlahM64 = dataGridRow.jumlah;
          totalEstimationPerRow += kapasitasMap['MOBIL MOTOR 64']! * jumlahM64;
          totalM64 += jumlahM64;
        }
        if (dataGridRow.jenisKen.toUpperCase().contains('MOBIL MOTOR 86')) {
          jumlahM86 = dataGridRow.jumlah;
          totalEstimationPerRow += kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;
          totalM86 += jumlahM86;
        }
      }

      final totalKanan = kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 +
          kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 +
          kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 +
          kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;

      totalEstimation += totalEstimationPerRow;
      totalDO += jumlahM16 + jumlahM40 + jumlahM64 + jumlahM86;
      totalColumnSum += totalKanan;

      return DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: i + 1),
        DataGridCell(columnName: 'Plant', value: plant),
        DataGridCell(columnName: 'Tujuan', value: validTujuans[i]),
        DataGridCell(columnName: 'Jumlah', value: totalDO),
        DataGridCell(
            columnName: 'Jumlah_M16', value: jumlahM16 == 0 ? '-' : jumlahM16),
        DataGridCell(
            columnName: 'Jumlah_M40', value: jumlahM40 == 0 ? '-' : jumlahM40),
        DataGridCell(
            columnName: 'Jumlah_M64', value: jumlahM64 == 0 ? '-' : jumlahM64),
        DataGridCell(
            columnName: 'Jumlah_M86', value: jumlahM86 == 0 ? '-' : jumlahM86),
        DataGridCell(
            columnName: 'Estimation_M16',
            value: kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 16']! * jumlahM16),
        DataGridCell(
            columnName: 'Estimation_M40',
            value: kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 40']! * jumlahM40),
        DataGridCell(
            columnName: 'Estimation_M64',
            value: kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 64']! * jumlahM64),
        DataGridCell(
            columnName: 'Estimation_M86',
            value: kapasitasMap['MOBIL MOTOR 86']! * jumlahM86 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 86']! * jumlahM86),
        DataGridCell(columnName: 'TOTAL', value: totalKanan),
      ]);
    }).toList();

    // Tambahkan baris TOTAL
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: totalDO),
        DataGridCell(columnName: 'Jumlah_M16', value: totalM16),
        DataGridCell(columnName: 'Jumlah_M40', value: totalM40),
        DataGridCell(columnName: 'Jumlah_M64', value: totalM64),
        DataGridCell(columnName: 'Jumlah_M86', value: totalM86),
        DataGridCell(
            columnName: 'Estimation_M16',
            value: kapasitasMap['MOBIL MOTOR 16']! * totalM16),
        DataGridCell(
            columnName: 'Estimation_M40',
            value: kapasitasMap['MOBIL MOTOR 40']! * totalM40),
        DataGridCell(
            columnName: 'Estimation_M64',
            value: kapasitasMap['MOBIL MOTOR 64']! * totalM64),
        DataGridCell(
            columnName: 'Estimation_M86',
            value: kapasitasMap['MOBIL MOTOR 86']! * totalM86),
        DataGridCell(columnName: 'TOTAL', value: totalColumnSum),
      ]),
    );

    // Tambahkan baris TOTAL DO
    estimasiData.add(
      const DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: ''),
        DataGridCell(columnName: 'Plant', value: 'TOTAL DO'),
        DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: '-'),
        DataGridCell(columnName: 'Jumlah_M16', value: '-'),
        DataGridCell(columnName: 'Jumlah_M40', value: '-'),
        DataGridCell(columnName: 'Jumlah_M64', value: '-'),
        DataGridCell(columnName: 'Jumlah_M86', value: '-'),
        DataGridCell(columnName: 'Estimation_M16', value: '-'),
        DataGridCell(columnName: 'Estimation_M40', value: '-'),
        DataGridCell(columnName: 'Estimation_M64', value: '-'),
        DataGridCell(columnName: 'Estimation_M86', value: '-'),
        DataGridCell(columnName: 'TOTAL', value: '-'),
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

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((dataGridCell) {
        final String columnName = dataGridCell.columnName;
        final dynamic value = dataGridCell.value;

        Color cellColor = Colors.transparent;

        // Terapkan warna hijau pada kolom Jumlah Ritase Mobil di baris "TOTAL"
        if (isTotalRow &&
            (columnName == 'Jumlah_M16' ||
                columnName == 'Jumlah_M40' ||
                columnName == 'Jumlah_M64' ||
                columnName == 'Jumlah_M86')) {
          cellColor = Colors.green[100]!;
        }

        // Terapkan warna merah pada kolom Total Estimasi Unit Motor, kecuali baris "TOTAL DO"
        if (!isTotalRow &&
            !isTotalDoRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.red[100]!;
        }

        // Terapkan warna kuning untuk kolom estimasi di baris "TOTAL"
        if (isTotalRow &&
            (columnName == 'Estimation_M16' ||
                columnName == 'Estimation_M40' ||
                columnName == 'Estimation_M64' ||
                columnName == 'Estimation_M86')) {
          cellColor = Colors.yellowAccent[100]!;
        }

        // Warna hijau untuk kolom TOTAL jika tidak di baris TOTAL atau TOTAL DO
        if (columnName == 'TOTAL' && !isTotalRow && !isTotalDoRow) {
          cellColor = Colors.green[100]!;
        }

        // Warna ungu pada kolom Jumlah di baris TOTAL
        if (columnName == 'Jumlah' && isTotalRow) {
          cellColor = Colors.deepPurpleAccent[100]!;
        }

        // Tampilkan jumlah total pada persimpangan baris dan kolom TOTAL
        if (columnName == 'TOTAL' && isTotalRow) {
          return Container(
            alignment: Alignment.center,
            color: Colors.deepOrangeAccent[100]!,
            child: Text(
              totalColumnSum.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }

        // Penanganan normal untuk sel lainnya
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
    estimasiData = validPlants.asMap().entries.map<DataGridRow>((e) {
      int i = e.key;
      int plant = e.value;

      List<EstimasiPengambilanModel> plantData =
          estimasiYamahaModel.where((item) => item.idPlant == plant).toList();

      // If there's no data, still display Plant and Tujuan with empty rows
      if (plantData.isEmpty) {
        return DataGridRow(cells: [
          DataGridCell(columnName: 'No', value: i + 1),
          DataGridCell(columnName: 'Plant', value: plantName[i]),
          DataGridCell(columnName: 'Tujuan', value: validTujuans[i]),
          const DataGridCell(columnName: 'Jumlah', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M16', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M40', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M64', value: '-'),
          const DataGridCell(columnName: 'Jumlah_M86', value: '-'),
          const DataGridCell(columnName: 'Estimation_M16', value: '-'),
          const DataGridCell(columnName: 'Estimation_M40', value: '-'),
          const DataGridCell(columnName: 'Estimation_M64', value: '-'),
          const DataGridCell(columnName: 'Estimation_M86', value: '-'),
          const DataGridCell(columnName: 'TOTAL', value: '-'),
        ]);
      }

      // Calculate estimations and totals for the row
      int jumlahM16 = 0, jumlahM40 = 0, jumlahM64 = 0, jumlahM86 = 0;
      int totalEstimationPerRow = 0;

      for (var dataGridRow in plantData) {
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
      }

      totalEstimation += totalEstimationPerRow;
      final totalKanan = kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 +
          kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 +
          kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 +
          kapasitasMap['MOBIL MOTOR 86']! * jumlahM86;

      // Update totalDO with the jumlah for this row
      totalDO += jumlahM16 + jumlahM40 + jumlahM64 + jumlahM86;

      // Add to total column sum
      totalColumnSum += totalKanan;

      return DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: i + 1),
        DataGridCell(columnName: 'Plant', value: plantName[i]),
        DataGridCell(columnName: 'Tujuan', value: validTujuans[i]),
        DataGridCell(columnName: 'Jumlah', value: totalDO),
        DataGridCell(
            columnName: 'Jumlah_M16', value: jumlahM16 == 0 ? '-' : jumlahM16),
        DataGridCell(
            columnName: 'Jumlah_M40', value: jumlahM40 == 0 ? '-' : jumlahM40),
        DataGridCell(
            columnName: 'Jumlah_M64', value: jumlahM64 == 0 ? '-' : jumlahM64),
        DataGridCell(
            columnName: 'Jumlah_M86', value: jumlahM86 == 0 ? '-' : jumlahM86),
        DataGridCell(
            columnName: 'Estimation_M16',
            value: kapasitasMap['MOBIL MOTOR 16']! * jumlahM16 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 16']! * jumlahM16),
        DataGridCell(
            columnName: 'Estimation_M40',
            value: kapasitasMap['MOBIL MOTOR 40']! * jumlahM40 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 40']! * jumlahM40),
        DataGridCell(
            columnName: 'Estimation_M64',
            value: kapasitasMap['MOBIL MOTOR 64']! * jumlahM64 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 64']! * jumlahM64),
        DataGridCell(
            columnName: 'Estimation_M86',
            value: kapasitasMap['MOBIL MOTOR 86']! * jumlahM86 == 0
                ? '-'
                : kapasitasMap['MOBIL MOTOR 86']! * jumlahM86),
        DataGridCell(columnName: 'TOTAL', value: totalKanan),
      ]);
    }).toList();

    // Add TOTAL row first
    estimasiData.add(
      DataGridRow(cells: [
        const DataGridCell(columnName: 'No', value: ''),
        const DataGridCell(columnName: 'Plant', value: 'TOTAL'),
        const DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: totalDO),
        DataGridCell(columnName: 'Jumlah_M16', value: totalM16),
        DataGridCell(columnName: 'Jumlah_M40', value: totalM40),
        DataGridCell(columnName: 'Jumlah_M64', value: totalM64),
        DataGridCell(columnName: 'Jumlah_M86', value: totalM86),
        DataGridCell(
            columnName: 'Estimation_M16',
            value: kapasitasMap['MOBIL MOTOR 16']! * totalM16),
        DataGridCell(
            columnName: 'Estimation_M40',
            value: kapasitasMap['MOBIL MOTOR 40']! * totalM40),
        DataGridCell(
            columnName: 'Estimation_M64',
            value: kapasitasMap['MOBIL MOTOR 64']! * totalM64),
        DataGridCell(
            columnName: 'Estimation_M86',
            value: kapasitasMap['MOBIL MOTOR 86']! * totalM86),
        DataGridCell(columnName: 'TOTAL', value: totalColumnSum),
      ]),
    );

    // Add TOTAL DO row below TOTAL row
    estimasiData.add(
      const DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: ''),
        DataGridCell(columnName: 'Plant', value: 'TOTAL DO'),
        DataGridCell(columnName: 'Tujuan', value: ''),
        DataGridCell(columnName: 'Jumlah', value: '-'),
        DataGridCell(columnName: 'Jumlah_M16', value: '-'),
        DataGridCell(columnName: 'Jumlah_M40', value: '-'),
        DataGridCell(columnName: 'Jumlah_M64', value: '-'),
        DataGridCell(columnName: 'Jumlah_M86', value: '-'),
        DataGridCell(columnName: 'Estimation_M16', value: '-'),
        DataGridCell(columnName: 'Estimation_M40', value: '-'),
        DataGridCell(columnName: 'Estimation_M64', value: '-'),
        DataGridCell(columnName: 'Estimation_M86', value: '-'),
        DataGridCell(columnName: 'TOTAL', value: '-'),
      ]),
    );
  }

  @override
  List<DataGridRow> get rows => estimasiData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = estimasiData.indexOf(row);
    bool isTotalRow = row.getCells().any((cell) => cell.value == 'TOTAL');
    bool isTotalDoRow = row.getCells().any((cell) => cell.value == 'TOTAL DO');

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
          return Container(
            alignment: Alignment.center,
            color: Colors.deepOrangeAccent[100]!,
            child: Text(
              totalColumnSum.toString(),
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

class EstimasiPmSource extends DataGridSource {
  final void Function(EstimasiPengambilanModel)? onEdited;
  final void Function(EstimasiPengambilanModel)? onDeleted;
  final List<EstimasiPengambilanModel> estimasiPmModel;
  int startIndex = 0;
  List<DataGridRow> estimasiPmData = [];

  EstimasiPmSource({
    required this.onEdited,
    required this.onDeleted,
    required this.estimasiPmModel,
    int startIndex = 0,
  }) {
    int index = startIndex;

    estimasiPmData = estimasiPmModel.asMap().entries.map<DataGridRow>(
      (entry) {
        final e = entry.value;
        index++;
        final tglParsed =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.tgl));

        return DataGridRow(
          cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Tanggal', value: tglParsed),
            DataGridCell<String>(columnName: 'Plant', value: e.plant1),
            DataGridCell<String>(columnName: 'Tujuan', value: e.tujuan),
            DataGridCell<String>(
                columnName: 'Type', value: e.type == 0 ? 'REGULER' : 'MUTASI'),
            DataGridCell<String>(columnName: 'Jenis', value: e.jenisKen),
            DataGridCell<int>(columnName: 'Jumlah', value: e.jumlah),
            DataGridCell<String>(columnName: 'User', value: e.user),
          ],
        );
      },
    ).toList();
  }

  @override
  List<DataGridRow> get rows => estimasiPmData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = estimasiPmData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = row.getCells().map<Widget>(
      (e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            textAlign: TextAlign.center,
          ),
        );
      },
    ).toList();

    // Add action buttons for edit and delete
    cells.add(
      Container(
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {
            if (onEdited != null && estimasiPmModel.isNotEmpty) {
              onEdited!(estimasiPmModel[startIndex + rowIndex]);
            }
          },
          icon: const Icon(Iconsax.grid_edit),
        ),
      ),
    );

    cells.add(
      Container(
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {
            if (onDeleted != null && estimasiPmModel.isNotEmpty) {
              onDeleted!(estimasiPmModel[startIndex + rowIndex]);
            }
          },
          icon: const Icon(Iconsax.trash, color: Colors.red),
        ),
      ),
    );

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }
}
