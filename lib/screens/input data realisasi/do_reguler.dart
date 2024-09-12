import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/input data realisasi/do_reguler_source.dart';
import '../../utils/theme/app_colors.dart';
import 'component/aksesoris.dart';
import 'component/batal_jalan.dart';
import 'component/edit_realisasi.dart';
import 'component/edit_type.dart';
import 'component/jumlah_unit.dart';
import 'component/lihat_realisasi.dart';
import 'component/tambah_type_kendaraan.dart';
import 'plant_gabungan.dart';

class DoRegulerScreen extends GetView<DoRegulerController> {
  const DoRegulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tambahTypeMotorController = Get.put(TambahTypeMotorController());
    final editTypeMotorController = Get.put(EditTypeMotorController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRegulerContent();
    });

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': double.nan,
      'Tgl': 130,
      'Supir(Panggilan)': 200,
      'Kendaraan': 120,
      'Tipe': double.nan,
      'Jenis': double.nan,
      'Jumlah': double.nan,
      if (controller.rolesLihat == 1) 'Lihat': 150,
      if (controller.rolesJumlah == 1) 'Action': 150,
      if (controller.rolesBatal == 1) 'Batal': 150,
      if (controller.rolesEdit == 1) 'Edit': 150,
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
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                        backgroundColor: AppColors.white,
                        child: LihatRealisasi(model: model));
                  },
                );
              },
              onAction: (DoRealisasiModel model) {
                if (model.status == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return JumlahUnit(model: model);
                    },
                  );
                } else if (model.status == 1 || model.status == 2) {
                  Get.to(() => TambahTypeKendaraan(
                      model: model, controller: tambahTypeMotorController));
                } else if (model.status == 3) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Aksesoris(model: model);
                    },
                  );
                } else if (model.status == 4) {
                  Get.to(() => PlantGabungan(model: model));
                }
              },
              onBatal: (DoRealisasiModel model) {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => BatalJalan(model: model));
              },
              onEdit: (DoRealisasiModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditRealisasi(
                      model: model,
                      controller: controller,
                    );
                  },
                );
              },
              onType: (DoRealisasiModel model) {
                Get.to(
                  () => EditTypeKendaraan(
                    model: model,
                    onConfirm: () => editTypeMotorController
                        .editDanHapusTypeMotorReguler(model.id),
                  ),
                );
              },
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            // print('ini banyaknya columns : ${columnWidths.length}');

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
                          int rowIndex = details.rowIndex - 1;

                          if (rowIndex < 0 ||
                              rowIndex >= dataSource.rows.length) {
                            return details.rowHeight;
                          }

                          var request =
                              dataSource.doRealisasiModel.isNotEmpty &&
                                      (rowIndex + dataSource.startIndex) <
                                          dataSource.doRealisasiModel.length
                                  ? dataSource.doRealisasiModel[
                                      rowIndex + dataSource.startIndex]
                                  : null;

                          if (request != null) {
                            if (controller.isAdmin &&
                                (request.status == 2 ||
                                    request.status == 3 ||
                                    request.status == 4)) {
                              return 150.0;
                            } else {
                              return 65.0;
                            }
                          } else {
                            return details.rowHeight;
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
                          if (controller.rolesLihat == 1)
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
                          if (controller.rolesJumlah == 1)
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
                          if (controller.rolesBatal == 1)
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
                          if (controller.rolesEdit == 1)
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
          }
        },
      ),
    );
  }
}
