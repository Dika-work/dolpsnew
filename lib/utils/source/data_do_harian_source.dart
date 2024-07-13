import 'package:doplsnew/models/do_harian_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../helpers/helper_function.dart';
import '../constant/custom_size.dart';

class DataDoHarianSource extends DataGridSource {
  final void Function(DoHarianModel)? onEdited;
  final void Function()? onDeleted;
  final List<DoHarianModel> doHarian;
  int startIndex = 0;

  DataDoHarianSource({
    required this.onEdited,
    required this.onDeleted,
    required this.doHarian,
    int startIndex = 0,
  }) {
    _updateDataPager(doHarian, startIndex);
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
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Iconsax.edit),
                onPressed: () {
                  if (onEdited != null) {
                    onEdited!(doHarian[rowIndex]);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Iconsax.trash),
                onPressed: onDeleted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateDataPager(List<DoHarianModel> doHarian, int startIndex) {
    this.startIndex = startIndex;
    _doHarianData = doHarian.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(doHarian, startIndex);
    notifyListeners();
    return true;
  }
}
