import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../helpers/connectivity.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/tampil seluruh data source/all_reguler_source.dart';
import '../../utils/theme/app_colors.dart';
import '../input data realisasi/component/aksesoris.dart';
import '../input data realisasi/component/edit_realisasi_all.dart';
import '../input data realisasi/component/edit_type.dart';
import '../input data realisasi/component/jumlah_unit.dart';
import '../input data realisasi/component/lihat_realisasi.dart';
import '../input data realisasi/component/tambah_type_all_kendaraan.dart';

class DoRegulerAll extends GetView<DoRegulerController> {
  const DoRegulerAll({super.key});

  @override
  Widget build(BuildContext context) {
    final networkConn = Get.find<NetworkManager>();
    final tambahTypeMotorController = Get.put(TambahTypeMotorController());
    final editTypeMotorController = Get.put(EditTypeMotorController());
    final RxBool isConnected = true.obs;
    final RxBool hasFetchedData = false.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await networkConn.isConnected()) {
        isConnected.value = false;
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
        return;
      }
      isConnected.value = true;
      if (!hasFetchedData.value) {
        await controller.fetchRegulerAllContent(); // Hanya panggil sekali
        controller.scrollController.addListener(controller.scrollListener);
        hasFetchedData.value = true; // Update flag setelah fetching
      }
    });

    late Map<String, double> columnWidths = {
      'No': 50,
      'Plant': 60,
      'Tgl': 70,
      'Supir(Panggilan)': 140,
      'Kendaraan': 100,
      'Tipe': 50,
      'Jenis': 60,
      'Jml': 50,
      if (controller.rolesLihat == 1) 'Lihat': 120,
      if (controller.rolesJumlah == 1) 'Action': 120,
      if (controller.rolesEdit == 1) 'Edit': 120,
    };

    // const int rowsPerPage = 10;
    // int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Semua Reguler DO LPS',
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
          if (controller.isLoadingRegulerAll.value &&
              controller.doRealisasiModelAll.isEmpty) {
            return const CustomCircularLoader();
          } else {
            final dataSource = DoRegulerAllSource(
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
                  Get.to(() => TambahTypeAllKendaraan(
                      model: model, controller: tambahTypeMotorController));
                } else if (model.status == 3) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Aksesoris(model: model);
                    },
                  );
                }
              },
              onBatal: (DoRealisasiModel model) {},
              onEdit: (DoRealisasiModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditAllRealisasi(
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
                        .editDanHapusTypeMotorAllReguler(model.id),
                  ),
                );
              },
              doRealisasiModelAll: controller.displayedData,
              // startIndex: currentPage * rowsPerPage,
            );

            // print('ini banyaknya columns : ${columnWidths.length}');
            // for (var i = 0; i < columnWidths.length; i++) {
            //   print("Column ${i + 1}: ${columnWidths.keys.elementAt(i)}");
            // }

            return StreamBuilder<ConnectivityResult>(
              stream: networkConn.connectionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final connectionStatus = snapshot.data;

                  if (connectionStatus == ConnectivityResult.none) {
                    isConnected.value = false;
                  } else {
                    isConnected.value = true;
                    print(('koneksi tersambung'));
                    if (!hasFetchedData.value) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        controller.fetchRegulerAllContent(
                          startDate: controller.startPickDate.value,
                          endDate: controller.endPickDate.value,
                        );
                        hasFetchedData.value = true; // Set flag true
                      });
                    }
                  }
                }
                return isConnected.value
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(CustomSize.sm),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Obx(() => TextFormField(
                                        keyboardType: TextInputType.none,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                locale:
                                                    const Locale("id", "ID"),
                                                initialDate: controller
                                                        .startPickDate.value ??
                                                    DateTime.now(),
                                                firstDate: DateTime(1850),
                                                lastDate: DateTime(2040),
                                              ).then((newSelectedDate) {
                                                if (newSelectedDate != null) {
                                                  controller.startPickDate
                                                      .value = newSelectedDate;
                                                  print(
                                                      'ini tanggal yang di pilih ${controller.startPickDate.value}');
                                                }
                                              });
                                            },
                                            icon: const Icon(Iconsax.calendar),
                                          ),
                                          // Reactive hintText, updates when startPickDate is set
                                          hintText: controller
                                                      .startPickDate.value !=
                                                  null
                                              ? CustomHelperFunctions
                                                  .getFormattedDate(controller
                                                      .startPickDate.value!)
                                              : 'Tgl Awal...',
                                        ),
                                      )),
                                ),
                                const SizedBox(width: CustomSize.sm),
                                Expanded(
                                  flex: 2,
                                  child: Obx(() => TextFormField(
                                        keyboardType: TextInputType.none,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                locale:
                                                    const Locale("id", "ID"),
                                                initialDate: controller
                                                        .endPickDate.value ??
                                                    DateTime.now(),
                                                firstDate: DateTime(1850),
                                                lastDate: DateTime(2040),
                                              ).then((newSelectedDate) {
                                                if (newSelectedDate != null) {
                                                  controller.endPickDate.value =
                                                      newSelectedDate;
                                                  print(
                                                      'ini tanggal yang di pilih ${controller.endPickDate.value}');
                                                }
                                              });
                                            },
                                            icon: const Icon(Iconsax.calendar),
                                          ),
                                          // Reactive hintText, updates when endPickDate is set
                                          hintText: controller
                                                      .endPickDate.value !=
                                                  null
                                              ? CustomHelperFunctions
                                                  .getFormattedDate(controller
                                                      .endPickDate.value!)
                                              : 'Tgl Akhir...',
                                        ),
                                      )),
                                ),
                                const SizedBox(width: CustomSize.sm),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (controller.startPickDate.value !=
                                            null &&
                                        controller.endPickDate.value != null) {
                                      if (controller.startPickDate.value!
                                          .isAfter(
                                              controller.endPickDate.value!)) {
                                        SnackbarLoader.errorSnackBar(
                                          title: 'Oops😪',
                                          message:
                                              'Tanggal mulai tidak boleh melebihi tanggal akhir',
                                        );
                                      } else {
                                        await controller.fetchRegulerAllContent(
                                          startDate:
                                              controller.startPickDate.value,
                                          endDate: controller.endPickDate.value,
                                        );
                                      }
                                    } else {
                                      SnackbarLoader.errorSnackBar(
                                        title: 'Oops😒',
                                        message:
                                            'Harap pilih tanggal terlebih dahulu',
                                      );
                                    }
                                  },
                                  child: const Text('Filter'),
                                ),
                                if (controller.startPickDate.value != null &&
                                    controller.endPickDate.value != null)
                                  const SizedBox(width: CustomSize.sm),
                                if (controller.startPickDate.value != null &&
                                    controller.endPickDate.value != null)
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          controller.resetFilterDate(),
                                      child: const Text('Reset'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                if (!await networkConn.isConnected()) {
                                  isConnected.value = false;
                                  return;
                                }
                                isConnected.value = true;
                                if (!hasFetchedData.value) {
                                  await controller
                                      .fetchRegulerAllContent(); // Hanya panggil sekali
                                  hasFetchedData.value =
                                      true; // Update flag setelah fetching
                                }
                              },
                              child: SfDataGrid(
                                  source: dataSource,
                                  frozenColumnsCount: 2,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  rowHeight: 65,
                                  verticalScrollController:
                                      controller.scrollController,
                                  onQueryRowHeight: (RowHeightDetails details) {
                                    int rowIndex = details.rowIndex - 1;

                                    if (rowIndex < 0 ||
                                        rowIndex >= dataSource.rows.length) {
                                      return details.rowHeight;
                                    }

                                    var request = dataSource.doRealisasiModelAll
                                                .isNotEmpty &&
                                            rowIndex
                                                // (rowIndex + dataSource.startIndex)
                                                <
                                                dataSource
                                                    .doRealisasiModelAll.length
                                        ? dataSource
                                            .doRealisasiModelAll[rowIndex]
                                        // ? dataSource.doRealisasiModelAll[
                                        //     rowIndex + dataSource.startIndex]
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
                                      return 60.0;
                                    }
                                  },
                                  columns: [
                                    GridColumn(
                                        width: columnWidths['No']!,
                                        columnName: 'No',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'No',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Plant']!,
                                        columnName: 'Plant',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Plant',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Tgl']!,
                                        columnName: 'Tgl',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Tgl',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width:
                                            columnWidths['Supir(Panggilan)']!,
                                        columnName: 'Supir(Panggilan)',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Supir(Panggilan)',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Kendaraan']!,
                                        columnName: 'Kendaraan',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Kendaraan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Tipe']!,
                                        columnName: 'Tipe',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Tipe',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Jenis']!,
                                        columnName: 'Jenis',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Jenis',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Jml']!,
                                        columnName: 'Jml',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Jml',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    if (controller.rolesLihat == 1)
                                      GridColumn(
                                          width: columnWidths['Lihat']!,
                                          columnName: 'Lihat',
                                          label: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color:
                                                    Colors.lightBlue.shade100,
                                              ),
                                              child: Text(
                                                'Lihat',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ))),
                                    if (controller.rolesJumlah == 1)
                                      GridColumn(
                                          width: columnWidths['Action']!,
                                          columnName: 'Action',
                                          label: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color:
                                                    Colors.lightBlue.shade100,
                                              ),
                                              child: Text(
                                                'Action',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ))),
                                    if (controller.rolesEdit == 1)
                                      GridColumn(
                                          width: columnWidths['Edit']!,
                                          columnName: 'Edit',
                                          label: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color:
                                                    Colors.lightBlue.shade100,
                                              ),
                                              child: Text(
                                                'Edit',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ))),
                                  ]),
                            ),
                          ),
                          if (controller.isLoadingMore
                              .value) // Loader di bawah ketika lazy loading
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          // SfDataPager(
                          //   delegate: dataSource,
                          //   pageCount: controller.doRealisasiModelAll.isEmpty
                          //       ? 1
                          //       : (controller.doRealisasiModelAll.length / rowsPerPage)
                          //           .ceilToDouble(),
                          //   direction: Axis.horizontal,
                          // ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomAnimationLoaderWidget(
                            text:
                                'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
                            animation: 'assets/animations/404.json',
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () async {
                              // Coba refresh dan cek koneksi kembali
                              if (await networkConn.isConnected()) {
                                await controller.fetchRegulerAllContent(
                                  startDate: controller.startPickDate.value,
                                  endDate: controller.endPickDate.value,
                                );
                              } else {
                                SnackbarLoader.errorSnackBar(
                                  title: 'Tidak ada internet',
                                  message:
                                      'Silahkan coba lagi setelah koneksi tersedia',
                                );
                              }
                            },
                            child: const Text('Refresh'),
                          ),
                        ],
                      );
              },
            );
          }
        },
      ),
    );
  }
}
