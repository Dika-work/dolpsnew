import 'package:doplsnew/models/do_harian_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataDoHarianSource extends DataGridSource {
  DataDoHarianSource({required List<DoHarianModel> doHarian}) {
    int index = 0;
    _doHarianData = doHarian.map((e) {
      index++;
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Plant', value: e.plant),
        DataGridCell<String>(columnName: 'Tujuan', value: e.tujuan),
        DataGridCell<String>(columnName: 'Tanggal', value: e.tgl),
        DataGridCell<String>(columnName: 'Jam', value: e.jam),
        DataGridCell<int>(columnName: 'HSO - SRD', value: e.srd),
        DataGridCell<int>(columnName: 'HSO - MKS', value: e.mks),
        DataGridCell<int>(columnName: 'HSO - PTK', value: e.ptk),
        DataGridCell<int>(columnName: 'BJM', value: e.bjm),
        DataGridCell<int>(columnName: 'Jumlah 5', value: e.jumlah5),
        DataGridCell<int>(columnName: 'Jumlah 6', value: e.jumlah6),
        DataGridCell<String>(columnName: 'User', value: e.user),
      ]);
    }).toList();
  }
  List<DataGridRow> _doHarianData = [];

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
            child: Text(
              e.value.toString(),
            ),
          );
        }).toList());
  }
}
