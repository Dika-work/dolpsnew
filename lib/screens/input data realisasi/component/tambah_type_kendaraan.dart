import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/source/input data realisasi/tambah_type_motor_source.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dynamic_formfield.dart';

class TambahTypeKendaraan extends StatelessWidget {
  const TambahTypeKendaraan(
      {super.key, required this.model, required this.controller});

  final DoRealisasiModel model;
  final TambahTypeMotorController controller;

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': double.nan,
      'SRD': double.nan,
      'MKS': double.nan,
      'PTK': double.nan,
      'BJM': double.nan,
    };

    const int rowsPerPage = 10;
    int currentPage = 0;
    const double rowHeight = 25.0;
    const double headerHeight = 32.0;

    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    final selectedDaerahTujuan = ValueNotifier(TabDaerahTujuan.srd);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Type Kendaraan',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
        children: [
          const Text('Tujuan'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.tujuan,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),

          const Text('Plant'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.plant,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Type'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.type == 0 ? 'REGULER' : 'Mutasi',
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jenis'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.jenisKen,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('No Kendaraan'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.noPolisi,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.supir,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jumlah Total Unit Motor'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                hintText: model.jumlahUnit.toString(),
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Total Plot'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: const InputDecoration(
                hintText: 'total plot',
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
          // table nya
          Obx(
            () {
              if (controller.isLoadingTambahType.value &&
                  controller.tambahTypeMotorModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = TambahTypeMotorSource(
                  tambahTypeMotorModel: controller.tambahTypeMotorModel,
                  startIndex: currentPage * rowsPerPage,
                );

                return Column(
                  children: [
                    SizedBox(
                      height: gridHeight,
                      child: SfDataGrid(
                          source: dataSource,
                          columnWidthMode: ColumnWidthMode.auto,
                          allowPullToRefresh: true,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          verticalScrollPhysics:
                              const NeverScrollableScrollPhysics(),
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
                                width: columnWidths['Type Motor']!,
                                columnName: 'Type Motor',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'Type Motor',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                            GridColumn(
                                width: columnWidths['SRD']!,
                                columnName: 'SRD',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'SRD',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                            GridColumn(
                                width: columnWidths['MKS']!,
                                columnName: 'MKS',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'MKS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                            GridColumn(
                                width: columnWidths['PTK']!,
                                columnName: 'PTK',
                                label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'PTK',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                          ]),
                    ),
                    SfDataPager(
                      delegate: dataSource,
                      pageCount: controller.tambahTypeMotorModel.isEmpty
                          ? 1
                          : (controller.tambahTypeMotorModel.length /
                                  rowsPerPage)
                              .ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
          // textformfield srd, mks, ptk, bjm
          ValueListenableBuilder<TabDaerahTujuan>(
            valueListenable: selectedDaerahTujuan,
            builder: (_, value, ___) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.resetAllFields();
              });
              return SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    // srd
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedDaerahTujuan.value = TabDaerahTujuan.srd;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(CustomSize.sm),
                          decoration: BoxDecoration(
                              color: value == TabDaerahTujuan.srd
                                  ? AppColors.grey
                                  : AppColors.white,
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: value == TabDaerahTujuan.srd
                                          ? AppColors.primary
                                          : AppColors.buttonDisabled))),
                          child: Text(
                            'SRD',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: value == TabDaerahTujuan.srd
                                        ? FontWeight.w400
                                        : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    // mks
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedDaerahTujuan.value = TabDaerahTujuan.mks;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(CustomSize.sm),
                          decoration: BoxDecoration(
                              color: value == TabDaerahTujuan.mks
                                  ? AppColors.grey
                                  : AppColors.white,
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: value == TabDaerahTujuan.mks
                                          ? AppColors.primary
                                          : AppColors.buttonDisabled))),
                          child: Text(
                            'MKS',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: value == TabDaerahTujuan.mks
                                        ? FontWeight.w400
                                        : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    // ptk
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedDaerahTujuan.value = TabDaerahTujuan.ptk;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(CustomSize.sm),
                          decoration: BoxDecoration(
                              color: value == TabDaerahTujuan.ptk
                                  ? AppColors.grey
                                  : AppColors.white,
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: value == TabDaerahTujuan.ptk
                                          ? AppColors.primary
                                          : AppColors.buttonDisabled))),
                          child: Text(
                            'PTK',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: value == TabDaerahTujuan.ptk
                                        ? FontWeight.w400
                                        : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    // bjm
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedDaerahTujuan.value = TabDaerahTujuan.bjm;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(CustomSize.sm),
                          decoration: BoxDecoration(
                              color: value == TabDaerahTujuan.bjm
                                  ? AppColors.grey
                                  : AppColors.white,
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: value == TabDaerahTujuan.bjm
                                          ? AppColors.primary
                                          : AppColors.buttonDisabled))),
                          child: Text(
                            'BJM',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: value == TabDaerahTujuan.bjm
                                        ? FontWeight.w400
                                        : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // body value Listenable builder
          const SizedBox(height: CustomSize.spaceBtwSections),
          ValueListenableBuilder<TabDaerahTujuan>(
            valueListenable: selectedDaerahTujuan,
            builder: (_, value, __) {
              switch (value) {
                case TabDaerahTujuan.srd:
                  return Column(
                    children: [
                      Obx(() {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.formFields.length,
                          itemBuilder: (context, index) {
                            return DynamicFormFieldHonda(
                              index: index,
                              data: controller.formFields[index],
                              onDropdownChanged: (value) {
                                controller.formFields[index].dropdownValue =
                                    value;
                              },
                              onTextFieldChanged: (value) {
                                controller.formFields[index].textFieldValue =
                                    value;
                              },
                              onRemove: () {
                                controller.removeField(index);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: CustomSize.spaceBtwItems),
                        );
                      }),
                      const SizedBox(height: CustomSize.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: controller.addField,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.sm)),
                            child: const Text(
                              'Tambah Jenis\nSRD',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: controller.resetAllFields,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.md)),
                            child: const Text('Reset Jenis'),
                          ),
                        ],
                      ),
                    ],
                  );
                case TabDaerahTujuan.mks:
                  return Column(
                    children: [
                      Obx(() {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.formFields.length,
                          itemBuilder: (context, index) {
                            return DynamicFormFieldHonda(
                              index: index,
                              data: controller.formFields[index],
                              onDropdownChanged: (value) {
                                controller.formFields[index].dropdownValue =
                                    value;
                              },
                              onTextFieldChanged: (value) {
                                controller.formFields[index].textFieldValue =
                                    value;
                              },
                              onRemove: () {
                                controller.removeField(index);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: CustomSize.spaceBtwItems),
                        );
                      }),
                      const SizedBox(height: CustomSize.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: controller.addField,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.sm)),
                            child: const Text(
                              'Tambah Jenis\nMKS',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: controller.resetAllFields,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.md)),
                            child: const Text('Reset Jenis'),
                          ),
                        ],
                      ),
                    ],
                  );
                case TabDaerahTujuan.ptk:
                  return Column(
                    children: [
                      Obx(() {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.formFields.length,
                          itemBuilder: (context, index) {
                            return DynamicFormFieldHonda(
                              index: index,
                              data: controller.formFields[index],
                              onDropdownChanged: (value) {
                                controller.formFields[index].dropdownValue =
                                    value;
                              },
                              onTextFieldChanged: (value) {
                                controller.formFields[index].textFieldValue =
                                    value;
                              },
                              onRemove: () {
                                controller.removeField(index);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: CustomSize.spaceBtwItems),
                        );
                      }),
                      const SizedBox(height: CustomSize.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: controller.addField,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.sm)),
                            child: const Text(
                              'Tambah Jenis\nPTK',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: controller.resetAllFields,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.md)),
                            child: const Text('Reset Jenis'),
                          ),
                        ],
                      ),
                    ],
                  );
                case TabDaerahTujuan.bjm:
                  return Column(
                    children: [
                      Obx(() {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.formFields.length,
                          itemBuilder: (context, index) {
                            return DynamicFormFieldHonda(
                              index: index,
                              data: controller.formFields[index],
                              onDropdownChanged: (value) {
                                controller.formFields[index].dropdownValue =
                                    value;
                              },
                              onTextFieldChanged: (value) {
                                controller.formFields[index].textFieldValue =
                                    value;
                              },
                              onRemove: () {
                                controller.removeField(index);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: CustomSize.spaceBtwItems),
                        );
                      }),
                      const SizedBox(height: CustomSize.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: controller.addField,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.sm)),
                            child: const Text(
                              'Tambah Jenis\nBJM',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: controller.resetAllFields,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(CustomSize.md)),
                            child: const Text('Reset Jenis'),
                          ),
                        ],
                      ),
                    ],
                  );
                default:
                  return Center(
                    child: Text(
                      'Pilih Daerah Tujuan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

enum TabDaerahTujuan { srd, mks, ptk, bjm }
