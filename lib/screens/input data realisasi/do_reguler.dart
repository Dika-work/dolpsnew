import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/input data realisasi/do_reguler_source.dart';
import '../../utils/theme/app_colors.dart';
import 'component/aksesoris.dart';
import 'component/edit_realisasi.dart';
import 'component/edit_type.dart';
import 'component/jumlah_unit.dart';
import 'component/lihat_realisasi.dart';
import 'component/tambah_type_kendaraan.dart';

class DoRegulerScreen extends GetView<DoRegulerController> {
  const DoRegulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'User': double.nan,
      'Plant': double.nan,
      'Tgl': 130,
      'Supir(Panggilan)': 200,
      'Kendaraan': 120,
      'Tipe': double.nan,
      'Jenis': double.nan,
      'Status': double.nan,
      'Jumlah': double.nan,
      'Lihat': 150,
      'Action': 150,
      'Batal': 150,
      'Edit': 150,
      'Hapus': 150,
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
          if (controller.isLoadingReguler.value &&
              controller.doRealisasiModel.isEmpty) {
            return const CustomCircularLoader();
          } else {
            final dataSource = DoRegulerSource(
              onLihat: (DoRealisasiModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: AppColors.white,
                      child: LihatRealisasi(model: model)
                    );
                  },
                );
              },
              onAction: (DoRealisasiModel model) {
                final tambahTypeMotorController =
                    Get.put(TambahTypeMotorController());
                if (model.status == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return JumlahUnit(model: model);
                    },
                  );
                } else if (model.status == 1 || model.status == 2) {
                  tambahTypeMotorController.fetchTambahTypeMotor(model.id);
                  Get.to(() => TambahTypeKendaraan(
                      model: model, controller: tambahTypeMotorController));
                } else if (model.status == 3) {
                  print('..INI BAKALAN KE AKSESORIS..');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Aksesoris(model: model);
                    },
                  );
                }
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
              onType: (DoRealisasiModel model) {
                Get.to(
                  () => EditTypeKendaraan(
                    model: model,
                  ),
                );
              },
              onHapus: (DoRealisasiModel model) {},
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            return LayoutBuilder(builder: (_, __) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchRegulerContent();
                      },
                      child: SfDataGrid(
                          source: dataSource,
                          columnWidthMode: ColumnWidthMode.auto,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          rowHeight: 65,
                          onQueryRowHeight: (RowHeightDetails details) {
                            // Sesuaikan indeks dengan data yang sesuai
                            int rowIndex = details.rowIndex -
                                1; // Mengurangi 1 jika ada header

                            var request =
                                dataSource.doRealisasiModel.isNotEmpty &&
                                        rowIndex >= 0 &&
                                        rowIndex <
                                            dataSource.doRealisasiModel.length
                                    ? dataSource.doRealisasiModel[rowIndex]
                                    : null;

                            if (request != null &&
                                (request.status == 3 || request.status == 4)) {
                              return 150.0; // Tinggi row untuk status 4
                            } else {
                              return details.rowHeight; // Tinggi default
                            }
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                            GridColumn(
                                width: columnWidths['User']!,
                                columnName: 'User',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'User',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                            GridColumn(
                                width: columnWidths['Tipe']!,
                                columnName: 'Tipe',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'Tipe',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                          ]),
                    ),
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
