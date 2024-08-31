import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../constant/custom_size.dart';

class TambahTypeMotorSource extends DataGridSource {
  final List<TambahTypeMotorModel> tambahTypeMotorModel;
  int startIndex = 0;

  TambahTypeMotorSource({
    required this.tambahTypeMotorModel,
    int startIndex = 0,
  }) {
    _updateDataPager(tambahTypeMotorModel, startIndex);
  }

  List<DataGridRow> _tambahTypeMotor = [];
  final controller = Get.put(TambahTypeMotorController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _tambahTypeMotor;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _tambahTypeMotor.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    bool isTotalRow = rowIndex == _tambahTypeMotor.length - 1;

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          color: isTotalRow &&
                  (e.columnName == 'SRD' ||
                      e.columnName == 'MKS' ||
                      e.columnName == 'PTK' ||
                      e.columnName == 'BJM')
              ? Colors.yellow
              : Colors.transparent,
          child: Text(
            e.value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'SRD', value: '-'),
        DataGridCell<String>(columnName: 'MKS', value: '-'),
        DataGridCell<String>(columnName: 'PTK', value: '-'),
        DataGridCell<String>(columnName: 'BJM', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<TambahTypeMotorModel> tambahTypeMotorModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (tambahTypeMotorModel.isEmpty) {
      print('Model is empty, generating empty rows');
      _tambahTypeMotor = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      _tambahTypeMotor =
          tambahTypeMotorModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<String>(
                columnName: 'SRD',
                value: e.jumlahSRD == 0 ? '-' : e.jumlahSRD.toString()),
            DataGridCell<String>(
                columnName: 'MKS',
                value: e.jumlahMKS == 0 ? '-' : e.jumlahMKS.toString()),
            DataGridCell<String>(
                columnName: 'PTK',
                value: e.jumlahPTK == 0 ? '-' : e.jumlahPTK.toString()),
            DataGridCell<String>(
                columnName: 'BJM',
                value: e.jumlahBJM == 0 ? '-' : e.jumlahBJM.toString()),
          ]);
        },
      ).toList();
      notifyListeners();

      final totalSrd =
          tambahTypeMotorModel.fold(0, (sum, item) => sum + item.jumlahSRD);
      final totalMks =
          tambahTypeMotorModel.fold(0, (sum, item) => sum + item.jumlahMKS);
      final totalPtk =
          tambahTypeMotorModel.fold(0, (sum, item) => sum + item.jumlahPTK);
      final totalBjm =
          tambahTypeMotorModel.fold(0, (sum, item) => sum + item.jumlahBJM);

      // Add total row
      _tambahTypeMotor.add(DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'No', value: ''),
        const DataGridCell<String>(columnName: 'Type Motor', value: 'TOTAL'),
        DataGridCell<String>(
            columnName: 'SRD',
            value: totalSrd == 0 ? '-' : totalSrd.toString()),
        DataGridCell<String>(
            columnName: 'MKS',
            value: totalMks == 0 ? '-' : totalMks.toString()),
        DataGridCell<String>(
            columnName: 'PTK',
            value: totalPtk == 0 ? '-' : totalPtk.toString()),
        DataGridCell<String>(
            columnName: 'BJM',
            value: totalBjm == 0 ? '-' : totalBjm.toString()),
      ]));
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 5;
    _updateDataPager(controller.tambahTypeMotorModel, startIndex);
    notifyListeners();
    return true;
  }
}
