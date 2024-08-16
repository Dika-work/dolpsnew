import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/hutang_reguler_controller.dart';
import '../../../models/input data realisasi/hutang_reguler_model.dart';
import '../../constant/custom_size.dart';

class RegulerHutangSource extends DataGridSource {
  final List<HutangRegulerModel> doHutangModel;

  RegulerHutangSource({required this.doHutangModel}) {
    _updateDataPager(doHutangModel);
  }

  List<DataGridRow> _kelengkapanHutang = [];
  final controller = Get.put(HutangRegulerController());

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
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
              child: Text(
                e.value.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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

  void _updateDataPager(List<HutangRegulerModel> doHutangModel) {
    if (doHutangModel.isEmpty) {
      print('..MENAMPILKAN DATA MODEL HUTANG YANG KOSONG..');
      _kelengkapanHutang = _generateEmptyRows(1);
    } else {
      _kelengkapanHutang = doHutangModel.map<DataGridRow>(
        (e) {
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'HLM', value: e.hutangHLM),
            DataGridCell<int>(columnName: 'AC', value: e.hutangAc),
            DataGridCell<int>(columnName: 'KS', value: e.hutangKS),
            DataGridCell<int>(columnName: 'TS', value: e.hutangTS),
            DataGridCell<int>(columnName: 'BP', value: e.hutangBP),
            DataGridCell<int>(columnName: 'BS', value: e.hutangBS),
            DataGridCell<int>(columnName: 'PLT', value: e.hutangPLT),
            DataGridCell<int>(columnName: 'STAY L/R', value: e.hutangStay),
            DataGridCell<int>(columnName: 'AC BESAR', value: e.hutangAcBesar),
            DataGridCell<int>(columnName: 'PLASTIK', value: e.hutangPlastik),
          ]);
        },
      ).toList();
    }
    notifyListeners();
    print('DataGrid telah di-update dengan hutang negatif');
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.doHutang);
    notifyListeners();
    return true;
  }
}

class KelengkapanAlatSource extends DataGridSource {
  final List<AlatKelengkapanModel> alatModel;

  KelengkapanAlatSource({required this.alatModel}) {
    _updateDataPager(alatModel);
  }

  List<DataGridRow> _alatKelengkapan = [];
  final controller = Get.put(HutangRegulerController());

  @override
  List<DataGridRow> get rows => _alatKelengkapan;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _alatKelengkapan.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: row.getCells().map<Widget>(
          (e) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
              child: Text(
                e.value.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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

  void _updateDataPager(List<AlatKelengkapanModel> alatModel) {
    if (alatModel.isEmpty) {
      print('..MENAMPILKAN DATA MODEL HUTANG YANG KOSONG..');
      _alatKelengkapan = _generateEmptyRows(1);
    } else {
      _alatKelengkapan = alatModel.map<DataGridRow>((e) {
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'HLM', value: e.hlm),
          DataGridCell<int>(columnName: 'AC', value: e.ac),
          DataGridCell<int>(columnName: 'KS', value: e.ks),
          DataGridCell<int>(columnName: 'TS', value: e.ts),
          DataGridCell<int>(columnName: 'BP', value: e.bp),
          DataGridCell<int>(columnName: 'BS', value: e.bs),
          DataGridCell<int>(columnName: 'PLT', value: e.plt),
          DataGridCell<int>(columnName: 'STAY L/R', value: e.stay),
          DataGridCell<int>(columnName: 'AC BESAR', value: e.acBesar),
          DataGridCell<int>(columnName: 'PLASTIK', value: e.plastik),
        ]);
      }).toList();
      print('Data Grid Updated: ${_alatKelengkapan.length} rows');
      print('data hlm : ${alatModel.first.ac}');
    }
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.doKelengkapan);
    notifyListeners();
    return true;
  }
}
