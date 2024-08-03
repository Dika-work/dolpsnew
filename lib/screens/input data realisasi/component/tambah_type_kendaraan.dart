import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
        padding: const EdgeInsets.symmetric(
            horizontal: CustomSize.md, vertical: CustomSize.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Plant'),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(text: model.plant),
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CustomSize.spaceBtwItems),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tujuan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    controller: TextEditingController(text: model.tujuan),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tipe'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    controller: TextEditingController(
                        text: model.type == 0 ? 'REGULER' : 'MUTASI'),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              ),
            ),
            const SizedBox(width: CustomSize.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jenis'),
                  TextFormField(
                    controller: TextEditingController(
                        text: '${model.inisialDepan}${model.inisialBelakang}'),
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('No Kendaraan'),
          TextFormField(
            controller: TextEditingController(text: model.noPolisi),
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          TextFormField(
            controller: TextEditingController(text: model.supir),
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Unit Motor'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.jumlahUnit.toString()),
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CustomSize.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Plot'),
                    TextFormField(
                      controller: TextEditingController(text: 'Total plot'),
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
            ],
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
          ValueListenableBuilder<TabDaerahTujuan>(
            valueListenable: selectedDaerahTujuan,
            builder: (_, value, __) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Tab selector
                    Row(
                      children: TabDaerahTujuan.values.map((tab) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectedDaerahTujuan.value = tab;
                            },
                            child: Container(
                              padding: const EdgeInsets.all(CustomSize.sm),
                              decoration: BoxDecoration(
                                color: value == tab
                                    ? AppColors.grey
                                    : AppColors.white,
                                border: BorderDirectional(
                                  top: BorderSide(
                                    color: value == tab
                                        ? AppColors.primary
                                        : AppColors.buttonDisabled,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab.toString().split('.').last.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: value == tab
                                          ? FontWeight.w400
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    // ListView for form fields
                    Obx(() {
                      final fields = controller
                              .formFieldsPerTab[selectedDaerahTujuan.value] ??
                          [];
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fields.length,
                        itemBuilder: (context, index) {
                          return DynamicFormFieldHonda(
                            index: index,
                            tab: selectedDaerahTujuan.value,
                            data: fields[index],
                            onDropdownChanged: (value) {
                              controller
                                  .formFieldsPerTab[selectedDaerahTujuan.value]
                                      ?[index]
                                  .dropdownValue = value;
                            },
                            onTextFieldChanged: (value) {
                              controller
                                  .formFieldsPerTab[selectedDaerahTujuan.value]
                                      ?[index]
                                  .textFieldValue = value;
                            },
                            onRemove: () {
                              controller.removeField(
                                  selectedDaerahTujuan.value, index);
                            },
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: CustomSize.spaceBtwItems),
                      );
                    }),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.addField(selectedDaerahTujuan.value);
                            },
                            child: const Icon(Iconsax.add),
                          ),
                        ),
                        const SizedBox(width: CustomSize.sm),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              controller
                                  .resetFields(selectedDaerahTujuan.value);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error),
                            child: const Icon(FontAwesomeIcons.trash),
                          ),
                        ),
                        const SizedBox(width: CustomSize.sm),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () {
                              controller
                                  .resetFields(selectedDaerahTujuan.value);
                            },
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                backgroundColor: AppColors.success),
                            child: const Text('Selesai'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum TabDaerahTujuan { srd, mks, ptk, bjm }
