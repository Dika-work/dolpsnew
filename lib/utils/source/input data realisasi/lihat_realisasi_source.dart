import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/input data realisasi/do_realisasi_model.dart';

class LihatRealisasiSource extends DataGridSource {
  final List<DoRealisasiModel> doRealisasiModel;

  LihatRealisasiSource({
    required this.doRealisasiModel,
  }) {
    _updateDataPager(doRealisasiModel);
  }

  List<DataGridRow> _lihatRealisasi = [];

  @override
  List<DataGridRow> get rows => _lihatRealisasi;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _lihatRealisasi.indexOf(row);
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
    if (doRealisasiModel.isEmpty) {
      _lihatRealisasi = _generateEmptyRows(1);
    } else {
      _lihatRealisasi = doRealisasiModel.take(5).map<DataGridRow>(
        (e) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'HLM', value: e.hutangHelm),
            DataGridCell<String>(columnName: 'AC', value: e.hutangAc),
            DataGridCell<String>(columnName: 'KS', value: e.hutangKs),
            DataGridCell<String>(columnName: 'TS', value: e.hutangTs),
            DataGridCell<String>(columnName: 'BP', value: e.hutangBp),
            DataGridCell<String>(columnName: 'BS', value: e.hutangBs),
            DataGridCell<String>(columnName: 'PLT', value: e.hutangPlt),
            DataGridCell<String>(columnName: 'STAY L/R', value: e.hutangStay),
            DataGridCell<String>(columnName: 'AC BESAR', value: e.hutangAcBesar),
            DataGridCell<String>(columnName: 'PLASTIK', value: e.hutangPlastik),
          ]);
        },
      ).toList();
    }
  }
  
  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(doRealisasiModel);
    notifyListeners();
    return true;
  }
}
