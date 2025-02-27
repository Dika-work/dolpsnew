import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../constant/custom_size.dart';
import '../../theme/app_colors.dart';

class DoMutasiSource extends DataGridSource {
  final void Function(DoRealisasiModel)? onLihat;
  final void Function(DoRealisasiModel)? onAction;
  final void Function(DoRealisasiModel)? onBatal;
  final void Function(DoRealisasiModel)? onEdit;
  final void Function(DoRealisasiModel)? onType;
  final List<DoRealisasiModel> doRealisasiModel;
  int startIndex = 0;

  DoMutasiSource({
    required this.onLihat,
    required this.onAction,
    required this.onBatal,
    required this.onEdit,
    required this.onType,
    required this.doRealisasiModel,
    int startIndex = 0,
  }) {
    _updateDataPager(
        doRealisasiModel, startIndex, controller.rolePlant, controller.isAdmin);
  }

  List<DataGridRow> _doMutasiData = [];
  final DoMutasiController controller = Get.put(DoMutasiController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doMutasiData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doMutasiData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    var request = doRealisasiModel.isNotEmpty &&
            startIndex + rowIndex < doRealisasiModel.length
        ? doRealisasiModel[startIndex + rowIndex]
        : null;

    List<Widget> cells = [
      ...row.getCells().take(9).map<Widget>(
        (e) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
              child: Text(
                e.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: CustomSize.fontSizeXm),
              ),
            ),
          );
        },
      ),
    ];

    // Add Lihat cell
    if (controller.rolesLihat == 1 && request?.status == 1 ||
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

    if (controller.rolesJumlah == 1 && controller.isAdmin) {
      if (request != null &&
          (request.status == 0 ||
              request.status == 1 ||
              request.status == 2 ||
              request.status == 3)) {
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
                    backgroundColor: request.status == 0
                        ? AppColors.primary
                        : request.status == 1 || request.status == 2
                            ? AppColors.pink
                            : AppColors.success,
                  ),
                  child: Text(request.status == 0
                      ? 'Jumlah Unit'
                      : request.status == 1 || request.status == 2
                          ? 'Type Motor'
                          : 'Terima Motor'),
                ),
              ),
            ],
          ),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    }

    if (controller.rolesBatal == 1) {
      if (request != null && request.status == 0) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      if (onBatal != null) {
                        onBatal!(request);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error),
                    child: const Text('Batal')),
              ),
            ],
          ),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    }

    if (controller.rolesEdit == 1) {
      if (request != null &&
          (request.status == 2 || request.status == 3 || request.status == 5)) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.roleUser == 'admin')
                ElevatedButton(
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
              if (controller.roleUser == 'admin')
                const SizedBox(height: CustomSize.sm),
              ElevatedButton(
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
                  )),
            ],
          ),
        );
      } else if (request?.status == 0 || request?.status == 1) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (onEdit != null && request != null) {
                      onEdit!(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          request?.status == 0 || request?.status == 1
                              ? AppColors.yellow
                              : AppColors.gold),
                  child: Text(
                    'Edit',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.black),
                  )),
            ],
          ),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    }

    return DataGridRowAdapter(
      color: request?.status == 9
          ? AppColors.batalJalan
          : isEvenRow
              ? Colors.white
              : Colors.grey[200],
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(
      count,
      (index) {
        return const DataGridRow(cells: [
          DataGridCell<String>(columnName: 'No', value: '-'),
          DataGridCell<String>(columnName: 'Plant', value: '-'),
          DataGridCell<String>(columnName: 'Tujuan', value: '-'),
          DataGridCell<String>(columnName: 'Type', value: '-'),
          DataGridCell<String>(columnName: 'Tgl', value: '-'),
          DataGridCell<String>(columnName: 'Supir(Panggilan)', value: '-'),
          DataGridCell<String>(columnName: 'Kendaraan', value: '-'),
          DataGridCell<String>(columnName: 'Jenis', value: '-'),
          DataGridCell<String>(columnName: 'Jumlah', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(
    List<DoRealisasiModel> doRealisasiModel,
    int startIndex,
    String userPlant,
    bool isAdmin,
  ) {
    this.startIndex = startIndex;
    index = startIndex;

    final List<int> validPlants = [
      1100,
      1200,
      1300,
      1350,
      1700,
      1800,
      1900,
    ];

    final filteredPlants = isAdmin
        ? validPlants // Jika admin, tampilkan semua plant
        : validPlants.where((plant) => plant.toString() == userPlant).toList();

    print("doRealisasiModel mutasi: $doRealisasiModel");
    print("filteredPlants mutasi: $filteredPlants");

    if (doRealisasiModel.isEmpty) {
      _doMutasiData = _generateEmptyRows(1);
    } else {
      _doMutasiData = doRealisasiModel
          .where(
              (item) => filteredPlants.contains(int.tryParse(item.plant) ?? 0))
          .skip(startIndex)
          .take(10)
          .map<DataGridRow>(
        (data) {
          index++;
          final tglParsed =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
          List<DataGridCell> cells = [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Plant', value: data.plant),
            DataGridCell<String>(columnName: 'Tujuan', value: data.tujuan),
            DataGridCell<String>(
                columnName: 'Type', value: data.type == 0 ? 'R' : 'M'),
            DataGridCell<String>(columnName: 'Tgl', value: tglParsed),
            DataGridCell<String>(
                columnName: 'Supir(Panggilan)',
                value: data.namaPanggilan.isEmpty
                    ? data.supir
                    : '${data.supir}\n(${data.namaPanggilan})'),
            DataGridCell<String>(columnName: 'Kendaraan', value: data.noPolisi),
            DataGridCell<String>(
                columnName: 'Jenis',
                value: '${data.inisialDepan}${data.inisialBelakang}'),
            DataGridCell<int>(columnName: 'Jumlah', value: data.jumlahUnit),
          ];

          if (controller.rolesLihat == 1 && data.status != 0) {
            cells.add(const DataGridCell<String>(
                columnName: 'Lihat', value: 'Lihat'));
          }
          if (controller.rolesJumlah == 1) {
            cells.add(const DataGridCell<String>(
                columnName: 'Action', value: 'Action'));
          }
          if (controller.rolesBatal == 1 && data.status == 0) {
            cells.add(const DataGridCell<String>(
                columnName: 'Batal', value: 'Batal'));
          }
          if (controller.rolesEdit == 1) {
            cells.add(
                const DataGridCell<String>(columnName: 'Edit', value: 'Edit'));
          }
          return DataGridRow(cells: cells);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.doRealisasiModel, newPageIndex,
        controller.rolePlant, controller.isAdmin);
    notifyListeners();
    return true;
  }
}
