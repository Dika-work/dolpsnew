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

  RequestMobilSource({
    required this.onLihat,
    required this.onKirim,
    required this.onEdit,
    required this.requestKendaraanModel,
  }) {
    _updateDataPager(requestKendaraanModel);
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
    var request = requestKendaraanModel[rowIndex];
    var controller = requestKendaraanController;

    List<Widget> cells = [
      ...row.getCells().take(9).map<Widget>(
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

    // Tambahkan sel dinamis berdasarkan kolom yang ada
    if (controller.rolesLihat == 1) {
      cells.add(
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (onLihat != null && requestKendaraanModel.isNotEmpty) {
                onLihat!(request);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Lihat'),
          ),
        ),
      );
    } else if (controller.rolesLihat == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Lihat
    }

    if (controller.rolesKirim == 1 && request.statusReq == 0) {
      cells.add(
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (onKirim != null && requestKendaraanModel.isNotEmpty) {
                onKirim!(request);
              }
            },
            child: const Text('Kirim'),
          ),
        ),
      );
    } else if (controller.rolesKirim == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Lihat
    }

    if (controller.rolesEdit == 1 && request.statusReq == 0) {
      cells.add(
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (onEdit != null && requestKendaraanModel.isNotEmpty) {
                onEdit!(request);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.yellow),
            child: Text('Edit',
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: AppColors.black)),
          ),
        ),
      );
    } else if (controller.rolesEdit == 1) {
      cells.add(const SizedBox.shrink()); // Placeholder for Lihat
    }

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  void _updateDataPager(List<RequestKendaraanModel> requestKendaraanModel) {
    _requestMobilData = requestKendaraanModel.map<DataGridRow>((data) {
      index++;
      final tglParsed =
          CustomHelperFunctions.getFormattedDate(DateTime.parse(data.tgl));
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: index),
        DataGridCell<String>(columnName: 'Tanggal', value: tglParsed),
        DataGridCell<String>(columnName: 'Plant', value: data.plant),
        DataGridCell<String>(
            columnName: 'Jenis',
            value: '${data.inisialDepan}${data.inisitalBelakang}'),
        DataGridCell<String>(
            columnName: 'Type', value: data.type == 0 ? 'R' : 'M'),
        DataGridCell<int>(columnName: 'Jumlah', value: data.jumlah),
      ]);
    }).toList();
    notifyListeners(); // Memanggil notifikasi untuk memperbarui UI
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(requestKendaraanController.requestKendaraanModel);
    notifyListeners();
    return true;
  }
}
