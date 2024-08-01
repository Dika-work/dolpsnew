import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../constant/custom_size.dart';
import '../../theme/app_colors.dart';

class DoRegulerSource extends DataGridSource {
  final void Function(DoRealisasiModel)? onLihat;
  final void Function(DoRealisasiModel)? onAction;
  final void Function(DoRealisasiModel)? onBatal;
  final void Function(DoRealisasiModel)? onEdit;
  final void Function(DoRealisasiModel)? onHapus;
  final List<DoRealisasiModel> doRealisasiModel;
  int startIndex = 0;

  DoRegulerSource({
    required this.onLihat,
    required this.onAction,
    required this.onBatal,
    required this.onEdit,
    required this.onHapus,
    required this.doRealisasiModel,
    int startIndex = 0,
  }) {
    _updateDataPager(doRealisasiModel, startIndex);
  }

  List<DataGridRow> _doRegulerData = [];
  final controller = Get.put(DoRegulerController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doRegulerData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doRegulerData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    var request = doRealisasiModel[startIndex + rowIndex];

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
          // Lihat
          controller.rolesLihat.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onLihat != null && doRealisasiModel.isNotEmpty) {
                      onLihat!(request);
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  child: const Text('Lihat')),
          // Action
          ElevatedButton(
            onPressed: () {
              if (onAction != null && doRealisasiModel.isNotEmpty) {
                onAction!(request);
              } else {
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: request.status == 0
                  ? AppColors.primary
                  : request.status == 1
                      ? AppColors.pink
                      : AppColors.accent,
            ),
            child: Text(
              request.status == 0
                  ? 'Jumlah Unit'
                  : request.status == 1
                      ? 'Type Motor'
                      : 'ACC',
            ),
          ),
          // Batal
          controller.rolesBatal.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onBatal != null && doRealisasiModel.isNotEmpty) {
                      onBatal!(request);
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  child: const Text('Batal')),
          // Edit
          controller.rolesEdit.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onEdit != null && doRealisasiModel.isNotEmpty) {
                      onEdit!(request);
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow),
                  child: Text(
                    'Edit',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.black),
                  )),
          // Hapus
          controller.rolesHapus.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onHapus != null && doRealisasiModel.isNotEmpty) {
                      onHapus!(request);
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  child: const Text('Hapus')),
        ]);
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(
      count,
      (index) {
        return const DataGridRow(cells: [
          DataGridCell<String>(columnName: 'No', value: '-'),
          DataGridCell<String>(columnName: 'User', value: '-'),
          DataGridCell<String>(columnName: 'Plant', value: '-'),
          DataGridCell<String>(columnName: 'Tgl', value: '-'),
          DataGridCell<String>(columnName: 'Supir(Panggilan)', value: '-'),
          DataGridCell<String>(columnName: 'Kendaraan', value: '-'),
          DataGridCell<String>(columnName: 'Type', value: '-'),
          DataGridCell<String>(columnName: 'Jenis', value: '-'),
          DataGridCell<String>(columnName: 'Status', value: '-'),
          DataGridCell<String>(columnName: 'Jumlah', value: '-'),
          DataGridCell<String>(columnName: 'Lihat', value: '-'),
          DataGridCell<String>(columnName: 'Action', value: '-'),
          DataGridCell<String>(columnName: 'Batal', value: '-'),
          DataGridCell<String>(columnName: 'Edit', value: '-'),
          DataGridCell<String>(columnName: 'Hapus', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(
      List<DoRealisasiModel> doRealisasiModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (doRealisasiModel.isEmpty) {
      _doRegulerData = _generateEmptyRows(1);
    } else {
      _doRegulerData =
          doRealisasiModel.skip(startIndex).take(10).map<DataGridRow>(
        (data) {
          index++;
          final tglParsed =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(
                columnName: 'User',
                value: controller.roleUser.value == 'admin' ? data.user : ''),
            DataGridCell<String>(columnName: 'Plant', value: data.plant),
            DataGridCell<String>(columnName: 'Tgl', value: tglParsed),
            DataGridCell<String>(
                columnName: 'Supir(Panggilan)',
                value: '${data.supir}\n(${data.namaPanggilan})'),
            DataGridCell<String>(columnName: 'Kendaraan', value: data.noPolisi),
            DataGridCell<String>(
                columnName: 'Type', value: data.type == 0 ? 'R' : 'M'),
            DataGridCell<String>(
                columnName: 'Jenis',
                value: '${data.inisialDepan}${data.inisialBelakang}'),
            DataGridCell<String>(
                columnName: 'Status',
                value: data.status == 0 ? 'READY' : 'NOT'),
            DataGridCell<int>(columnName: 'Jumlah', value: data.jumlahUnit),
          ]);
        },
      ).toList();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.doRealisasiModel, startIndex);
    notifyListeners();
    return true;
  }
}
