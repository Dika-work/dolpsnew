import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/tampil%20seluruh%20data/do_tambah_all.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constant/custom_size.dart';

class DataAllTambahSource extends DataGridSource {
  final void Function(DoTambahAllModel)? onEdited;
  final void Function()? onDeleted;
  final List<DoTambahAllModel> allGlobal;
  int startIndex = 0;

  DataAllTambahSource({
    required this.onEdited,
    required this.onDeleted,
    required this.allGlobal,
    int startIndex = 0,
  }) {
    _updateDataPager(allGlobal, startIndex);
  }

  List<DataGridRow> _allGlobalData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => _allGlobalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _allGlobalData.indexOf(row);
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
        }).toList(),
        // Action cells (edit and delete)
        IconButton(
          icon: const Icon(Iconsax.edit),
          onPressed: () {
            if (onEdited != null && allGlobal.isNotEmpty) {
              onEdited!(allGlobal[startIndex + rowIndex]);
            } else {
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Iconsax.trash),
          onPressed: onDeleted,
        ),
      ],
    );
  }

  void _updateDataPager(List<DoTambahAllModel> allGlobal, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _allGlobalData =
        allGlobal.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(allGlobal, startIndex);
    notifyListeners();
    return true;
  }
}
