import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/tampil seluruh data/all_harian_lps_controller.dart';
import '../../../models/tampil seluruh data/do_harian_all_lps.dart';
import '../../constant/custom_size.dart';

class DataAllHarianLpsSource extends DataGridSource {
  final void Function(DoHarianAllLpsModel)? onEdited;
  final void Function(DoHarianAllLpsModel)? onDeleted;
  final List<DoHarianAllLpsModel> allGlobal;

  DataAllHarianLpsSource({
    required this.onEdited,
    required this.onDeleted,
    required this.allGlobal,
  }) {
    _updateDataPager(allGlobal);
  }

  List<DataGridRow> _allGlobalData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => _allGlobalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _allGlobalData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    final controller = Get.find<DataAllHarianLpsController>();

    List<Widget> cells = [
      ...row.getCells().take(8).map<Widget>(
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
      )
    ];

    if (controller.rolesEdit == 1) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (onEdited != null && allGlobal.isNotEmpty) {
                    onEdited!(allGlobal[rowIndex]);
                  } else {
                    return;
                  }
                },
                icon: const Icon(Iconsax.grid_edit))
          ],
        ),
      );
    }

    if (controller.rolesHapus == 1) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onDeleted != null && allGlobal.isNotEmpty) {
                  onDeleted!(allGlobal[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.trash, color: Colors.red))
        ],
      ));
    }

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  void _updateDataPager(List<DoHarianAllLpsModel> allGlobal) {
    _allGlobalData = allGlobal.map<DataGridRow>((data) {
      index++;
      final tglParsed =
          CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
      return DataGridRow(cells: [
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
      ]);
    }).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(allGlobal);
    notifyListeners();
    return true;
  }
}
