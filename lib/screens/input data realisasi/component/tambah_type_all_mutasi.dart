import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/popups/snackbar.dart';
import '../../../utils/source/input data realisasi/tambah_type_mutasi_source.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dynamic_formfield.dart';
import 'edit_type.dart';

class TambahTypeAllMotorMutasi extends StatefulWidget {
  const TambahTypeAllMotorMutasi(
      {super.key, required this.model, required this.controller});

  final DoRealisasiModel model;
  final TambahTypeMotorMutasiController controller;

  @override
  State<TambahTypeAllMotorMutasi> createState() =>
      _TambahTypeAllMotorMutasiState();
}

class _TambahTypeAllMotorMutasiState extends State<TambahTypeAllMotorMutasi> {
  late int id;
  late int jumlahMotor;
  final plotRealisasiController = Get.find<PlotRealisasiController>();
  final editTypeMotorController = Get.put(EditTypeMotorController());
  final isExceedingCapacity = false.obs;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    jumlahMotor = widget.model.jumlahUnit;

    // set default untuk plot mutasi
    plotRealisasiController.fetchPlotRealisasi(id, jumlahMotor).then((_) {
      updateExceedingCapacity();
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.controller.fetchTambahTypeMotorMutasi(id).then((_) {
          updateExceedingCapacity();
        });
      },
    );
  }

  void updateExceedingCapacity() {
    if (plotRealisasiController.plotModelRealisasi.isNotEmpty) {
      int totalPlot =
          plotRealisasiController.plotModelRealisasi.first.jumlahPlot;

      final formData = widget.controller.formFields;
      final controllers = widget.controller.textControllers;

      if (formData.isNotEmpty) {
        for (int i = 0; i < formData.length; i++) {
          final textFieldValue = controllers[i].text;
          final jumlah = int.tryParse(textFieldValue) ?? 0;
          totalPlot += jumlah;
        }
      }

      // Periksa apakah total plot melebihi kapasitas motor
      if (totalPlot > jumlahMotor) {
        isExceedingCapacity.value = true;
      } else {
        isExceedingCapacity.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': 150,
      'Jumlah Unit': double.nan,
    };

    int currentPage = 0;
    const int rowsPerPage = 5;
    const double rowHeight = 55.0;
    const double headerHeight = 50.0;

    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Type Motor Honda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
              widget.controller.resetFields();
            }),
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
                      controller:
                          TextEditingController(text: widget.model.plant),
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
                    controller:
                        TextEditingController(text: widget.model.tujuan),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Type'),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(
                          text: widget.model.type == 0 ? 'REGULER' : 'MUTASI'),
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
                  const Text('No Kendaraan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    controller:
                        TextEditingController(text: widget.model.noPolisi),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jenis'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: widget.model.jenisKen),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: widget.model.supir),
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
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(
                          text: widget.model.jumlahUnit.toString()),
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
                    Obx(
                      () => TextFormField(
                        controller: TextEditingController(
                            text: plotRealisasiController
                                    .plotModelRealisasi.isNotEmpty
                                ? plotRealisasiController
                                    .plotModelRealisasi.first.jumlahPlot
                                    .toString()
                                : ''),
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: const InputDecoration(
                            filled: true, fillColor: AppColors.buttonDisabled),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
          // table mutasi nya
          Obx(
            () {
              if (widget.controller.isLoadingMutasi.value &&
                  widget.controller.tambahTypeMotorMutasiModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = TambahTypeMutasiSource(
                    tambahTypeMotorMutasiModel:
                        widget.controller.tambahTypeMotorMutasiModel,
                    startIndex: currentPage * rowsPerPage);

                final bool isTableEmpty =
                    widget.controller.tambahTypeMotorMutasiModel.isEmpty;
                final rowCount =
                    widget.controller.tambahTypeMotorMutasiModel.length + 1;
                final double tableHeight = isTableEmpty
                    ? 110
                    : headerHeight +
                        (rowHeight * rowCount)
                            .clamp(0, gridHeight - headerHeight);

                return SizedBox(
                  height: tableHeight,
                  child: SfDataGrid(
                    source: dataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
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
                          ),
                        ),
                      ),
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
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Jumlah Unit']!,
                        columnName: 'Jumlah Unit',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Jumlah Unit',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          // Listview for formfields
          Obx(() {
            final fields = widget.controller.formFields;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fields.length,
              padding: EdgeInsets.only(
                top: fields.isEmpty ? 0 : CustomSize.spaceBtwSections,
              ),
              itemBuilder: (context, index) {
                return DynamicFormFieldMutasi(
                  index: index,
                  data: fields[index],
                  onDropdownChanged: (value) {
                    widget.controller.formFields[index].dropdownValue = value;
                  },
                  onTextFieldChanged: (value) {
                    widget.controller.formFields[index].textFieldValue = value;
                  },
                  onRemove: () {
                    widget.controller.removeField(index);
                  },
                );
              },
              separatorBuilder: (_, __) =>
                  const SizedBox(height: CustomSize.spaceBtwItems),
            );
          }),

          Obx(() {
            if (isExceedingCapacity.value) {
              return Padding(
                padding: const EdgeInsets.only(top: CustomSize.spaceBtwItems),
                child: Column(
                  children: [
                    Text(
                      'JUMLAH MOTOR\nLEBIH DARI\nKAPASITAS KENDARAAN',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back(); // Kembali ke layar sebelumnya
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 25.0),
                            backgroundColor: AppColors.yellow,
                          ),
                          child: Text(
                            'Kembali',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.apply(color: AppColors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print(
                                '...INI BAKALAN KE CLASS NAME EDIT TYPE zzz...');
                            Get.to(() => EditTypeKendaraan(
                                  model: widget.model,
                                  onConfirm: () => editTypeMotorController
                                      .editDanHapusTypeMotorAllMutasi(id),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 25.0),
                            backgroundColor: AppColors.error,
                          ),
                          child: Text(
                            'Edit Type',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.apply(color: AppColors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.only(top: CustomSize.spaceBtwSections),
                child: Row(
                  children: [
                    Obx(() {
                      print(
                          'isJumlahPlotEqual: ${plotRealisasiController.isJumlahPlotEqual.value}'); // Debugging
                      return Visibility(
                        visible:
                            !plotRealisasiController.isJumlahPlotEqual.value,
                        child: Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.controller.addField();
                            },
                            child: const Icon(Iconsax.add),
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible:
                            !plotRealisasiController.isJumlahPlotEqual.value,
                        child: const SizedBox(width: CustomSize.sm),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible:
                            !plotRealisasiController.isJumlahPlotEqual.value,
                        child: Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.controller.resetFields();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Icon(FontAwesomeIcons.trash),
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible:
                            !plotRealisasiController.isJumlahPlotEqual.value,
                        child: const SizedBox(width: CustomSize.sm),
                      );
                    }),
                    Obx(() {
                      return Expanded(
                        flex: !plotRealisasiController.isJumlahPlotEqual.value
                            ? 3
                            : 1,
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if there are no fields
                            if (plotRealisasiController
                                .isJumlahPlotEqual.value) {
                              print(
                                  '...INI JUMLAH PLOT REALISASI DAN JUMLAH UNIT MOTOR MUTASI SUDAH SAMA...');
                              widget.controller.selesaiAllTypeMotor(id);
                            } else if (widget.controller.formFields.isEmpty) {
                              print(
                                  '..TIDAK ADA DROPDOWN ATAU TEXTFORMFIELD DISNI..');
                              SnackbarLoader.errorSnackBar(
                                title: 'Peringatan ⚠️',
                                message:
                                    'Tidak ada data untuk disimpan. Tambahkan data terlebih dahulu.',
                              );
                            } else {
                              bool hasEmptyFields = false;
                              for (int i = 0;
                                  i < widget.controller.formFields.length;
                                  i++) {
                                if (widget.controller.formFields[i]
                                            .dropdownValue ==
                                        null ||
                                    widget.controller.formFields[i]
                                        .dropdownValue!.isEmpty ||
                                    widget.controller.textControllers[i].text
                                        .isEmpty) {
                                  hasEmptyFields = true;
                                  break;
                                }
                              }

                              if (hasEmptyFields) {
                                // Show a snackbar warning if any fields are empty
                                SnackbarLoader.errorSnackBar(
                                  title: 'Peringatan ⚠️',
                                  message:
                                      'Pastikan semua field telah diisi dengan benar.',
                                );
                              } else {
                                updateExceedingCapacity();
                                widget.controller.submitAllMutasi(
                                    widget.model.id, widget.model.jumlahUnit);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            backgroundColor:
                                plotRealisasiController.isJumlahPlotEqual.value
                                    ? AppColors.success
                                    : AppColors.primary,
                          ),
                          child: Text(
                            plotRealisasiController.isJumlahPlotEqual.value
                                ? 'Selesai'
                                : 'Simpan Data',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.apply(color: AppColors.white),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
