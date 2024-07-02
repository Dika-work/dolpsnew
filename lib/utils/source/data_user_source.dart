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
    print('ini data usernya : $user');
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.username)),
      DataCell(Text(user.nama)),
      DataCell(Text(user.tipe)),
      DataCell(Text(user.app)),
      DataCell(Text(user.lihat.toString())),
      DataCell(Text(user.print.toString())),
      DataCell(Text(user.tambah.toString())),
      DataCell(Text(user.edit.toString())),
      DataCell(Text(user.hapus.toString())),
      DataCell(Text(user.jumlah.toString())),
      DataCell(Text(user.kirim.toString())),
      DataCell(Text(user.batal.toString())),
      DataCell(Text(user.cekUnit.toString())),
      DataCell(Text(user.wilayah.toString())),
      DataCell(Text(user.plant)),
      DataCell(Text(user.cekReguler.toString())),
      DataCell(Text(user.cekMutasi.toString())),
      DataCell(Text(user.acc1.toString())),
      DataCell(Text(user.acc2.toString())),
      DataCell(Text(user.acc3.toString())),
      DataCell(Text(user.menu1.toString())),
      DataCell(Text(user.menu2.toString())),
      DataCell(Text(user.menu3.toString())),
      DataCell(Text(user.menu4.toString())),
      DataCell(Text(user.menu5.toString())),
      DataCell(Text(user.menu6.toString())),
      DataCell(Text(user.menu7.toString())),
      DataCell(Text(user.menu8.toString())),
      DataCell(Text(user.menu9.toString())),
      DataCell(Text(user.menu10.toString())),
      DataCell(Text(user.gambar.toString())),
      DataCell(Text(user.online.toString())),
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.dataUserModel.length;

  @override
  int get selectedRowCount => 0;
}
