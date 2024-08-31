import 'package:flutter/material.dart';
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
    var request = doEstimasi[startIndex + rowIndex];

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: [
          ...row.getCells().take(7).map<Widget>(
            (e) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
                child: Text(
                  e.value.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      if (onEdited != null && doEstimasi.isNotEmpty) {
                        onEdited!(request);
                      } else {
                        return;
                      }
                    },
                    child: const Text('Edit')),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 60,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        if (onDeleted != null && doEstimasi.isNotEmpty) {
                          onDeleted!(request);
                        } else {
                          return;
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Hapus')))
            ],
          )
        ]);
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
          DataGridCell<String>(columnName: 'HSO - MKS', value: '-'),
          DataGridCell<String>(columnName: 'HSO - PTK', value: '-'),
          DataGridCell<String>(columnName: 'BJM', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(List<DoEstimasiAllModel> allGlobal, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (doEstimasi.isEmpty) {
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
          DataGridCell<String>(
              columnName: 'BJM',
              value: data.jumlah4 == 0 ? '-' : data.jumlah4.toString()),
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
