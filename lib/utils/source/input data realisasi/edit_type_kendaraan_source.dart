import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../../models/input data realisasi/edit_type_motor_model.dart';
import '../../theme/app_colors.dart';

class EditTypeKendaraanSource extends DataGridSource {
  final List<EditTypeMotorModel> editTypeMotorModel;
  final void Function(EditTypeMotorModel)? onEdited;
  final void Function(EditTypeMotorModel)? onDeleted;
  int startIndex = 0;

  EditTypeKendaraanSource({
    required this.editTypeMotorModel,
    required this.onEdited,
    required this.onDeleted,
    int startIndex = 0,
  });

  List<DataGridRow> _editTypeMotor = [];
  final controller = Get.put(EditTypeMotorController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _editTypeMotor;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _editTypeMotor.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: [
          ...row.getCells().map<Widget>(
            (e) {
              return Center(
                child: Text(
                  e.value.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          // Edit cell
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      if (onEdited != null && editTypeMotorModel.isNotEmpty) {
                        onEdited!(editTypeMotorModel[startIndex + rowIndex]);
                      } else {
                        return;
                      }
                    },
                    child: const Text('Edit')),
              ),
            ],
          ),
          // Hapus cell
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      if (onDeleted != null && editTypeMotorModel.isNotEmpty) {
                        onDeleted!(editTypeMotorModel[startIndex + rowIndex]);
                      } else {
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error),
                    child: const Text('Hapus')),
              ),
            ],
          ),
        ]);
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Daerah Tujuan', value: '-'),
        DataGridCell<String>(columnName: 'Jumlah', value: '-'),
        DataGridCell<String>(columnName: 'Edit', value: '-'),
        DataGridCell<String>(columnName: 'Hapus', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<EditTypeMotorModel> tambahTypeMotorModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (tambahTypeMotorModel.isEmpty) {
      _editTypeMotor = _generateEmptyRows(1);
    } else {
      _editTypeMotor =
          tambahTypeMotorModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<String>(columnName: 'Daerah Tujuan', value: e.daerah),
            DataGridCell<String>(columnName: 'Jumlah', value: e.jumlah),
          ]);
        },
      ).toList();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 5;
    _updateDataPager(controller.doRealisasiModel, startIndex);
    notifyListeners();
    return true;
  }
}
