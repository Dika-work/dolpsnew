import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/tampil seluruh data/do_harian_all_lps.dart';
import '../../constant/custom_size.dart';

class DataAllHarianLpsSource extends DataGridSource {
  final void Function(DoHarianAllLpsModel)? onEdited;
  final void Function()? onDeleted;
  final List<DoHarianAllLpsModel> allGlobal;
  int startIndex = 0;

  DataAllHarianLpsSource({
    required this.onEdited,
    required this.onDeleted,
    required this.allGlobal,
    int startIndex = 0,
  }) {
    _updateDataPager(allGlobal, startIndex);
  }

  List<DataGridRow> _allGlobalData = [];

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
            if (onEdited != null) {
              onEdited!(allGlobal[startIndex + rowIndex]);
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

  void _updateDataPager(List<DoHarianAllLpsModel> allGlobal, int startIndex) {
    this.startIndex = startIndex;
    _allGlobalData =
        allGlobal.skip(startIndex).take(7).map<DataGridRow>((data) {
      final tglParsed =
          CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: data.id),
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
