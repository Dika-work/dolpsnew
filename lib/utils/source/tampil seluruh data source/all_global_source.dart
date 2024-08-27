import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/tampil seluruh data/all_global_controller.dart';
import '../../../models/tampil seluruh data/do_global_all.dart';
import '../../constant/custom_size.dart';

class DataAllGlobalSource extends DataGridSource {
  final void Function(DoGlobalAllModel)? onEdited;
  final void Function()? onDeleted;
  final List<DoGlobalAllModel> allGlobal;
  int startIndex = 0;

  DataAllGlobalSource({
    required this.onEdited,
    required this.onDeleted,
    required this.allGlobal,
    int startIndex = 0,
  }) {
    _updateDataPager(allGlobal, startIndex);
  }

  List<DataGridRow> _allGlobalData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => _allGlobalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _allGlobalData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    var request = allGlobal[startIndex + rowIndex];
    final controller = Get.find<DataAllGlobalController>();

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
            SizedBox(
              height: 60,
              width: 100,
              child: ElevatedButton(
                  onPressed: () {
                    if (onEdited != null && allGlobal.isNotEmpty) {
                      onEdited!(request);
                    } else {
                      return;
                    }
                  },
                  child: const Text('Edit')),
            )
          ],
        ),
      );
    }

    if (controller.rolesHapus == 1) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 60,
              width: 100,
              child: ElevatedButton(
                  onPressed: onDeleted, child: const Text('Hapus')))
        ],
      ));
    }

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  void _updateDataPager(List<DoGlobalAllModel> allGlobal, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    _allGlobalData =
        allGlobal.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    final int startIndex = newPageIndex * 7;
    _updateDataPager(allGlobal, startIndex);
    notifyListeners();
    return true;
  }
}
