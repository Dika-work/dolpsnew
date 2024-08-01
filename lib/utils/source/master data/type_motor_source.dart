import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/master data/type_motor_controller.dart';
import '../../../models/master data/type_motor_model.dart';
import '../../constant/custom_size.dart';

class TypeMotorSource extends DataGridSource {
  final void Function(TypeMotorModel)? onEdit;
  final void Function(TypeMotorModel)? onHapus;
  final List<TypeMotorModel> typeMotorModel;
  int startIndex = 0;

  TypeMotorSource({
    required this.onEdit,
    required this.onHapus,
    required this.typeMotorModel,
    int startIndex = 0,
  }) {
    _updateDataPager(typeMotorModel, startIndex);
  }

  List<DataGridRow> _typeMotorData = [];
  final controller = Get.put(TypeMotorController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _typeMotorData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _typeMotorData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: [
          ...row.getCells().map<Widget>((e) {
            return Center(
              child: Text(
                e.value.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (onEdit != null && typeMotorModel.isNotEmpty) {
                    onEdit!(typeMotorModel[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success),
                child: const Text('Edit'),
              ),
              const SizedBox(height: CustomSize.sm),
              ElevatedButton(
                onPressed: () {
                  if (onHapus != null && typeMotorModel.isNotEmpty) {
                    onHapus!(typeMotorModel[startIndex + rowIndex]);
                  } else {
                    return;
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                child: const Text('Hapus'),
              )
            ],
          )
        ]);
  }

  void _updateDataPager(List<TypeMotorModel> typeMotorModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    _typeMotorData = typeMotorModel.skip(startIndex).take(10).map<DataGridRow>(
      (data) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Merk', value: data.merk),
          DataGridCell<String>(columnName: 'Type Motor', value: data.typeMotor),
          DataGridCell<String>(
              columnName: 'HLM', value: data.hlm == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'AC', value: data.ac == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'KS', value: data.ks == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'TS', value: data.ts == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'BP', value: data.bp == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'BS', value: data.bs == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'PLT', value: data.plt == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'Stay L/R', value: data.stay == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'Ac Besar', value: data.acBesar == 0 ? 'NO' : 'YES'),
          DataGridCell<String>(
              columnName: 'Plastik', value: data.plastik == 0 ? 'NO' : 'YES'),
        ]);
      },
    ).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.typeMotorModel, startIndex);
    notifyListeners();
    return true;
  }
}
