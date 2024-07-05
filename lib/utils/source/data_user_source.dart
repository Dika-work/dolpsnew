import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';

class DataUserDataSource extends DataTableSource {
  final DataUserController controller;
  final BuildContext context;
  final void Function(DataUserModel) onEdit;
  final void Function()? onDelete;

  DataUserDataSource(this.controller, this.context,
      {required this.onEdit, this.onDelete});

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
            onPressed: () => onEdit(user),
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                CustomDialogs.deleteDialog(
                    context: context, onConfirm: onDelete);
              }),
        ],
      )),
    ]);
  }

  Widget _customCell(int index, String text) {
    bool isEven = index % 2 == 0;
    return Container(
      color: isEven ? Colors.grey[200] : Colors.white,
      padding: const EdgeInsets.all(CustomSize.sm),
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
