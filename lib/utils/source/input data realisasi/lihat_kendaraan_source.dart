import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/lihat_kendaraan_controller.dart';
import '../../../models/input data realisasi/lihat_kendaraan_model.dart';

class LihatKendaraanSource extends DataGridSource {
  final List<LihatKendaraanModel> lihatKendaraanModel;
  int startIndex = 0;

  LihatKendaraanSource({
    required this.lihatKendaraanModel,
    int startIndex = 0,
  }) {
    _updateDataPager(lihatKendaraanModel, startIndex);
  }

  List<DataGridRow> _lihatKendaraan = [];
  final controller = Get.put(LihatKendaraanController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _lihatKendaraan;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _lihatKendaraan.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: row.getCells().map<Widget>(
          (e) {
            return Center(
              child: Text(
                e.value.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList());
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Supir', value: '-'),
        DataGridCell<String>(columnName: 'No Kendaraan', value: '-'),
        DataGridCell<String>(columnName: 'Jenis', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<LihatKendaraanModel> kirimKendaraanModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (kirimKendaraanModel.isEmpty) {
      _lihatKendaraan = _generateEmptyRows(1);
    } else {
      _lihatKendaraan =
          kirimKendaraanModel.skip(startIndex).take(10).map<DataGridRow>(
        (data) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Supir', value: data.supir),
            DataGridCell<String>(
                columnName: 'No Kendaraan', value: data.noPolisi),
            DataGridCell<String>(columnName: 'Jenis', value: data.jenisKen),
          ]);
        },
      ).toList();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.lihatModel, startIndex);
    notifyListeners();
    return true;
  }
}
