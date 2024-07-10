import 'package:doplsnew/controllers/input%20data%20do/do_harian_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:doplsnew/utils/source/data_do_harian_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class InputDataDoHarian extends GetView<DataDoHarianController> {
  const InputDataDoHarian({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': double.nan,
      'Tujuan': double.nan,
      'Tanggal': double.nan,
      'Jam': double.nan,
      'HSO - SRD': double.nan,
      'HSO - MKS': double.nan,
      'HSO - PTK': double.nan,
      'BJM': double.nan,
      'Jumlah 5': double.nan,
      'Jumlah 6': double.nan,
      'User': double.nan
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input DO Harian',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingHarian.value &&
            controller.doHarianModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.doHarianModel.isEmpty) {
          return Center(
            child: Text(
              'Data DO Harian Tidak Tersedia',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomSize.md, vertical: CustomSize.sm),
                  child: Text(
                    'DO GLOBAL TGL : ${CustomHelperFunctions.getFormattedDate(DateTime.now())}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                SfDataGrid(
                  source:
                      DataDoHarianSource(doHarian: controller.doHarianModel),
                  columnWidthMode: ColumnWidthMode.auto,
                  allowPullToRefresh: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  allowColumnsResizing: true,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
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
                                contentWidget: AddDOHarian(
                                  controller: controller,
                                ),
                                onConfirm: controller.AddDataDOHarian,
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
                            'Tambahkan user baru',
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
                    GridColumn(
                        width: columnWidths['Jumlah 5']!,
                        columnName: 'Jumlah 5',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Jumlah 5',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )),
                    GridColumn(
                        width: columnWidths['Jumlah 6']!,
                        columnName: 'Jumlah 6',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Jumlah 6',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )),
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
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class AddDOHarian extends StatelessWidget {
  const AddDOHarian({super.key, required this.controller});

  final DataDoHarianController controller;

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
