import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/input data realisasi/do_mutasi_source.dart';
import 'component/edit_realisasi.dart';
import 'component/jumlah_unit.dart';

class DoMutasiScreen extends GetView<DoMutasiController> {
  const DoMutasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Tujuan': double.nan,
      'Plant': double.nan,
      'Type': double.nan,
      'Tgl': double.nan,
      'Kendaraan': double.nan,
      'Jenis': double.nan,
      'Status': double.nan,
      'LV': double.nan,
      'Supir(Panggilan)': 200,
      'Jumlah': double.nan,
      'Lihat': double.nan,
      'Action': double.nan,
      'Batal': double.nan,
      'Edit': double.nan,
      'Hapus': double.nan,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Reguler DO LPS',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoadingMutasi.value &&
              controller.doRealisasiModel.isEmpty) {
            return const CustomCircularLoader();
          } else {
            final dataSource = DoMutasiSource(
              onLihat: (DoRealisasiModel model) {},
              onAction: (DoRealisasiModel model) {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Tambah Request Kendaraan'),
                    contentWidget: JumlahUnit(
                      model: model,
                    ),
                    // onConfirm: controller.addRequestKendaraan,
                    cancelText: 'Close',
                    confirmText: 'Tambahkan');
              },
              onBatal: (DoRealisasiModel model) {},
              onEdit: (DoRealisasiModel model) {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Edit DO Realisasi'),
                    contentWidget: EditRealisasi(
                      model: model,
                    ),
                    // onConfirm: controller.edit,
                    cancelText: 'Close',
                    confirmText: 'Edit');
              },
              onHapus: (DoRealisasiModel model) {},
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            return LayoutBuilder(builder: (_, __) {
              return Column(
                children: [
                  Expanded(
                    child: SfDataGrid(
                        source: dataSource,
                        columnWidthMode: ColumnWidthMode.auto,
                        allowPullToRefresh: true,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        allowColumnsResizing: true,
                        onColumnResizeUpdate:
                            (ColumnResizeUpdateDetails details) {
                          columnWidths[details.column.columnName] = details.width;
                          return true;
                        },
                        columns: [
                          GridColumn(
                              width: columnWidths['No']!,
                              columnName: 'No',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'No',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Tujuan']!,
                              columnName: 'Tujuan',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Tujuan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Plant']!,
                              columnName: 'Plant',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Plant',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Type']!,
                              columnName: 'Type',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Type',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Tgl']!,
                              columnName: 'Tgl',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Tgl',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Kendaraan']!,
                              columnName: 'Kendaraan',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Kendaraan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Jenis']!,
                              columnName: 'Jenis',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Jenis',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Status']!,
                              columnName: 'Status',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Status',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['LV']!,
                              columnName: 'LV',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'LV',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Supir(Panggilan)']!,
                              columnName: 'Supir(Panggilan)',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Supir(Panggilan)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Jumlah']!,
                              columnName: 'Jumlah',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Jumlah',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Lihat']!,
                              columnName: 'Lihat',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Lihat',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Action']!,
                              columnName: 'Action',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Action',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Batal']!,
                              columnName: 'Batal',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Batal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Edit']!,
                              columnName: 'Edit',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Hapus']!,
                              columnName: 'Hapus',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Hapus',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                        ]),
                  ),
                  SfDataPager(
                    delegate: dataSource,
                    pageCount: controller.doRealisasiModel.isEmpty
                        ? 1
                        : (controller.doRealisasiModel.length / rowsPerPage)
                            .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ],
              );
            });
          }
        },
      ),
    );
  }
}
