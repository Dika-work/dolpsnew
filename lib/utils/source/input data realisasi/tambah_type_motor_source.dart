import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/tambah_type_motor_model.dart';

class TambahTypeMotorSource extends DataGridSource {
  final List<TambahTypeMotorModel> tambahTypeMotorModel;
  int startIndex = 0;

  TambahTypeMotorSource({
    required this.tambahTypeMotorModel,
    int startIndex = 0,
  });

  List<DataGridRow> _tambahTypeMotor = [];
  final controller = Get.put(TambahTypeMotorController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _tambahTypeMotor;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _tambahTypeMotor.indexOf(row);
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
            DataGridCell<int>(columnName: 'SRD', value: e.jumlahSRD),
            DataGridCell<int>(columnName: 'MKS', value: e.jumlahMKS),
            DataGridCell<int>(columnName: 'PTK', value: e.jumlahPTK),
            DataGridCell<int>(columnName: 'BJM', value: e.jumlahBJM),
          ]);
        },
      ).toList();
    }
    notifyListeners();
    print('Data grid updated, listeners notified');
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 5;
    _updateDataPager(controller.tambahTypeMotorModel, startIndex);
    notifyListeners();
    return true;
  }
}
