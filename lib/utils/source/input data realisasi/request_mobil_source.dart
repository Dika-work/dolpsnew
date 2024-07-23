import 'package:doplsnew/models/input%20data%20realisasi/request_kendaraan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../../helpers/helper_function.dart';
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
  final controller = Get.put(RequestKendaraanController());
  int index = 0;

  @override
  List<DataGridRow> get rows => _requestMobilData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = _requestMobilData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

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
        IconButton(
          icon: const Icon(Iconsax.eye),
          onPressed: () {
            if (onLihat != null) {
              onLihat!(requestKendaraanModel[startIndex + rowIndex]);
            }
          },
        ),
        IconButton(
          icon: const Icon(Iconsax.send),
          onPressed: () {
            if (onKirim != null) {
              onKirim!(requestKendaraanModel[startIndex + rowIndex]);
            }
          },
        ),
        // Action cells (edit & hapus)
        IconButton(
          icon: const Icon(Iconsax.edit),
          onPressed: () {
            if (onEdit != null) {
              onEdit!(requestKendaraanModel[startIndex + rowIndex]);
            }
          },
        ),
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
      ]);
    }).toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(controller.requestKendaraanModel, startIndex);
    notifyListeners();
    return true;
  }
}

// class LihatRequestMobil extends DataGridSource {
//   LihatRequestMobil({
//     required this.model,
//   }) {
//     int index = 0;
//     _dataGrid = model.map(
//       (e) {
//         index++;
//         return DataGridRow(cells: [
//           DataGridCell<int>(columnName: 'No', value: index),
//           DataGridCell<String>(columnName: 'No Kendaraan', value: e.),
//           DataGridCell<String>(columnName: 'Kapasitas', value: e.),
//           DataGridCell<String>(columnName: 'Supir', value: e.),

//         ]);
//       },
//     ).toList();
//   }

//   final List<RequestKendaraanModel> model;
//   List<DataGridRow> _dataGrid = [];

//   @override
//   List<DataGridRow> get rows => _dataGrid;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(cells: row.getCells().map<Widget>(
//       (e) {
//         return Center(
//           child: Text(
//             e.value.toString(),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         );
//       },
//     ).toList());
//   }
// }
