import 'package:doplsnew/controllers/input%20data%20do/do_tambah_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/input%20data%20do/do_tambah_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constant/custom_size.dart';

class DataDoTambahSource extends DataGridSource {
  final void Function(DoTambahModel)? onEdited;
  final void Function(DoTambahModel)? onDeleted;
  final List<DoTambahModel> doTambah;
  int startIndex = 0;

  DataDoTambahSource({
    required this.onEdited,
    required this.onDeleted,
    required this.doTambah,
    int startIndex = 0,
  }) {
    _updateDataPager(doTambah, startIndex);
  }

  List<DataGridRow> _doTambahData = [];
  final controller = Get.put(DataDoTambahanController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doTambahData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doTambahData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: [
        ...row.getCells().map<Widget>((e) {
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
        }),
        // Action cells (edit and delete)
        IconButton(
          icon: const Icon(Iconsax.edit),
          onPressed: () {
            if (onEdited != null && doTambah.isNotEmpty) {
              onEdited!(doTambah[startIndex + rowIndex]);
            } else {
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Iconsax.trash),
          onPressed: () {
            if (onDeleted != null && doTambah.isNotEmpty) {
              onDeleted!(doTambah[startIndex + rowIndex]);
            } else {
              return;
            }
          },
        ),
      ],
    );
  }

  void _updateDataPager(List<DoTambahModel> doTambah, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _doTambahData = doTambah.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(controller.doTambahModel, startIndex);
    notifyListeners();
    return true;
  }
}
