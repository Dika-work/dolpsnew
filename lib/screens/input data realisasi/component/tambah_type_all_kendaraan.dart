import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../helpers/helper_function.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/popups/snackbar.dart';
import '../../../utils/source/input data realisasi/tambah_type_motor_source.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dynamic_formfield.dart';
import 'edit_type.dart';
import 'tambah_type_kendaraan.dart';

class TambahTypeAllKendaraan extends StatefulWidget {
  const TambahTypeAllKendaraan(
      {super.key, required this.model, required this.controller});

  final DoRealisasiModel model;
  final TambahTypeMotorController controller;

  @override
  State<TambahTypeAllKendaraan> createState() => _TambahTypeAllKendaraanState();
}

class _TambahTypeAllKendaraanState extends State<TambahTypeAllKendaraan> {
  late int id;
  late String tgl;
  late int jumlahMotor;
  final isExceedingCapacity = false.obs;
  final plotRealisasiController = Get.put(PlotRealisasiController());
  final editTypeMotorController = Get.put(EditTypeMotorController());
  final ValueNotifier<Set<TabDaerahTujuan>> highlightedTabs =
      ValueNotifier<Set<TabDaerahTujuan>>({});

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tgl = CustomHelperFunctions.getFormattedDateDatabase(DateTime.now());
    jumlahMotor = widget.model.jumlahUnit;

