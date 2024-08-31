import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/home/do_harian_home_controller.dart';
import '../../../models/home/do_harian_home.dart';
import '../../theme/app_colors.dart';

class DataDoHarianHomeSource extends DataGridSource {
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
  List<DataGridRow> doGlobalHarianModel = [];

  DataDoHarianHomeSource({
    required List<DoHarianHomeModel> doGlobalHarian,
    required String userPlant,
    required bool isAdmin,
  }) {
    final controller = Get.put(DataDOHarianHomeController());
    // Filter plants berdasarkan role user
    final filteredPlants = isAdmin
        ? validPlants // Jika admin, tampilkan semua plant
        : validPlants
            .where((plant) => plant.toString() == userPlant)
            .toList(); // Filter plant berdasarkan user

    print('Filtered Plants Hari ini: $filteredPlants');
    print('User Plant Hari ini: $userPlant');

    // Membuat model data dengan urutan validPlants
    doGlobalHarianModel = filteredPlants.map<DataGridRow>((plant) {
      // Cari data untuk plant saat ini atau buat placeholder default
      DoHarianHomeModel data = doGlobalHarian.firstWhere(
        (item) => item.plant == plant.toString(),
        orElse: () => DoHarianHomeModel(
          idPlant: plant,
          tujuan: validTujuans[validPlants.indexOf(plant)],
          tgl: '',
          jam: '',
          jumlah: 0,
          srd: 0,
          mks: 0,
          ptk: 0,
          bjm: 0,
          plant: plant.toString(),
        ),
      );

      // Hitung jumlah total
      final jumlah = data.srd + data.mks + data.ptk + data.bjm;

      index++;
      // Buat list untuk menyimpan cells
      List<DataGridCell> cells = [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Plant', value: data.plant),
        DataGridCell<String>(columnName: 'Tujuan', value: data.tujuan),
        DataGridCell<String>(
            columnName: 'Jml', value: jumlah == 0 ? '-' : jumlah.toString())
      ];

      // Tambahkan kolom berdasarkan nilai `daerah`
      if (controller.daerah == 0 || controller.daerah == 3) {
        cells.add(DataGridCell<String>(
            columnName: 'SRD',
            value: data.srd == 0 ? '-' : data.srd.toString()));
      }
      if (controller.daerah == 0 || controller.daerah == 1) {
        cells.add(DataGridCell<String>(
            columnName: 'MKS',
            value: data.mks == 0 ? '-' : data.mks.toString()));
      }
      if (controller.daerah == 0 || controller.daerah == 4) {
        cells.add(DataGridCell<String>(
            columnName: 'PTK',
            value: data.ptk == 0 ? '-' : data.ptk.toString()));
      }
      if (controller.daerah == 0 || controller.daerah == 2) {
        cells.add(DataGridCell<String>(
            columnName: 'BJM',
            value: data.bjm == 0 ? '-' : data.bjm.toString()));
      }

      return DataGridRow(cells: cells);
    }).toList();

    // Menghitung total hanya jika plant yang sesuai ada dalam data
    final totalJumlah = doGlobalHarian.fold(
        0, (sum, item) => sum + item.srd + item.mks + item.ptk + item.bjm);
    final totalSrd = doGlobalHarian.fold(0, (sum, item) => sum + item.srd);
    final totalMks = doGlobalHarian.fold(0, (sum, item) => sum + item.mks);
    final totalPtk = doGlobalHarian.fold(0, (sum, item) => sum + item.ptk);
    final totalBjm = doGlobalHarian.fold(0, (sum, item) => sum + item.bjm);

    // Tambahkan baris total
    List<DataGridCell> totalCells = [
      const DataGridCell<int>(columnName: 'No', value: null),
      const DataGridCell<String>(columnName: 'Plant', value: 'TOTAL'),
      const DataGridCell<String>(columnName: 'Tujuan', value: null),
      DataGridCell<String>(
          columnName: 'Jml',
          value: totalJumlah == 0 ? '-' : totalJumlah.toString()),
    ];

    if (controller.daerah == 0 || controller.daerah == 3) {
      totalCells.add(DataGridCell<String>(
          columnName: 'SRD', value: totalSrd == 0 ? '-' : totalSrd.toString()));
    }
    if (controller.daerah == 0 || controller.daerah == 1) {
      totalCells.add(DataGridCell<String>(
          columnName: 'MKS', value: totalMks == 0 ? '-' : totalMks.toString()));
    }
    if (controller.daerah == 0 || controller.daerah == 4) {
      totalCells.add(DataGridCell<String>(
          columnName: 'PTK', value: totalPtk == 0 ? '-' : totalPtk.toString()));
    }
    if (controller.daerah == 0 || controller.daerah == 2) {
      totalCells.add(DataGridCell<String>(
          columnName: 'BJM', value: totalBjm == 0 ? '-' : totalBjm.toString()));
    }

    doGlobalHarianModel.add(DataGridRow(cells: totalCells));

    print('Final DataGridRow hari ini count: ${doGlobalHarianModel.length}');
  }

  @override
  List<DataGridRow> get rows => doGlobalHarianModel;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = doGlobalHarianModel.indexOf(row);
    bool isTotalRow = rowIndex == doGlobalHarianModel.length - 1;

    List<Widget> cells = row.getCells().map<Widget>((e) {
      Color cellColor = Colors.transparent;

      if (isTotalRow && e.columnName == 'Jml') {
        cellColor = Colors.blue;
      } else if (isTotalRow &&
          (e.columnName == 'SRD' ||
              e.columnName == 'MKS' ||
              e.columnName == 'PTK' ||
              e.columnName == 'BJM')) {
        cellColor = Colors.yellow;
      } else if (e.columnName == 'Jml') {
        cellColor = AppColors.secondary;
      }

      return Container(
        alignment: Alignment.center,
        color: cellColor,
        child: Text(
          e.value?.toString() ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }).toList();

    print('Jumlah cells :${cells.length}');

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }
}
