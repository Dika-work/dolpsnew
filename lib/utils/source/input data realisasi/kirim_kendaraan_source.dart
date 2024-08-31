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
  }) {
    _updateDataPager(kirimKendaraanModel, startIndex);
  }

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
          controller.kirimKendaraanModel.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          if (onDelete != null &&
                              kirimKendaraanModel.isNotEmpty) {
                            onDelete!(
                                kirimKendaraanModel[startIndex + rowIndex]);
                          } else {
                            return;
                          }
                        },
                        child: const Icon(Iconsax.trash),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: CustomSize.md),
                    child: const Text(
                      '-',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ]);
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Supir', value: '-'),
        DataGridCell<String>(columnName: 'No Polisi', value: '-'),
        DataGridCell<String>(columnName: 'Status', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<KirimKendaraanModel> kirimKendaraanModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (kirimKendaraanModel.isEmpty) {
      _kirimKendaraanData = _generateEmptyRows(1);
    } else {
      _kirimKendaraanData =
          kirimKendaraanModel.skip(startIndex).take(10).map<DataGridRow>(
        (data) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Supir', value: data.supir),
            DataGridCell<String>(columnName: 'No Polisi', value: data.noPolisi),
            DataGridCell<String>(
                columnName: 'Status',
                value: data.status == 0 ? 'READY' : 'NOT'),
          ]);
        },
      ).toList();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.kirimKendaraanModel, startIndex);
    notifyListeners();
    return true;
  }
}
