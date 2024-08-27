import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../constant/custom_size.dart';
import '../../theme/app_colors.dart';

class DoRegulerAllSource extends DataGridSource {
  final void Function(DoRealisasiModel)? onLihat;
  final void Function(DoRealisasiModel)? onAction;
  final void Function(DoRealisasiModel)? onBatal;
  final void Function(DoRealisasiModel)? onEdit;
  final void Function(DoRealisasiModel)? onType;
  final List<DoRealisasiModel> doRealisasiModelAll;
  int startIndex = 0;

  DoRegulerAllSource({
    required this.onLihat,
    required this.onAction,
    required this.onBatal,
    required this.onEdit,
    required this.onType,
    required this.doRealisasiModelAll,
    int startIndex = 0,
  }) {
    _updateDataPager(doRealisasiModelAll, startIndex);
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
    var request = doRealisasiModelAll.isNotEmpty &&
            startIndex + rowIndex < doRealisasiModelAll.length
        ? doRealisasiModelAll[startIndex + rowIndex]
        : null;

    List<Widget> cells = [
      ...row.getCells().take(10).map<Widget>(
        (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    ];

    // Add Lihat cell
    if (controller.rolesLihat == 1 && request?.status == 1 ||
        request?.status == 3 ||
        request?.status == 4) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (onLihat != null && request != null) {
                    onLihat!(request);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.all(8.0),
                ),
                child: const Text('Lihat'),
              ),
            ),
          ],
        ),
      );
    } else if (controller.rolesLihat == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Lihat
    }

    // Add Action cell
    if (controller.rolesJumlah == 1) {
      if (request?.status == 0 ||
          request?.status == 1 ||
          request?.status == 2 ||
          request?.status == 3) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (onAction != null) {
                      onAction!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: request!.status == 0
                        ? AppColors.primary
                        : request.status == 1 || request.status == 2
                            ? AppColors.pink
                            : request.status == 3
                                ? AppColors.success
                                : Colors.transparent,
                  ),
                  child: Text(
                    request.status == 0
                        ? 'Jumlah Unit'
                        : request.status == 1 || request.status == 2
                            ? 'Type Motor'
                            : request.status == 3
                                ? 'ACC'
                                : '',
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (request?.status == 4) {
        cells.add(
          request!.totalHutang != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          print('..INI BAKALAN KE PLANT GABUNGAN');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error),
                        child: const Text(
                          'Hutang ACC',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    } else if (controller.rolesJumlah == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Action
    }

    // Add Batal cell
    if (controller.rolesBatal == 1 && request?.status == 0) {
      cells.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (onBatal != null && request != null) {
                    onBatal!(request);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Batal'),
              ),
            ),
          ],
        ),
      );
    } else if (controller.rolesBatal == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Batal
    }

    // Add Edit cell
    if (controller.rolesEdit == 1) {
      if (request?.status == 3 || request?.status == 4) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isAllRegulerAdmin)
                SizedBox(
                  height: 60,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      if (onEdit != null) {
                        onEdit!(request!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold),
                    child: Text(
                      'Edit',
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: AppColors.black),
                    ),
                  ),
                ),
              if (controller.isAllRegulerAdmin)
                const SizedBox(height: CustomSize.sm),
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (onType != null) {
                      onType!(request!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  child: Text(
                    'Type',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (request?.status == 0 ||
          request?.status == 1 ||
          request?.status == 2) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (onEdit != null) {
                    onEdit!(request!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                ),
                child: Text(
                  'Edit',
                  style: Theme.of(Get.context!)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: AppColors.black),
                ),
              ),
            ],
          ),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    } else if (controller.rolesEdit == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Edit
    }

    print('ini banyaknya cells di all do reguler: ${cells.length}');

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
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
          DataGridCell<String>(columnName: 'Tipe', value: '-'),
          DataGridCell<String>(columnName: 'Jenis', value: '-'),
          DataGridCell<String>(columnName: 'Jumlah', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(
      List<DoRealisasiModel> doRealisasiModelAll, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (doRealisasiModelAll.isEmpty) {
      _doRegulerData = _generateEmptyRows(1);
    } else {
      _doRegulerData =
          doRealisasiModelAll.skip(startIndex).take(10).map<DataGridRow>(
        (data) {
          index++;
          final tglParsed =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'User', value: data.user),
            DataGridCell<String>(columnName: 'Plant', value: data.plant),
            DataGridCell<String>(columnName: 'Tgl', value: tglParsed),
            DataGridCell<String>(
                columnName: 'Supir(Panggilan)',
                value: data.namaPanggilan.isEmpty
                    ? data.supir
                    : '${data.supir}\n(${data.namaPanggilan})'),
            DataGridCell<String>(columnName: 'Kendaraan', value: data.noPolisi),
            DataGridCell<String>(
                columnName: 'Type', value: data.type == 0 ? 'R' : 'M'),
            DataGridCell<String>(
                columnName: 'Jenis',
                value: '${data.inisialDepan}${data.inisialBelakang}'),
            DataGridCell<int>(columnName: 'Jumlah', value: data.jumlahUnit),
          ]);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.doRealisasiModelAll, startIndex);
    notifyListeners();
    return true;
  }
}
