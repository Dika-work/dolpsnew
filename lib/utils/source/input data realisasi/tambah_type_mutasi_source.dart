import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../constant/custom_size.dart';

class TambahTypeMutasiSource extends DataGridSource {
  final List<TambahTypeMotorMutasiModel> tambahTypeMotorMutasiModel;
  int startIndex = 0;

  TambahTypeMutasiSource({
    required this.tambahTypeMotorMutasiModel,
    int startIndex = 0,
  }) {
    _updateDataPager(tambahTypeMotorMutasiModel, startIndex);
  }

  List<DataGridRow> _tambahTypeMotor = [];
  final controller = Get.put(TambahTypeMotorMutasiController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _tambahTypeMotor;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _tambahTypeMotor.indexOf(row);
    bool isTotalRow = rowIndex == _tambahTypeMotor.length - 1;

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[200],
      cells: row.getCells().map<Widget>(
        (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            color: isTotalRow && (e.columnName == 'Jumlah Unit')
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
        },
      ).toList(),
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Jumlah Unit', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<TambahTypeMotorMutasiModel> tambahTypeMotorMutasiModel,
      int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (tambahTypeMotorMutasiModel.isEmpty) {
      print('Model is empty, generating empty rows');
      _tambahTypeMotor = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      _tambahTypeMotor =
          tambahTypeMotorMutasiModel.skip(startIndex).take(10).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<String>(
                columnName: 'Jumlah Unit', value: e.jumlahUnit),
          ]);
        },
      ).toList();

      // Hitung total dari kolom "Jumlah Unit"
      int totalJumlahUnit = tambahTypeMotorMutasiModel.fold(0, (sum, item) {
        int jumlah = int.tryParse(item.jumlahUnit) ?? 0;
        return sum + jumlah;
      });

      // Tambahkan baris total di akhir
      _tambahTypeMotor.add(
        DataGridRow(cells: [
          const DataGridCell<String>(columnName: 'No', value: ''),
          const DataGridCell<String>(columnName: 'Type Motor', value: 'Total'),
          DataGridCell<String>(
              columnName: 'Jumlah Unit', value: totalJumlahUnit.toString()),
        ]),
      );
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.tambahTypeMotorMutasiModel, startIndex);
    notifyListeners();
    return true;
  }
}
