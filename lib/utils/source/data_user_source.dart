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
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.username)),
      DataCell(Text(user.nama)),
      DataCell(Text(user.tipe)),
      DataCell(Text(user.app)),
      DataCell(Text(user.lihat)),
      DataCell(Text(user.print)),
      DataCell(Text(user.tambah)),
      DataCell(Text(user.edit)),
      DataCell(Text(user.hapus)),
      DataCell(Text(user.jumlah)),
      DataCell(Text(user.kirim)),
      DataCell(Text(user.batal)),
      DataCell(Text(user.cekUnit)),
      DataCell(Text(user.wilayah)),
      DataCell(Text(user.plant)),
      DataCell(Text(user.cekReguler)),
      DataCell(Text(user.cekMutasi)),
      DataCell(Text(user.acc1)),
      DataCell(Text(user.acc2)),
      DataCell(Text(user.acc3)),
      DataCell(Text(user.menu1)),
      DataCell(Text(user.menu2)),
      DataCell(Text(user.menu3)),
      DataCell(Text(user.menu4)),
      DataCell(Text(user.menu5)),
      DataCell(Text(user.menu6)),
      DataCell(Text(user.menu7)),
      DataCell(Text(user.menu8)),
      DataCell(Text(user.menu9)),
      DataCell(Text(user.menu10)),
      DataCell(Text(user.gambar)),
      DataCell(Text(user.online)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                CustomDialogs.defaultDialog(context: context);
              }),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.dataUserModel.length;

  @override
  int get selectedRowCount => 0;
}
