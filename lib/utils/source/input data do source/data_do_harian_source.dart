import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data do/do_harian_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data do/do_harian_model.dart';
import '../../constant/custom_size.dart';

class DataDoHarianSource extends DataGridSource {
  final void Function(DoHarianModel)? onEdited;
  final void Function(DoHarianModel)? onDeleted;
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
  final controller = Get.put(DataDoHarianController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doHarianData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doHarianData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = [
      ...row.getCells().take(8).map<Widget>(
        (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: CustomSize.fontSizeXm),
            ),
          );
        },
      ),
    ];

    // Action cells (edit and delete)
    if (controller.rolesEdit == 1) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (onEdited != null && doHarian.isNotEmpty) {
                    onEdited!(doHarian[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Iconsax.grid_edit,
                ))
          ],
        ),
      );
    }

    // Hapus
    if (controller.rolesHapus == 1) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (onDeleted != null && doHarian.isNotEmpty) {
                    onDeleted!(doHarian[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Iconsax.trash,
                  color: Colors.red,
                ))
          ],
        ),
      );
    }

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  void _updateDataPager(List<DoHarianModel> doHarian, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _doHarianData = doHarian.skip(startIndex).take(7).map<DataGridRow>((data) {
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
    _updateDataPager(controller.doHarianModel, startIndex);
    notifyListeners();
    return true;
  }
}
