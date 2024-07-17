import 'package:doplsnew/controllers/input%20data%20do/do_kurang_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/input%20data%20do/do_kurang_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../constant/custom_size.dart';

class DataDoKurangSource extends DataGridSource {
  final void Function(DoKurangModel)? onEdited;
  final void Function()? onDeleted;
  final List<DoKurangModel> doKurang;
  int startIndex = 0;
  DataDoKurangSource({
    required this.onEdited,
    required this.onDeleted,
    required this.doKurang,
    int startIndex = 0,
  }) {
    _updateDataPager(doKurang, startIndex);
  }

  List<DataGridRow> _doKurangData = [];
  final controller = Get.put(DataDOKurangController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doKurangData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doKurangData.indexOf(row);
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
            if (onEdited != null) {
              onEdited!(doKurang[startIndex + rowIndex]);
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

  void _updateDataPager(List<DoKurangModel> doKurang, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _doKurangData = doKurang.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(controller.doKurangModel, startIndex);
    notifyListeners();
    return true;
  }
}
