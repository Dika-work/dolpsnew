import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../constant/custom_size.dart';

class DoMutasiSource extends DataGridSource {
  final void Function(DoRealisasiModel)? onLihat;
  final void Function(DoRealisasiModel)? onAction;
  final void Function(DoRealisasiModel)? onBatal;
  final void Function(DoRealisasiModel)? onEdit;
  final void Function(DoRealisasiModel)? onHapus;
  final List<DoRealisasiModel> doRealisasiModel;
  int startIndex = 0;

  DoMutasiSource({
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

  List<DataGridRow> _doMutasiData = [];
  final controller = Get.put(DoMutasiController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _doMutasiData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _doMutasiData.indexOf(row);
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
          // Lihat
          IconButton(
              onPressed: () {
                if (onLihat != null && doRealisasiModel.isNotEmpty) {
                  onLihat!(doRealisasiModel[startIndex + rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.eye)),
          // Action
          IconButton(
              onPressed: () {
                if (onAction != null && doRealisasiModel.isNotEmpty) {
                  onAction!(doRealisasiModel[startIndex + rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.activity)),
          // Batal
          IconButton(
              onPressed: () {
                if (onBatal != null && doRealisasiModel.isNotEmpty) {
                  onBatal!(doRealisasiModel[startIndex + rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.forbidden)),
          // Edit
          IconButton(
              onPressed: () {
                if (onEdit != null && doRealisasiModel.isNotEmpty) {
                  onEdit!(doRealisasiModel[startIndex + rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.edit)),
          // Hapus
          IconButton(
              onPressed: () {
                if (onHapus != null && doRealisasiModel.isNotEmpty) {
                  onHapus!(doRealisasiModel[startIndex + rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.edit)),
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
          DataGridCell<String>(columnName: 'Type', value: '-'),
          DataGridCell<String>(columnName: 'Tgl', value: '-'),
          DataGridCell<String>(columnName: 'Kendaraan', value: '-'),
          DataGridCell<String>(columnName: 'Jenis', value: '-'),
          DataGridCell<String>(columnName: 'Status', value: '-'),
          DataGridCell<String>(columnName: 'LV', value: '-'),
          DataGridCell<String>(columnName: 'Supir(Panggilan)', value: '-'),
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
      _doMutasiData = _generateEmptyRows(1);
    } else {
      _doMutasiData =
          doRealisasiModel.skip(startIndex).take(10).map<DataGridRow>(
        (data) {
          index++;
          final tglParsed =
          CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'User', value: data.user),
            DataGridCell<String>(columnName: 'Plant', value: data.plant),
            DataGridCell<String>(
                columnName: 'Type',
                value: data.type == 0 ? 'REGULER' : 'MUTASI'),
            DataGridCell<String>(columnName: 'Tgl', value: tglParsed),
            DataGridCell<String>(
                columnName: 'Kendaraan', value: data.kendaraan),
            DataGridCell<String>(columnName: 'Jenis', value: data.jenisKen),
            DataGridCell<String>(
                columnName: 'Status',
                value: data.status == 0 ? 'READY' : 'NOT'),
            const DataGridCell<String>(columnName: 'LV', value: '-'),
            DataGridCell<String>(
                columnName: 'Supir(Panggilan)',
                value: '${data.supir}\n(${data.namaPanggilan})'),
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
