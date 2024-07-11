import 'package:doplsnew/controllers/input%20data%20do/do_global_controller.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../helpers/helper_function.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/data_do_global_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class InputDataDOGlobal extends GetView<DataDOGlobalController> {
  const InputDataDOGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': double.nan,
      'Tujuan': 130,
      'Tanggal': 150,
      'HSO - SRD': double.nan,
      'HSO - MKS': double.nan,
      'HSO - PTK': double.nan,
      'BJM': double.nan,
    };

    const double dataPagerHeight = 60.0;
    const int rowsPerPage = 7;

    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input DO Global',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingGlobal.value &&
            controller.doGlobalModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.doGlobalModel.isEmpty) {
          return GestureDetector(
            onTap: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: const Text('Input DO Global'),
                  contentWidget: AddDOGlobal(
                    controller: controller,
                  ),
                  onConfirm: () {
                    if (controller.tgl.value.isEmpty) {
                      SnackbarLoader.errorSnackBar(
                        title: 'Gagal😪',
                        message: 'Pastikan tanggal telah di isi 😁',
                      );
                    } else {
                      controller.addDataDOGlobal();
                    }
                  },
                  onCancel: () {
                    Get.back();
                    controller.tgl.value = '';
                    controller.plant.value = '1100';
                    controller.tujuan.value = '1';
                    controller.srdController.clear();
                    controller.mksController.clear();
                    controller.ptkController.clear();
                    controller.bjmController.clear();
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
          final dataSource = DataDoGlobalSource(
            doGlobal: controller.doGlobalModel,
            startIndex: currentPage * rowsPerPage,
          );
          return LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  SizedBox(
                    height: constraint.maxHeight - dataPagerHeight,
                    width: constraint.maxWidth,
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
                      footer: Container(
                        color: AppColors.primary,
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                CustomDialogs.defaultDialog(
                                    context: context,
                                    titleWidget: const Text('Input DO Global'),
                                    contentWidget: AddDOGlobal(
                                      controller: controller,
                                    ),
                                    onConfirm: () {
                                      if (controller.tgl.value.isEmpty) {
                                        SnackbarLoader.errorSnackBar(
                                          title: 'Gagal😪',
                                          message:
                                              'Pastikan tanggal telah di isi 😁',
                                        );
                                      } else {
                                        controller.addDataDOGlobal();
                                      }
                                    },
                                    onCancel: () {
                                      Get.back();
                                      controller.tgl.value = '';
                                      controller.plant.value = '1100';
                                      controller.tujuan.value = '1';
                                      controller.srdController.clear();
                                      controller.mksController.clear();
                                      controller.ptkController.clear();
                                      controller.bjmController.clear();
                                    },
                                    cancelText: 'Close',
                                    confirmText: 'Tambahkan');
                              },
                              child: Text(
                                'Tambahkan data DO Global',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.apply(color: AppColors.light),
                              )),
                        ),
                      ),
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
                            width: columnWidths['HSO - SRD']!,
                            columnName: 'HSO - SRD',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'HSO - SRD',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            width: columnWidths['HSO - MKS']!,
                            columnName: 'HSO - MKS',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'HSO - MKS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            )),
                        GridColumn(
                            width: columnWidths['HSO - PTK']!,
                            columnName: 'HSO - PTK',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'HSO - PTK',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            )),
                        GridColumn(
                            width: columnWidths['BJM']!,
                            columnName: 'BJM',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'BJM',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: dataPagerHeight,
                    child: SfDataPager(
                      delegate: dataSource,
                      pageCount: (controller.doGlobalModel.length / rowsPerPage)
                          .ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              );
            },
          );
        }
      }),
    );
  }
}

class AddDOGlobal extends StatelessWidget {
  const AddDOGlobal({super.key, required this.controller});

  final DataDOGlobalController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.addGlobalKey,
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
                          // Hanya ubah nilai tanggal, biarkan waktu tetap default
                          controller.tgl.value =
                              DateFormat('yyyy-MM-dd').format(newSelectedDate);
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
            Obx(
              () => Text(controller.idplant.value),
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
            Obx(() => Text('Tujuan ${controller.tujuanDisplayValue}')),
            Text('Hari ini jam : ${CustomHelperFunctions.formattedTime}'),
            Obx(() => Text('Hari ini tgl : ${controller.tgl.value}')),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.srdController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Samarinda harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'HSO - SRD',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.mksController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Makasar harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'HSO - MKS',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.ptkController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pontianak harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'HSO - PTK',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.bjmController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Banjarmasin harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'BJM',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
