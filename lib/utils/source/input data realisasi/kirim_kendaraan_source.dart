import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/kirim_kendaraan_controller.dart';
import '../../../models/input data realisasi/kirim_kendaraan_model.dart';
import '../../constant/custom_size.dart';

class KirimKendaraanSource extends DataGridSource {
  final void Function(KirimKendaraanModel)? onDelete;
  final List<KirimKendaraanModel> kirimKendaraanModel;
  int startIndex = 0;

  KirimKendaraanSource({
    required this.onDelete,
    required this.kirimKendaraanModel,
    int startIndex = 0,
  }) {}

  List<DataGridRow> _kirimKendaraanData = [];
  final controller = Get.put(KirimKendaraanController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _kirimKendaraanData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _kirimKendaraanData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.white : Colors.grey[200],
        cells: [
          ...row.getCells().map<Widget>(
            (e) {
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: CustomSize.md),
                  child: Text(
                    e.value.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          // Action cells hapus
          IconButton(
              onPressed: () {
                if (onDelete != null) {
                  onDelete!(kirimKendaraanModel[startIndex + rowIndex]);
                }
              },
              icon: const Icon(Iconsax.trash))
        ]);
  }

  void _updateDataPager(
      List<KirimKendaraanModel> kirimKendaraanModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _kirimKendaraanData =
        kirimKendaraanModel.skip(startIndex).take(10).map<DataGridRow>(
      (data) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Plant', value: data.plant),
          DataGridCell<String>(columnName: 'Type', value: data.type),
          DataGridCell<String>(columnName: 'Kendaraan', value: data.kendaraan),
          DataGridCell<String>(columnName: 'Jenis', value: data.jenisKendaraan),
          DataGridCell<String>(columnName: 'Status', value: data.status),
          DataGridCell<String>(
              columnName: 'LV Kerusakan', value: data.lvKerusakaan),
          DataGridCell<String>(columnName: 'Supir', value: data.supir),
        ]);
      },
    ).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.kirimKendaraanModel, startIndex);
    notifyListeners();
    return true;
  }
}
