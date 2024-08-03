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
  final void Function(DoRealisasiModel)? onType;
  final void Function(DoRealisasiModel)? onHapus;
  final List<DoRealisasiModel> doRealisasiModel;
  int startIndex = 0;

  DoRegulerSource({
    required this.onLihat,
    required this.onAction,
    required this.onBatal,
    required this.onEdit,
    required this.onType,
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
    var request = doRealisasiModel.isNotEmpty &&
            startIndex + rowIndex < doRealisasiModel.length
        ? doRealisasiModel[startIndex + rowIndex]
        : null;

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: [
        ...row.getCells().take(10).map<Widget>(
          (e) {
            return Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
                child: Text(
                  e.value.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        if (request != null) ...[
          // Lihat
          controller.rolesLihat.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onLihat != null) {
                      onLihat!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  child: const Text('Lihat')),
          // Action
          ElevatedButton(
            onPressed: () {
              if (onAction != null) {
                onAction!(request);
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
              : request.status == 0
                  ? ElevatedButton(
                      onPressed: () {
                        if (onBatal != null) {
                          onBatal!(request);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error),
                      child: const Text('Batal'))
                  : const SizedBox.shrink(),
          // Edit
          controller.rolesEdit.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onEdit != null) {
                      onEdit!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          request.status == 0 || request.status == 1
                              ? AppColors.yellow
                              : AppColors.gold),
                  child: Text(
                    'Edit',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.black),
                  )),
          // Type
          request.status == 2
              ? ElevatedButton(
                  onPressed: () {
                    if (onType != null) {
                      onType!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  child: Text(
                    'Type',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.black),
                  ))
              : const SizedBox.shrink(),
          // Hapus
          controller.rolesHapus.value == 0
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    if (onHapus != null) {
                      onHapus!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  child: const Text('Hapus')),
        ] else ...[
          // Placeholder for when no data is available
          const SizedBox.shrink(), // Lihat
          const SizedBox.shrink(), // Action
          const SizedBox.shrink(), // Batal
          const SizedBox.shrink(), // Edit
          const SizedBox.shrink(), // Type
          const SizedBox.shrink(), // Hapus
        ]
      ],
    );
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
