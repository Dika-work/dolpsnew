import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../helpers/helper_function.dart';
import '../../../models/tampil seluruh data/do_estimasi_all.dart';
import '../../constant/custom_size.dart';

class AllEstimasiSource extends DataGridSource {
  final void Function(DoEstimasiAllModel)? onEdited;
  final void Function(DoEstimasiAllModel)? onDeleted;
  final List<DoEstimasiAllModel> doEstimasi;
  int startIndex = 0;

  AllEstimasiSource(
      {required this.onEdited,
      required this.onDeleted,
      required this.doEstimasi,
      int startIndex = 0}) {
    _updateDataPager(doEstimasi, startIndex);
  }

  List<DataGridRow> _doEstimasiData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => _doEstimasiData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doEstimasiData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    // Tambahkan pengecekan apakah list doEstimasi kosong
    if (doEstimasi.isNotEmpty) {
      var request = doEstimasi[startIndex + rowIndex];

      return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: [
          ...row.getCells().take(7).map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
              child: Text(
                e.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: CustomSize.fontSizeXm),
              ),
            );
          }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (onEdited != null && doEstimasi.isNotEmpty) {
                    onEdited!(request);
                  }
                },
                icon: const Icon(Iconsax.grid_edit),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (onDeleted != null && doEstimasi.isNotEmpty) {
                    onDeleted!(request);
                  }
                },
                icon: const Icon(Iconsax.trash, color: Colors.red),
              ),
            ],
          ),
        ],
      );
    } else {
      return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      );
    }
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(
      count,
      (index) {
        return const DataGridRow(cells: [
          DataGridCell<String>(columnName: 'No', value: '-'),
          DataGridCell<String>(columnName: 'Tanggal', value: '-'),
          DataGridCell<String>(columnName: 'HSO - SRD', value: '-'),
          DataGridCell<String>(columnName: 'HSO - MKS', value: '-'),
          DataGridCell<String>(columnName: 'HSO - PTK', value: '-'),
          DataGridCell<String>(columnName: 'Edit', value: ''),
          DataGridCell<String>(columnName: 'Hapus', value: ''),
        ]);
      },
    );
  }

  void _updateDataPager(List<DoEstimasiAllModel> allGlobal, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (allGlobal.isEmpty) {
      _doEstimasiData = _generateEmptyRows(1);
    } else {
      _doEstimasiData =
          allGlobal.skip(startIndex).take(7).map<DataGridRow>((data) {
        index++;
        final tglParsed =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Tanggal', value: tglParsed),
          DataGridCell<String>(
              columnName: 'HSO - SRD',
              value: data.jumlah1 == 0 ? '-' : data.jumlah1.toString()),
          DataGridCell<String>(
              columnName: 'HSO - MKS',
              value: data.jumlah2 == 0 ? '-' : data.jumlah2.toString()),
          DataGridCell<String>(
              columnName: 'HSO - PTK',
              value: data.jumlah3 == 0 ? '-' : data.jumlah3.toString()),
        ]);
      }).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 7;
    _updateDataPager(doEstimasi, startIndex);
    notifyListeners();
    return true;
  }
}
