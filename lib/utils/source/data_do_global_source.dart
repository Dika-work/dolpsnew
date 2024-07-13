import 'package:doplsnew/controllers/input%20data%20do/do_global_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/do_global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../constant/custom_size.dart';

class DataDoGlobalSource extends DataGridSource {
  DataDoGlobalSource(
      {required List<DoGlobalModel> doGlobal, int startIndex = 0}) {
    _updateDataPager(doGlobal, startIndex);
  }

  List<DataGridRow> _doGlobalData = [];
  final controller = Get.put(DataDOGlobalController());
  int startIndex = 0;
  int index = 0;

  @override
  List<DataGridRow> get rows => _doGlobalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doGlobalData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((e) {
        return Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _updateDataPager(List<DoGlobalModel> doGlobal, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _doGlobalData = doGlobal.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(controller.doGlobalModel, startIndex);
    notifyListeners();
    return true;
  }
}
