import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/master data/type_motor_controller.dart';
import '../../../models/master data/type_motor_model.dart';
import '../../constant/custom_size.dart';

class TypeMotorSource extends DataGridSource {
  final void Function(TypeMotorModel)? onEdit;
  final void Function(TypeMotorModel)? onHapus;
  final List<TypeMotorModel> typeMotorModel;

  TypeMotorSource({
    required this.onEdit,
    required this.onHapus,
    required this.typeMotorModel,
  }) {
    _updateDataPager(typeMotorModel);
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
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (onEdit != null && typeMotorModel.isNotEmpty) {
                      onEdit!(typeMotorModel[rowIndex]);
                    } else {
                      return;
                    }
                  },
                  icon: const Icon(Iconsax.grid_edit)),
              const SizedBox(height: CustomSize.sm),
              IconButton(
                  onPressed: () {
                    if (onHapus != null && typeMotorModel.isNotEmpty) {
                      onHapus!(typeMotorModel[rowIndex]);
                    } else {
                      return;
                    }
                  },
                  icon: const Icon(Iconsax.trash, color: Colors.red))
            ],
          )
        ]);
  }

  void _updateDataPager(List<TypeMotorModel> typeMotorModel) {
    _typeMotorData = typeMotorModel.map<DataGridRow>(
      (data) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Type Motor', value: data.typeMotor),
          DataGridCell<String>(columnName: 'Merk', value: data.merk),
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
    _updateDataPager(controller.typeMotorModel);
    notifyListeners();
    return true;
  }
}
