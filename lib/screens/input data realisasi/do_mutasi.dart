import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data realisasi/do_mutasi_source.dart';
import '../../utils/theme/app_colors.dart';
import 'component/batal_jalan.dart';
import 'component/edit_realisasi_mutasi.dart';
import 'component/edit_type.dart';
import 'component/jumlah_unit.dart';
import 'component/lihat_realisasi.dart';
import 'component/tambah_type_motor_mutasi.dart';
import 'component/terima_motor_mutasi.dart';

class DoMutasiScreen extends GetView<DoMutasiController> {
  const DoMutasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editTypeMotorController = Get.put(EditTypeMotorController());
    final tambahTypeMotorController =
        Get.put(TambahTypeMotorMutasiController());
    final networkConn = Get.find<NetworkManager>();

    final RxBool isConnected = true.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final connectionStatus = await networkConn.isConnected();
      if (!connectionStatus) {
        isConnected.value = false;
        print("Internet Terputus");
        SnackbarLoader.errorSnackBar(
          title: 'Tidak Ada Koneksi Internet',
          message: 'Silakan periksa koneksi internet anda dan coba lagi',
        );
        return; // Jika tidak ada koneksi, batalkan refresh
      }

      isConnected.value = true;
      controller.fetchMutasiContent();
    });

    late Map<String, double> columnWidths = {
      'No': 50,
      'Tujuan': 100,
      'Plant': 60,
      'Tipe': 50,
      'Tgl': 70,
      'Supir(Panggilan)': 140,
      'Kendaraan': 100,
      'Jenis': 60,
      'Jml': 50,
      if (controller.rolesLihat == 1) 'Lihat': 120,
      if (controller.rolesJumlah == 1) 'Action': 120,
      if (controller.rolesEdit == 1) 'Edit': 120,
      if (controller.rolesBatal == 1) 'Batal': 120,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mutasi DO LPS',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (!isConnected.value) {
            return const CustomAnimationLoaderWidget(
                text:
                    'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
                animation: 'assets/animations/404.json');
          } else if (controller.isLoadingMutasi.value &&
              controller.doRealisasiModel.isEmpty) {
            return const CustomCircularLoader();
          } else {
            final dataSource = DoMutasiSource(
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
                print('..INI BAKALAN KE CLASS LIHAT REALISASI MUTASI..');
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
                  Get.to(() => TambahTypeMotorMutasi(
                        model: model,
                        controller: tambahTypeMotorController,
                      ));
                  print('...INI BAKALAN KE TYPE MOTOR MUTASI CLASS...');
                } else if (model.status == 3) {
                  print('..INI BAKALAN KE TerimaMotorMutasi..');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TerimaMotorMutasi(model: model);
                    },
                  );
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
                    return EditRealisasiMutasi(
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
                        .editDanHapusTypeMotorMutasi(model.id),
                  ),
                );
              },
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchMutasiContent();
                    },
                    child: SfDataGrid(
                        source: dataSource,
                        frozenColumnsCount: 2,
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
                                      (dataSource.startIndex + rowIndex) <
                                          dataSource.doRealisasiModel.length
                                  ? dataSource.doRealisasiModel[
                                      dataSource.startIndex + rowIndex]
                                  : null;

                          if (request != null) {
                            if (controller.roleUser == 'admin' &&
                                (request.status == 2 ||
                                    request.status == 3 ||
                                    request.status == 5)) {
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
                              width: columnWidths['Jml']!,
                              columnName: 'Jml',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Jml',
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
                          if (controller.rolesJumlah == 1 && controller.isAdmin)
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