    // set default untuk plot realisasi
    plotRealisasiController.fetchPlotRealisasi(id, jumlahMotor).then((_) {
      updateExceedingCapacity();
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.controller.fetchTambahTypeMotor(id).then((_) {
          updateExceedingCapacity();
        });
      },
    );
  }

  void updateExceedingCapacity() {
    if (plotRealisasiController.plotModelRealisasi.isNotEmpty) {
      int totalPlot =
          plotRealisasiController.plotModelRealisasi.first.jumlahPlot;

      // Loop semua bidang dan jumlahkan total plot yang dimasukkan
      for (var tab in TabDaerahTujuan.values) {
        final formData = widget.controller.formFieldsPerTab[tab];
        final controllers = widget.controller.controllersPerTab[tab];

        if (formData != null && formData.isNotEmpty && controllers != null) {
          for (int i = 0; i < formData.length; i++) {
            final textFieldValue = controllers[i].text;
            final jumlah = int.tryParse(textFieldValue) ?? 0;
            totalPlot += jumlah;
          }
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

  // Fungsi untuk memeriksa validitas data dan memperbarui highlightedTabs
  void checkTabValidity() {
    Set<TabDaerahTujuan> invalidTabs = {};
    for (var tab in TabDaerahTujuan.values) {
      final formData = widget.controller.formFieldsPerTab[tab];
      final controllers = widget.controller.controllersPerTab[tab];

      if (formData != null && formData.isNotEmpty && controllers != null) {
        for (int i = 0; i < formData.length; i++) {
          final dropdownValue = formData[i].dropdownValue;
          final textFieldValue = controllers[i].text;
          final jumlah = int.tryParse(textFieldValue) ?? 0;

          if (dropdownValue == null || dropdownValue.isEmpty || jumlah <= 0) {
            invalidTabs.add(tab);
            break;
          }
        }
      }
    }
    highlightedTabs.value = invalidTabs;
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': 150,
      'SRD': double.nan,
      'MKS': double.nan,
      'PTK': double.nan,
      'BJM': double.nan,
    };

    const int rowsPerPage = 5;
    int currentPage = 0;
    const double rowHeight = 55.0;
    const double headerHeight = 32.0;

    const double gridHeight = headerHeight + ((rowHeight) * (rowsPerPage + 1));

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
                  const Text('Jenis'),
                  TextFormField(
                    controller: TextEditingController(
                        text:
                            '${widget.model.inisialDepan}${widget.model.inisialBelakang}'),
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
            controller: TextEditingController(text: widget.model.noPolisi),
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          TextFormField(
            controller: TextEditingController(text: widget.model.supir),
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
                      controller:
                          TextEditingController(text: jumlahMotor.toString()),
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
          // table nya
          Obx(
            () {
              if (widget.controller.isLoadingTambahType.value &&
                  widget.controller.tambahTypeMotorModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = TambahTypeMotorSource(
                  tambahTypeMotorModel: widget.controller.tambahTypeMotorModel,
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
                      pageCount: widget.controller.tambahTypeMotorModel.isEmpty
                          ? 1
                          : (widget.controller.tambahTypeMotorModel.length /
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
                            child: ValueListenableBuilder<Set<TabDaerahTujuan>>(
                          valueListenable: highlightedTabs,
                          builder: (context, highlighted, child) {
                            return GestureDetector(
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
                                      color: highlighted.contains(tab)
                                          ? Colors.red
                                          : (value == tab
                                              ? AppColors.primary
                                              : AppColors.buttonDisabled),
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
                            );
                          },
                        ));
                      }).toList(),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    // ListView for form fields
                    Obx(() {
                      final fields = widget.controller
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
                              widget
                                  .controller
                                  .formFieldsPerTab[selectedDaerahTujuan.value]
                                      ?[index]
                                  .dropdownValue = value;
                            },
                            onTextFieldChanged: (value) {
                              widget
                                  .controller
                                  .formFieldsPerTab[selectedDaerahTujuan.value]
                                      ?[index]
                                  .textFieldValue = value;
                            },
                            onRemove: () {
                              widget.controller.removeField(
                                  selectedDaerahTujuan.value, index);
                            },
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: CustomSize.spaceBtwItems),
                      );
                    }),
                    // Buttons
                    Obx(() {
                      if (isExceedingCapacity.value) {
                        return Column(
                          children: [
                            Text(
                              'JUMLAH MOTOR\nLEBIH DARI\nKAPASITAS KENDARAAN',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
                                  onPressed: () =>
                                      Get.to(() => EditTypeKendaraan(
                                            model: widget.model,
                                            onConfirm: () => editTypeMotorController
                                                .editDanHapusTambahTypeKendaraan(
                                                    id),
                                          )),
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
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: CustomSize.spaceBtwSections),
                          child: Row(
                            children: [
                              Obx(
                                () => Visibility(
                                  visible: !plotRealisasiController
                                      .isJumlahPlotEqual.value,
                                  child: Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.controller.addField(
                                            selectedDaerahTujuan.value);
                                      },
                                      child: const Icon(Iconsax.add),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                return Visibility(
                                  visible: !plotRealisasiController
                                      .isJumlahPlotEqual.value,
                                  child: const SizedBox(width: CustomSize.sm),
                                );
                              }),
                              Obx(
                                () => Visibility(
                                  visible: !plotRealisasiController
                                      .isJumlahPlotEqual.value,
                                  child: Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.controller.resetFields(
                                            selectedDaerahTujuan.value);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.error),
                                      child: const Icon(FontAwesomeIcons.trash),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                return Visibility(
                                  visible: !plotRealisasiController
                                      .isJumlahPlotEqual.value,
                                  child: const SizedBox(width: CustomSize.sm),
                                );
                              }),
                              Obx(() => Expanded(
                                    flex: !plotRealisasiController
                                            .isJumlahPlotEqual.value
                                        ? 3
                                        : 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (plotRealisasiController
                                            .isJumlahPlotEqual.value) {
                                          widget.controller
                                              .selesaiAllTypeMotor(id);
                                        } else if (widget
                                                .controller
                                                .formFieldsPerTab[
                                                    selectedDaerahTujuan.value]
                                                ?.isEmpty ??
                                            true) {
                                          SnackbarLoader.errorSnackBar(
                                            title: 'Peringatan ⚠️',
                                            message:
                                                'Tidak ada data untuk disimpan. Tambahkan data terlebih dahulu.',
                                          );
                                        } else {
                                          bool hasData = false;
                                          bool hasValidData = true;

                                          for (var tab
                                              in TabDaerahTujuan.values) {
                                            final formData = widget.controller
                                                .formFieldsPerTab[tab];
                                            final controllers = widget
                                                .controller
                                                .controllersPerTab[tab];

                                            if (formData != null &&
                                                formData.isNotEmpty &&
                                                controllers != null) {
                                              hasData = true;

                                              for (int i = 0;
                                                  i < formData.length;
                                                  i++) {
                                                final dropdownValue =
                                                    formData[i].dropdownValue;
                                                final textFieldValue =
                                                    controllers[i].text;
                                                final jumlah = int.tryParse(
                                                        textFieldValue) ??
                                                    0;

                                                if (dropdownValue == null ||
                                                    dropdownValue.isEmpty ||
                                                    jumlah <= 0) {
                                                  hasValidData = false;
                                                  break;
                                                }
                                              }

                                              if (!hasValidData) {
                                                break;
                                              }
                                            }
                                          }

                                          if (!hasData) {
                                            SnackbarLoader.errorSnackBar(
                                              title: 'Error👌',
                                              message:
                                                  'Harap tambahkan setidaknya satu field di salah satu tab.',
                                            );
                                          } else if (!hasValidData) {
                                            setState(() {
                                              checkTabValidity();
                                            });
                                            SnackbarLoader.errorSnackBar(
                                              title: 'Error',
                                              message:
                                                  'Harap isi semua dropdown dan jumlah dengan benar.',
                                            );
                                          } else {
                                            // Mengumpulkan dan memproses data yang valid
                                            widget.controller.collectData();
                                            updateExceedingCapacity(); // Update status setelah submit data
                                            widget.controller
                                                .submitAllTabs(id, jumlahMotor);
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        backgroundColor: plotRealisasiController
                                                .isJumlahPlotEqual.value
                                            ? AppColors.success
                                            : AppColors.primary,
                                      ),
                                      child: Text(
                                        plotRealisasiController
                                                .isJumlahPlotEqual.value
                                            ? 'Selesai'
                                            : 'Simpan Data',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.apply(color: AppColors.white),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }
                    }),
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
