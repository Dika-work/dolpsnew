import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/do_global_harian.dart';
import '../../theme/app_colors.dart';

class DataDoGlobalHarianSource extends DataGridSource {
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
    'Bekasi'
  ];

  int index = 0;

  DataDoGlobalHarianSource(
      {required List<DoGlobalHarianModel> doGlobalHarian}) {
    doGlobalHarianModel = validPlants.asMap().entries.map<DataGridRow>((entry) {
      int i = entry.key;
      int plant = entry.value;

      DoGlobalHarianModel? dataGridRow = doGlobalHarian.firstWhere(
          (item) => item.plant == plant.toString(),
          orElse: () => DoGlobalHarianModel(
              idPlant: plant,
              tujuan: validTujuans[i],
              tgl: '',
              jam: '',
              srd: 0,
              mks: 0,
              ptk: 0,
              bjm: 0,
              jumlah5: 0,
              jumlah6: 0,
              user: '',
              plant: plant.toString()));

      index++;
      final jumlah =
          dataGridRow.srd + dataGridRow.mks + dataGridRow.ptk + dataGridRow.bjm;

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Plant', value: dataGridRow.plant),
        DataGridCell<String>(columnName: 'Tujuan', value: dataGridRow.tujuan),
        DataGridCell<String>(
            columnName: 'Jumlah', value: jumlah == 0 ? '-' : jumlah.toString()),
        DataGridCell<String>(
            columnName: 'HSO - SRD',
            value: dataGridRow.srd == 0 ? '-' : dataGridRow.srd.toString()),
        DataGridCell<String>(
            columnName: 'HSO - MKS',
            value: dataGridRow.mks == 0 ? '-' : dataGridRow.mks.toString()),
        DataGridCell<String>(
            columnName: 'HSO - PTK',
            value: dataGridRow.ptk == 0 ? '-' : dataGridRow.ptk.toString()),
        DataGridCell<String>(
            columnName: 'BJM',
            value: dataGridRow.bjm == 0 ? '-' : dataGridRow.bjm.toString()),
      ]);
    }).toList();

    final totalJumlah = doGlobalHarian.fold(
        0, (sum, item) => sum + item.srd + item.mks + item.ptk + item.bjm);
    final totalSrd = doGlobalHarian.fold(0, (sum, item) => sum + item.srd);
    final totalMks = doGlobalHarian.fold(0, (sum, item) => sum + item.mks);
    final totalPtk = doGlobalHarian.fold(0, (sum, item) => sum + item.ptk);
    final totalBjm = doGlobalHarian.fold(0, (sum, item) => sum + item.bjm);

    // Add total row
    doGlobalHarianModel.add(DataGridRow(cells: [
      const DataGridCell<int>(columnName: 'No', value: null),
      const DataGridCell<String>(columnName: 'Plant', value: 'TOTAL'),
      const DataGridCell<String>(columnName: 'Tujuan', value: null),
      DataGridCell<String>(
          columnName: 'Jumlah',
          value: totalJumlah == 0 ? '-' : totalJumlah.toString()),
      DataGridCell<String>(
          columnName: 'HSO - SRD',
          value: totalSrd == 0 ? '-' : totalSrd.toString()),
      DataGridCell<String>(
          columnName: 'HSO - MKS',
          value: totalMks == 0 ? '-' : totalMks.toString()),
      DataGridCell<String>(
          columnName: 'HSO - PTK',
          value: totalPtk == 0 ? '-' : totalPtk.toString()),
      DataGridCell<String>(
          columnName: 'BJM', value: totalBjm == 0 ? '-' : totalBjm.toString()),
    ]));
  }

  List<DataGridRow> doGlobalHarianModel = [];

  @override
  List<DataGridRow> get rows => doGlobalHarianModel;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = doGlobalHarianModel.indexOf(row);
    bool isTotalRow = rowIndex == doGlobalHarianModel.length - 1;

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((e) {
        Color cellColor = Colors.transparent;

        if (isTotalRow && e.columnName == 'Jumlah') {
          cellColor = Colors.blue;
        } else if (isTotalRow &&
            (e.columnName == 'HSO - SRD' ||
                e.columnName == 'HSO - MKS' ||
                e.columnName == 'HSO - PTK' ||
                e.columnName == 'BJM')) {
          cellColor = Colors.yellow;
        } else if (e.columnName == 'Jumlah') {
          cellColor = AppColors.secondary;
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          color: cellColor,
          child: Text(
            e.value?.toString() ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
          ),
        );
      }).toList(),
    );
  }
}
