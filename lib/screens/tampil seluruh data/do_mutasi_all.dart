import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/input data realisasi/do_mutasi_source.dart';
import '../../utils/theme/app_colors.dart';
import '../input data realisasi/component/edit_realisasi_mutasi.dart';
import '../input data realisasi/component/jumlah_unit.dart';
import '../input data realisasi/component/lihat_realisasi.dart';
import '../input data realisasi/component/tambah_type_motor_mutasi.dart';

class DoMutasiAll extends GetView<DoMutasiController> {
  const DoMutasiAll({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Tujuan': double.nan,
      'Plant': double.nan,
      'Tipe': double.nan,
      'Tgl': double.nan,
      'Supir(Panggilan)': 200,
      'Kendaraan': double.nan,
      'Jenis': double.nan,
      'Jumlah': double.nan,
      'Lihat': 150,
      'Action': 150,
      'Batal': 150,
      'Edit': 150,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Mutasi DO LPS',
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
              onLihat: (DoRealisasiModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        backgroundColor: AppColors.white,
                        child: LihatRealisasi(model: model));
                  },
                );
                print('..INI BAKALAN KE CLASS LIHAT REALISASI MUTASI..');
              },
              onAction: (DoRealisasiModel model) {
                final tambahTypeMotorController =
                    Get.put(TambahTypeMotorMutasiController());
                if (model.status == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return JumlahUnit(model: model);
                    },
                  );
                } else if (model.status == 1 || model.status == 2) {
                  tambahTypeMotorController
                      .fetchTambahTypeMotorMutasi(model.id);
                  Get.to(() => TambahTypeMotorMutasi(
                      model: model, controller: tambahTypeMotorController));
                  print('...INI BAKALAN KE TYPE MOTOR MUTASI CLASS...');
                } else if (model.status == 3) {
                  print('..INI BAKALAN KE TerimaMotorMutasi..');
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return TerimaMotorMutasi();
                  //   },
                  // );
                }
              },
              onBatal: (DoRealisasiModel model) {},
              onEdit: (DoRealisasiModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditRealisasiMutasi(
                      model: model,
                      controller: controller,
                    );
                  },
                );
              },
              onType: (DoRealisasiModel model) {
                print('..INI BTN ON TYPE..');
              },
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            return LayoutBuilder(builder: (_, __) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchMutasiContent();
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
                                (request.status == 2 || request.status == 3)) {
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
