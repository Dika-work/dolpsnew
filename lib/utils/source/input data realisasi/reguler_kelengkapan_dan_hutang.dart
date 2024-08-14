import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';

class RegulerHutangSource extends DataGridSource {
  final List<DoRealisasiModel> doRealisasiModel;

  RegulerHutangSource({required this.doRealisasiModel});

  List<DataGridRow> _kelengkapanHutang = [];
  final controller = Get.put(DoRegulerController());

  @override
  List<DataGridRow> get rows => _kelengkapanHutang;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _kelengkapanHutang.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: row.getCells().map<Widget>(
          (e) {
            return Text(
              e.value.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ).toList());
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'HLM', value: '-'),
        DataGridCell<String>(columnName: 'AC', value: '-'),
        DataGridCell<String>(columnName: 'KS', value: '-'),
        DataGridCell<String>(columnName: 'TS', value: '-'),
        DataGridCell<String>(columnName: 'BP', value: '-'),
        DataGridCell<String>(columnName: 'BS', value: '-'),
        DataGridCell<String>(columnName: 'PLT', value: '-'),
        DataGridCell<String>(columnName: 'STAY L/R', value: '-'),
        DataGridCell<String>(columnName: 'AC BESAR', value: '-'),
        DataGridCell<String>(columnName: 'PLASTIK', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<DoRealisasiModel> doRealisasiModel) {
    if (doRealisasiModel.first.totalHutang == 0) {
      _kelengkapanHutang = _generateEmptyRows(1);
    } else {
      _kelengkapanHutang = doRealisasiModel.take(1).map<DataGridRow>(
        (e) {
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'HLM', value: e.hutangHelm),
            DataGridCell<int>(columnName: 'AC', value: e.hutangAc),
            DataGridCell<int>(columnName: 'KS', value: e.hutangKs),
            DataGridCell<int>(columnName: 'TS', value: e.hutangTs),
            DataGridCell<int>(columnName: 'BP', value: e.hutangBp),
            DataGridCell<int>(columnName: 'BS', value: e.hutangBs),
            DataGridCell<int>(columnName: 'PLT', value: e.hutangPlt),
            DataGridCell<int>(columnName: 'STAY L/R', value: e.hutangStay),
            DataGridCell<int>(
                columnName: 'AC BESAR', value: e.hutangAcBesar),
            DataGridCell<int>(columnName: 'PLASTIK', value: e.hutangPlastik),
          ]);
        },
      ).toList();
    }
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.doRealisasiModel);
    notifyListeners();
    return true;
  }
}
