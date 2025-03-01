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
  // int startIndex = 0;

  DoRegulerAllSource({
    required this.onLihat,
    required this.onAction,
    required this.onBatal,
    required this.onEdit,
    required this.onType,
    required this.doRealisasiModelAll,
    // int startIndex = 0,
  }) {
    _updateDataPager(
        doRealisasiModelAll, //startIndex,
        controller.rolePlant,
        controller.isAdmin);
  }

  List<DataGridRow> _doRegulerData = [];
  final DoRegulerController controller = Get.put(DoRegulerController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doRegulerData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doRegulerData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    var request = doRealisasiModelAll.isNotEmpty &&
            // startIndex +
            rowIndex < doRealisasiModelAll.length
        ? doRealisasiModelAll[
            //startIndex +
            rowIndex]
        : null;

    List<Widget> cells = [
      ...row.getCells().take(8).map<Widget>(
        (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: CustomSize.fontSizeXm),
            ),
          );
        },
      ),
    ];

    // Add Lihat cell
    if (controller.rolesLihat == 1 &&
        (request?.status == 1 ||
            request?.status == 3 ||
            request?.status == 4)) {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.roleUser == 'admin' ||
                  controller.rolePlant == '1300' ||
                  controller.rolePlant == '1350' ||
                  controller.rolePlant == '1700' ||
                  controller.rolePlant == '1800')
                SizedBox(
                  height: 60,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      print('..INI BAKALAN KE PLANT GABUNGAN');
                    },
                    child: const Text(
                      'Gabungan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (controller.roleUser == 'admin' ||
                  controller.rolePlant == '1300' ||
                  controller.rolePlant == '1350' ||
                  controller.rolePlant == '1700' ||
                  controller.rolePlant == '1800')
                const SizedBox(height: CustomSize.sm),
              if (doRealisasiModelAll.isNotEmpty &&
                  doRealisasiModelAll.first.totalHutang != 0)
                SizedBox(
                  height: 60,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      print('..INI AKAN KE HUTANG ACC');
                    },
                    child: const Text('Hutang Acc'),
                  ),
                ),
            ],
          ),
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    } else if (controller.rolesJumlah == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Action
    }

    // Add Edit cell
    if (controller.rolesEdit == 1) {
      if (request?.status == 0 || request?.status == 1) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    backgroundColor:
                        request?.status == 0 || request?.status == 1
                            ? AppColors.yellow
                            : AppColors.gold,
                  ),
                  child: Text(
                    'Edit',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium
                        ?.apply(color: AppColors.black),
                  ),
                ),
              ),
            ],
          ),
        );
        print("Added Edit cell");
      } else if (request?.status == 2 ||
          request?.status == 3 ||
          request?.status == 4) {
        cells.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.roleUser == 'admin')
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
              if (controller.roleUser == 'admin')
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
        print("Added Edit/Type cell");
      } else {
        cells.add(const SizedBox.shrink());
        print("Added Edit placeholder");
      }
    } else if (controller.rolesEdit == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Edit
      print("Added Edit placeholder for role edit");
    }

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
    List<DoRealisasiModel> doRealisasiModelAll,
    // int startIndex,
    String userPlant,
    bool isAdmin,
  ) {
    // this.startIndex = startIndex;

    // Perbaiki perhitungan index berdasarkan halaman saat ini
    // int currentPageStartIndex =
    //     startIndex * 10; // Misalnya, setiap halaman memiliki 10 item
    // index = currentPageStartIndex;

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

    if (doRealisasiModelAll.isEmpty) {
      _doRegulerData = _generateEmptyRows(1);
    } else {
      _doRegulerData = doRealisasiModelAll
          .where(
              (item) => filteredPlants.contains(int.tryParse(item.plant) ?? 0))
          // .skip(currentPageStartIndex)
          // .take(10)
          .map<DataGridRow>(
        (data) {
          index++;
          final tglParsed =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
          List<DataGridCell> cells = [
            DataGridCell<int>(
                columnName: 'No',
                value: index), // Nomor yang benar berdasarkan halaman
            DataGridCell<String>(columnName: 'Plant', value: data.plant),
            DataGridCell<String>(columnName: 'Tgl', value: tglParsed),
            DataGridCell<String>(
                columnName: 'Supir(Panggilan)',
                value: data.namaPanggilan.isEmpty
                    ? data.supir
                    : '${data.supir}\n(${data.namaPanggilan})'),
            DataGridCell<String>(columnName: 'Kendaraan', value: data.noPolisi),
            DataGridCell<String>(
                columnName: 'Tipe', value: data.type == 0 ? 'R' : 'M'),
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
    _updateDataPager(
        controller.doRealisasiModelAll, //newPageIndex,
        controller.rolePlant,
        controller.isAdmin);
    notifyListeners();
    return true;
  }
}
