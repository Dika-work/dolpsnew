import 'package:doplsnew/models/input%20data%20realisasi/request_kendaraan_model.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/source/input%20data%20realisasi/request_mobil_source.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../helpers/helper_function.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../widgets/dropdown.dart';

class RequestKendaraanScreen extends GetView<RequestKendaraanController> {
  const RequestKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Pengurus': double.nan,
      'Tanggal': 130,
      'Jam': 150,
      'Plant': double.nan,
      'Tujuan': double.nan,
      'Type': double.nan,
      'Jenis': double.nan,
      'Jumlah': double.nan,
      'Lihat': 50,
      'Kirim': 50,
      'Edit': 50,
      'Hapus': 50,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Kendaraan Honda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isRequestLoading.value &&
              controller.requestKendaraanModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.requestKendaraanModel.isEmpty) {
            return GestureDetector(
              onTap: () {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Tambah Request Kendaraan'),
                    contentWidget: AddRequestKendaraan(
                      controller: controller,
                    ),
                    onConfirm: () {
                      if (controller.tgl.value.isEmpty) {
                        SnackbarLoader.errorSnackBar(
                          title: 'Gagal😪',
                          message: 'Pastikan tanggal telah di isi 😁',
                        );
                      } else {
                        controller.addRequestKendaraan();
                      }
                    },
                    cancelText: 'Close',
                    confirmText: 'Tambahkan');
              },
              child: CustomAnimationLoaderWidget(
                text: 'Tambahkan Data Baru',
                animation: 'assets/animations/add-data-animation.json',
                height: CustomHelperFunctions.screenHeight() * 0.4,
                width: CustomHelperFunctions.screenHeight(),
              ),
            );
          } else {
            final dataSource = RequestMobilSource(
              onLihat: (RequestKendaraanModel model) {
                // CustomDialogs.defaultDialog(
                //     context: context,
                //     titleWidget: Text(
                //       'Detail request kendaraan',
                //       style: Theme.of(context).textTheme.headlineMedium,
                //     ),
                //     contentWidget: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Center(
                //           child: Text('Detail request kendaraan'),
                //         ),
                //         Text('Testing aja')
                //       ],
                //     ),
                //     confirmText: 'Oke');
                print('..INI LIHAT REQUEST MOBIL..');
              },
              onKirim: (RequestKendaraanModel model) {
                print('...INI KIRIM REQUEST KENDARAAN...');
              },
              onEdit: (RequestKendaraanModel model) {
                print('...INI EDIT REQUEST KENDARAAN...');
              },
              onHapus: (RequestKendaraanModel model) {
                print('...INI HAPUS REQUEST KENDARAAN...');
              },
              requestKendaraanModel: controller.requestKendaraanModel,
              startIndex: currentPage * rowsPerPage,
            );
            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        CustomDialogs.defaultDialog(
                            context: context,
                            titleWidget: const Text('Tambah Request Kendaraan'),
                            contentWidget: AddRequestKendaraan(
                              controller: controller,
                            ),
                            onConfirm: () {
                              if (controller.tgl.value.isEmpty) {
                                SnackbarLoader.errorSnackBar(
                                  title: 'Gagal😪',
                                  message: 'Pastikan tanggal telah di isi 😁',
                                );
                              } else {
                                controller.addRequestKendaraan();
                              }
                            },
                            cancelText: 'Close',
                            confirmText: 'Tambahkan');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const IconButton(
                              onPressed: null, icon: Icon(Iconsax.add_circle)),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: CustomSize.sm),
                            child: Text(
                              'Tambah data',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          )
                        ],
                      ),
                    ),
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
                            width: columnWidths['Pengurus']!,
                            columnName: 'Pengurus',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Pengurus',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            width: columnWidths['Tanggal']!,
                            columnName: 'Tanggal',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Tanggal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            width: columnWidths['Jam']!,
                            columnName: 'Jam',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Jam',
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
                            width: columnWidths['Kirim']!,
                            columnName: 'Kirim',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Kirim',
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
                      ],
                    )),
                    SfDataPager(
                      delegate: dataSource,
                      pageCount: (controller.requestKendaraanModel.length /
                              rowsPerPage)
                          .ceilToDouble(),
                      direction: Axis.horizontal,
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

class AddRequestKendaraan extends StatelessWidget {
  const AddRequestKendaraan({super.key, required this.controller});

  final RequestKendaraanController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.requestKendaraanKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      DateTime? selectedDate =
                          DateTime.tryParse(controller.tgl.value);
                      showDatePicker(
                        context: context,
                        locale: const Locale("id", "ID"),
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1850),
                        lastDate: DateTime(2040),
                      ).then((newSelectedDate) {
                        if (newSelectedDate != null) {
                          controller.tgl.value =
                              CustomHelperFunctions.getFormattedDateDatabase(
                                  newSelectedDate);
                          print(
                              'Ini tanggal yang dipilih : ${controller.tgl.value}');
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                  hintText: controller.tgl.value.isNotEmpty
                      ? DateFormat.yMMMMd('id_ID').format(
                          DateTime.tryParse(
                                  '${controller.tgl.value} 00:00:00') ??
                              DateTime.now(),
                        )
                      : 'Tanggal',
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Text('Hari ini jam : ${CustomHelperFunctions.formattedTime}'),
            const Text('Type DO'),
            Obx(
              () => DropDownWidget(
                value: controller.typeDO.value,
                items: controller.typeDOMap.keys.toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.typeDO.value = newValue;
                    print(
                        'ini value dari typeDO ${controller.typeDOValue.value}');
                  }
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            Obx(
              () => DropDownWidget(
                value: controller.plant.value,
                items: controller.tujuanMap.keys.toList(),
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  controller.plant.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: controller.tujuanDisplayValue,
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah DO Harian'),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: controller.jumlahHarian.toString(),
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis'),
            Obx(
              () => DropDownWidget(
                value: controller.jenisKendaraan.value,
                items: controller.jenisKendaraanList,
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  controller.jenisKendaraan.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.jumlahKendaraanController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah kendaraan harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.truck),
                hintText: 'Jumlah Kendaraan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
