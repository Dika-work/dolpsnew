import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';

class DataUserDataSource extends DataTableSource {
  final DataUserController controller;
  final BuildContext context;
  DataUserDataSource(this.controller, this.context);

  @override
  DataRow getRow(int index) {
    final user = controller.dataUserModel[index];
    String nomer = (index + 1).toString();
    return DataRow.byIndex(index: index, cells: [
      DataCell(_customCell(index, nomer)),
      DataCell(_customCell(index, user.username)),
      DataCell(_customCell(index, user.nama)),
      DataCell(_customCell(index, user.tipe)),
      DataCell(_customCell(index, user.gambar)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                CustomDialogs.deleteDialog(context: context);
              }),
        ],
      )),
    ]);
  }

  Widget _customCell(int index, String text) {
    bool isEven = index % 2 == 0;
    return Container(
      color: isEven ? Colors.grey[200] : Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.dataUserModel.length;

  @override
  int get selectedRowCount => 0;
}
