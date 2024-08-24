import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data do/do_kurang_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data do/do_kurang_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data do source/data_do_kurang_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class InputDataDoPengurangan extends GetView<DataDOKurangController> {
  const InputDataDoPengurangan({super.key});

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
      if (controller.rolesEdit == 1) 'Edit': 150,
      if (controller.rolesHapus == 1) 'Hapus': 150,
    };

    // const double dataPagerHeight = 60.0;
    const int rowsPerPage = 7;

    int currentPage = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Input DO Pengurangan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingKurang.value &&
              controller.doKurangModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.doKurangModel.isEmpty) {
            return GestureDetector(
              onTap: () {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Input DO Harian'),
                    contentWidget: AddDOPengurangan(
                      controller: controller,
                    ),
                    onConfirm: () {
                      if (controller.tgl.value.isEmpty) {
                        SnackbarLoader.errorSnackBar(
                          title: 'Gagal😪',
                          message: 'Pastikan tanggal telah di isi 😁',
                        );
                      } else {
                        controller.addDataDOKurang();
                      }
                    },
                    onCancel: () {
                      Get.back();
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
            final dataSource = DataDoKurangSource(
              doKurang: controller.doKurangModel,
              startIndex: currentPage * rowsPerPage,
              onEdited: (DoKurangModel model) {
                // Implementasi edit data di sini
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditDataDOKurang(
                      controller: controller,
                      model: model,
                    );
                  },
                );
              },
              onDeleted: (DoKurangModel model) {
                controller.hapusDOKurang(model.id);
                print('ini deleted btn');
              },
            );
            return LayoutBuilder(
              builder: (context, constraint) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        CustomDialogs.defaultDialog(
                            context: context,
                            titleWidget: const Text('Input DO Kurang'),
                            contentWidget: AddDOPengurangan(
                              controller: controller,
                            ),
                            onConfirm: () {
                              if (controller.tgl.value.isEmpty) {
                                SnackbarLoader.errorSnackBar(
                                  title: 'Gagal😪',
                                  message: 'Pastikan tanggal telah di isi 😁',
                                );
                              } else {
                                controller.addDataDOKurang();
                              }
                              print('Ini di data do pengurangan');
                            },
                            onCancel: () {
                              Get.back();
                              controller.tgl.value =
                                  CustomHelperFunctions.getFormattedDate(
                                      DateTime.now());
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
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        rowHeight: 65,
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
                          // Edit column
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
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          // Hapus
                          if (controller.rolesHapus == 1)
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
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SfDataPager(
                      delegate: dataSource,
                      pageCount: (controller.doKurangModel.length / rowsPerPage)
                          .ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
                  ],
                );
              },
            );
          }
        }));
  }
}

class AddDOPengurangan extends StatelessWidget {
  const AddDOPengurangan({super.key, required this.controller});

  final DataDOKurangController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.addKurangKey,
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
            Obx(
              () => Text(controller.idplant.value),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            Obx(
              () => DropDownWidget(
                value: controller.plant.value,
                items: controller.isAdmin
                    ? controller.idPlantMap.keys
                        .toList() // Menampilkan semua plant jika admin
                    : [
                        controller.plant.value
                      ], // Menampilkan plant spesifik untuk non-admin
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.plant.value = newValue;
                    print('ini value dari plant ${controller.plant.value}');
                  }
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
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
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

class EditDataDOKurang extends StatefulWidget {
  const EditDataDOKurang(
      {super.key, required this.controller, required this.model});

  final DataDOKurangController controller;
  final DoKurangModel model;

  @override
  State<EditDataDOKurang> createState() => _EditDataDOKurangState();
}

class _EditDataDOKurangState extends State<EditDataDOKurang> {
  late int id;
  late String tgl;
  late TextEditingController srd;
  late TextEditingController mks;
  late TextEditingController ptk;
  late TextEditingController bjm;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tgl = widget.model.tgl;
    srd = TextEditingController(text: widget.model.srd.toString());
    mks = TextEditingController(text: widget.model.mks.toString());
    ptk = TextEditingController(text: widget.model.ptk.toString());
    bjm = TextEditingController(text: widget.model.bjm.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit data DO Kurang',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ini id nya : $id'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate = DateTime.tryParse(tgl);

                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        // Hanya ubah nilai tanggal, biarkan waktu tetap default
                        setState(() {
                          tgl = CustomHelperFunctions.getFormattedDateDatabase(
                              newSelectedDate);
                          print('Ini tanggal yang dipilih : $tgl');
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                hintText: tgl.isNotEmpty
                    ? DateFormat.yMMMMd('id_ID').format(
                        DateTime.tryParse('$tgl 00:00:00') ?? DateTime.now(),
                      )
                    : 'Tanggal',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            Obx(
              () => DropDownWidget(
                value: widget.controller.plant.value,
                items: widget.controller.isAdmin
                    ? widget.controller.idPlantMap.keys.toList()
                    : [widget.controller.plant.value],
                onChanged: widget.controller.isAdmin
                    ? (String? newValue) {
                        if (newValue != null) {
                          widget.controller.plant.value = newValue;
                          widget.controller.idplant.value =
                              widget.controller.idPlantMap[newValue] ?? '1';
                          widget.controller.tujuan.value = widget.controller
                                  .idPlantMap[widget.controller.plant.value] ??
                              '1';
                          print(
                              'ini value dari plant ${widget.controller.plant.value}');
                        }
                      }
                    : null,
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
                    hintText: widget.controller.tujuanDisplayValue,
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
            ),
            Text('Hari ini jam : ${CustomHelperFunctions.formattedTime}'),
            Text('Hari ini tgl : $tgl'),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: srd,
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
              controller: mks,
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
              controller: ptk,
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
              controller: bjm,
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
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () => widget.controller.editDOGlobal(
            id,
            tgl,
            int.parse(widget.controller.idplant.value),
            widget.controller.tujuanDisplayValue,
            int.parse(srd.text),
            int.parse(mks.text),
            int.parse(ptk.text),
            int.parse(bjm.text),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
