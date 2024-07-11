import 'package:doplsnew/controllers/input%20data%20do/do_tambah_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/loader/animation_loader.dart';
import 'package:doplsnew/utils/source/data_do_tambah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class InputDataDoTambahan extends GetView<DataDoTambahanController> {
  const InputDataDoTambahan({super.key});

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
          'Input DO Tambahan',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingGlobal.value &&
            controller.doTambahModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.doTambahModel.isEmpty) {
          return GestureDetector(
            onTap: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: const Text('Input DO Harian'),
                  contentWidget: AddDOTambahan(
                    controller: controller,
                  ),
                  onConfirm: () {
                    if (controller.tgl.value.isEmpty) {
                      SnackbarLoader.errorSnackBar(
                        title: 'Gagal😪',
                        message: 'Pastikan tanggal telah di isi 😁',
                      );
                    } else {
                      controller.addDataDoTambah();
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
          final dataSource = DataDoTambahSource(
            doTambah: controller.doTambahModel,
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
                                    titleWidget: const Text('Input DO Harian'),
                                    contentWidget: AddDOTambahan(
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
                                        controller.addDataDoTambah();
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
                                'Tambahkan data DO Harian',
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
                      pageCount: (controller.doTambahModel.length / rowsPerPage)
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

class AddDOTambahan extends StatelessWidget {
  const AddDOTambahan({super.key, required this.controller});

  final DataDoTambahanController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
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
                              newSelectedDate.toLocal().toString();
                        }
                      });
                    },
                    icon: const Icon(Iconsax.calendar),
                  ),
                  hintText: controller.tgl.value.isNotEmpty
                      ? DateFormat.yMMMMd('id_ID').format(
                          DateTime.tryParse(controller.tgl.value) ??
                              DateTime.now(),
                        )
                      : 'Tanggal',
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            Obx(
              () => DropDownWidget(
                value: controller.plant.value,
                items: controller.tujuanMap.keys.toList(),
                onChanged: (String? value) {
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
            TextFormField(
              controller: controller.srdController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field samarinda harus di isi';
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
                  return 'Field makasar harus di isi';
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
                  return 'Field pontianak harus di isi';
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
                  return 'Field banjarmasin harus di isi';
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
