import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataUserDataSource extends DataGridSource {
  DataUserDataSource({required List<DataUserModel> dataUser}) {
    int index = 0;
    _dataUsers = dataUser.map((e) {
      index++;
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Username', value: e.username),
        DataGridCell<String>(columnName: 'Nama', value: e.nama),
        DataGridCell<String>(columnName: 'Tipe', value: e.tipe),
        DataGridCell<String>(columnName: 'Gambar', value: e.gambar),
      ]);
    }).toList();
  }

  List<DataGridRow> _dataUsers = [];

  @override
  List<DataGridRow> get rows => _dataUsers;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _dataUsers.indexOf(row);
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
