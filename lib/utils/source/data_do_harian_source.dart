import 'package:doplsnew/controllers/input%20data%20do/do_harian_controller.dart';
import 'package:doplsnew/models/do_harian_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataDoHarianSource extends DataGridSource {
  DataDoHarianSource(
      {required List<DoHarianModel> doHarian, int startIndex = 0}) {
    _updateDataPager(doHarian, startIndex);
  }

  List<DataGridRow> _doHarianData = [];
  final controller = Get.put(DataDoHarianController());
  int startIndex = 0;
  int index = 0;

  @override
  List<DataGridRow> get rows => _doHarianData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doHarianData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((e) {
        return Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              e.value.toString(),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _updateDataPager(List<DoHarianModel> doHarian, int startIndex) {
    this.startIndex = startIndex; // Set the startIndex for the current page
    index = startIndex; // Set the index to start from the correct page
    _doHarianData = doHarian.skip(startIndex).take(7).map<DataGridRow>((data) {
      index++;
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Plant', value: data.plant),
        DataGridCell<String>(columnName: 'Tujuan', value: data.tujuan),
        DataGridCell<String>(columnName: 'Tanggal', value: data.tgl),
        DataGridCell<String>(columnName: 'Jam', value: data.jam),
        DataGridCell<int>(columnName: 'HSO - SRD', value: data.srd),
        DataGridCell<int>(columnName: 'HSO - MKS', value: data.mks),
        DataGridCell<int>(columnName: 'HSO - PTK', value: data.ptk),
        DataGridCell<int>(columnName: 'BJM', value: data.bjm),
        DataGridCell<int>(columnName: 'Jumlah 5', value: data.jumlah5),
        DataGridCell<int>(columnName: 'Jumlah 6', value: data.jumlah6),
        DataGridCell<String>(columnName: 'User', value: data.user),
      ]);
    }).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 7;
    _updateDataPager(controller.doHarianModel, startIndex);
    notifyListeners();
    return true;
  }
}
