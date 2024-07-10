import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../widgets/dropdown.dart';

class DataUserDataSource extends DataGridSource {
  DataUserDataSource({
    required this.dataUser,
  }) {
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

  final List<DataUserModel> dataUser;
  final controller = Get.put(DataUserController());
  List<DataGridRow> _dataUsers = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = _dataUsers.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    DataUserModel currentUser = dataUser[dataRowIndex];

    // Log the current user data for debugging
    print(
        'Editing user: ${currentUser.username}, column: ${column.columnName}, newValue: $newCellValue');

    // Check for null values
    if (currentUser.username.isEmpty ||
        currentUser.password.isEmpty ||
        currentUser.nama.isEmpty ||
        currentUser.tipe.isEmpty ||
        currentUser.wilayah.isEmpty ||
        currentUser.plant.isEmpty ||
        currentUser.dealer.isEmpty) {
      print('Null value found in user data');
      return;
    }

    // Prevent editing of 'Username' and 'Gambar'
    if (column.columnName == 'Username' || column.columnName == 'Gambar') {
      print('Editing of ${column.columnName} is not allowed');
      return;
    }

    if (column.columnName == 'Nama') {
      _dataUsers[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Nama', value: newCellValue);
      await controller.editUserData(
        currentUser.username,
        currentUser.password,
        newCellValue.toString(),
        currentUser.tipe,
        currentUser.wilayah,
        currentUser.plant,
        currentUser.dealer,
      );
    } else if (column.columnName == 'Tipe') {
      _dataUsers[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Tipe', value: newCellValue);
      await controller.editUserData(
        currentUser.username,
        currentUser.password,
        currentUser.nama,
        newCellValue.toString(),
        currentUser.wilayah,
        currentUser.plant,
        currentUser.dealer,
      );
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    newCellValue = displayText; // Initialize with current value

    if (column.columnName == 'Username' || column.columnName == 'Gambar') {
      // Return null for 'Username' and 'Gambar' columns
      return null;
    } else if (column.columnName == 'Nama') {
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: TextField(
          autofocus: true,
          controller: editingController..text = displayText,
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          ),
          keyboardType: TextInputType.text,
          onChanged: (String value) {
            if (value.isNotEmpty) {
              newCellValue = value;
            } else {
              newCellValue = displayText;
            }
          },
          onSubmitted: (String value) {
            submitCell();
          },
        ),
      );
    } else if (column.columnName == 'Tipe') {
      // Return dropdown widget for 'Tipe' column
      return DropDownWidget(
        value: newCellValue ?? displayText,
        items: const [
          'admin',
          'Pengurus Pabrik',
          'KOL',
          'Pengurus Stuffing',
          'k.pool',
          'security',
          'Staff',
        ],
        onChanged: (String? value) {
          newCellValue = value;
          print('ini tipenya : $newCellValue');
          submitCell();
        },
      );
    } else {
      // Return text field for other columns
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: TextField(
          autofocus: true,
          controller: editingController..text = displayText,
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          ),
          keyboardType: TextInputType.text,
          onChanged: (String value) {
            if (value.isNotEmpty) {
              newCellValue = value;
            } else {
              newCellValue = displayText;
            }
          },
          onSubmitted: (String value) {
            submitCell();
          },
        ),
      );
    }
  }
}
