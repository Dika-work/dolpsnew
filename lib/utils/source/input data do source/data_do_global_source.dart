import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data do/do_global_controller.dart';
import '../../../models/input data do/do_global_model.dart';
import '../../constant/custom_size.dart';

class DataDoGlobalSource extends DataGridSource {
  final void Function(DoGlobalModel)? onEdited;
  final void Function(DoGlobalModel)? onDeleted;
  final List<DoGlobalModel> doGlobal;
  int startIndex = 0;

  DataDoGlobalSource({
    required this.onEdited,
    required this.onDeleted,
    required this.doGlobal,
    int startIndex = 0,
  }) {
    _updateDataPager(
        doGlobal, startIndex, controller.rolePlant, controller.isAdmin);
  }

  List<DataGridRow> _doGlobalData = [];
  final controller = Get.put(DataDOGlobalController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doGlobalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doGlobalData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = [
      ...row.getCells().take(8).map<Widget>(
        (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: CustomSize.fontSizeXm),
            ),
          );
        },
      ),
    ];

    // Action cells (edit and delete)
    if (controller.rolesEdit == 1) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (onEdited != null && doGlobal.isNotEmpty) {
                    onEdited!(doGlobal[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                icon: const Icon(Iconsax.grid_edit)),
          ],
        ),
      );
    }
    // Hapus
    if (controller.rolesHapus == 1) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (onDeleted != null && doGlobal.isNotEmpty) {
                    onDeleted!(doGlobal[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                icon: const Icon(Iconsax.trash, color: Colors.red))
          ],
        ),
      );
    }

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  void _updateDataPager(List<DoGlobalModel> doGlobal, int startIndex,
      String userPlant, bool isAdmin) {
    this.startIndex = startIndex;
    index = startIndex;

    final List<int> validPlants = [
      1100,
      1200,
      1300,
      1350,
      1700,
      1800,
      1900,
    ];

    final filteredPlants = isAdmin
        ? validPlants // Jika admin, tampilkan semua plant
        : validPlants.where((plant) => plant.toString() == userPlant).toList();

    _doGlobalData = doGlobal
        .where((item) => filteredPlants.contains(int.tryParse(item.plant) ?? 0))
        .skip(startIndex)
        .take(7)
        .map<DataGridRow>(
      (data) {
        index++;
        final tglParsed =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
        List<DataGridCell> cells = [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Plant', value: data.plant),
          DataGridCell<String>(columnName: 'Tujuan', value: data.tujuan),
          DataGridCell<String>(columnName: 'Tanggal', value: tglParsed),
          DataGridCell<String>(
              columnName: 'HSO - SRD',
              value: data.srd == 0 ? '-' : data.srd.toString()),
          DataGridCell<String>(
              columnName: 'HSO - MKS',
              value: data.mks == 0 ? '-' : data.mks.toString()),
          DataGridCell<String>(
              columnName: 'HSO - PTK',
              value: data.ptk == 0 ? '-' : data.ptk.toString()),
          DataGridCell<String>(
              columnName: 'BJM',
              value: data.bjm == 0 ? '-' : data.bjm.toString()),
        ];

        return DataGridRow(cells: cells);
      },
    ).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.doGlobalModel, newPageIndex,
        controller.rolePlant, controller.isAdmin);
    notifyListeners();
    return true;
  }
}
