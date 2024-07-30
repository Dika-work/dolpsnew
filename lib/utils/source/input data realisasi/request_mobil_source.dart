import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/request_kendaraan_model.dart';
import '../../constant/custom_size.dart';

class RequestMobilSource extends DataGridSource {
  final void Function(RequestKendaraanModel)? onLihat;
  final void Function(RequestKendaraanModel)? onKirim;
  final void Function(RequestKendaraanModel)? onEdit;
  final List<RequestKendaraanModel> requestKendaraanModel;
  int startIndex = 0;

  RequestMobilSource({
    required this.onLihat,
    required this.onKirim,
    required this.onEdit,
    required this.requestKendaraanModel,
    int startIndex = 0,
  }) {
    _updateDataPager(requestKendaraanModel, startIndex);
  }

  List<DataGridRow> _requestMobilData = [];
  final requestKendaraanController = Get.put(RequestKendaraanController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _requestMobilData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _requestMobilData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;
    var request = requestKendaraanModel[startIndex + rowIndex];

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: [
        ...row.getCells().map<Widget>((e) {
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
        }),
        // Action cells (lihat and kirim)
        requestKendaraanController.rolesLihat.value == 0
            ? const SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  if (onLihat != null && requestKendaraanModel.isNotEmpty) {
                    onLihat!(request);
                  } else {
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success),
                child: const Text('Lihat')),
        requestKendaraanController.rolesKirim.value == 0
            ? const SizedBox.shrink()
            : request.statusReq == 0
                ? ElevatedButton(
                    onPressed: () {
                      if (onKirim != null && requestKendaraanModel.isNotEmpty) {
                        onKirim!(request);
                      } else {
                        return;
                      }
                    },
                    child: const Text('Kirim'))
                : const SizedBox.shrink(),
        // Action cells (edit & hapus)
        requestKendaraanController.rolesEdit.value == 0
            ? const SizedBox.shrink()
            : request.statusReq == 0
                ? ElevatedButton(
                    onPressed: () {
                      if (onEdit != null && requestKendaraanModel.isNotEmpty) {
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
                    ))
                : const SizedBox.shrink(),
      ],
    );
  }

  void _updateDataPager(
      List<RequestKendaraanModel> requestKendaraanModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    _requestMobilData = requestKendaraanModel
        .skip(startIndex)
        .take(10)
        .map<DataGridRow>((data) {
      index++;
      final tglParsed =
          CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Pengurus', value: data.pengurus),
        DataGridCell<String>(columnName: 'Tanggal', value: tglParsed),
        DataGridCell<String>(columnName: 'Jam', value: data.jam),
        DataGridCell<String>(columnName: 'Plant', value: data.plant),
        DataGridCell<String>(columnName: 'Tujuan', value: data.tujuan),
        DataGridCell<String>(
            columnName: 'Type', value: data.type == 0 ? 'REGULER' : 'MUTASI'),
        DataGridCell<String>(columnName: 'Jenis', value: data.jenis),
        DataGridCell<int>(columnName: 'Jumlah', value: data.jumlah),
        DataGridCell<int>(columnName: 'Status Req', value: data.statusReq),
      ]);
    }).toList();
    notifyListeners(); // Memanggil notifikasi untuk memperbarui UI
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(
        requestKendaraanController.requestKendaraanModel, startIndex);
    notifyListeners();
    return true;
  }
}