import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data do/do_harian_controller.dart';
import '../../models/input data do/do_harian_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data do source/data_do_harian_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class InputDataDoHarian extends GetView<DataDoHarianController> {
  const InputDataDoHarian({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': 50,
      'Plant': 60,
      'Tujuan': 100,
      'Tgl': 70,
      'HSO - SRD': 80,
      'HSO - MKS': 80,
      'HSO - PTK': 80,
      'BJM': 80,
      if (controller.rolesEdit == 1) 'Edit': 70,
      if (controller.rolesHapus == 1) 'Hapus': 70,
    };

    const int rowsPerPage = 7;

    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data DO Harian',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (!controller.isConnected.value) {
          return const CustomAnimationLoaderWidget(
              text:
                  'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
              animation: 'assets/animations/404.json');
        } else if (controller.isLoadingHarian.value &&
            controller.doHarianModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.doHarianModel.isEmpty) {
          return GestureDetector(
            onTap: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: const Text('Input DO Harian'),
                  contentWidget: AddDOHarian(
                    controller: controller,
                  ),
                  onConfirm: () {
                    if (controller.tgl.value.isEmpty) {
                      SnackbarLoader.errorSnackBar(
                        title: 'Gagal😪',
                        message: 'Pastikan tanggal telah di isi 😁',
                      );
                    } else {
                      controller.addDataDOHarian();
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
          final dataSource = DataDoHarianSource(
            doHarian: controller.doHarianModel,
            startIndex: currentPage * rowsPerPage,
            onEdited: (DoHarianModel model) {
              // Implementasi edit data di sini
              showDialog(
                context: context,
                builder: (context) {
                  return EditDataDOHarian(
                    controller: controller,
                    model: model,
                  );
                },
              );
            },
            onDeleted: (DoHarianModel model) {
              controller.hapusDOHarian(model.id);
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
                          titleWidget: const Text('Input DO Harian'),
                          contentWidget: AddDOHarian(
                            controller: controller,
                          ),
                          onConfirm: () {
                            if (controller.tgl.value.isEmpty) {
                              SnackbarLoader.errorSnackBar(
                                title: 'Gagal😪',
                                message: 'Pastikan tanggal telah di isi 😁',
                              );
                            } else {
                              controller.addDataDOHarian();
                              print('ini tanggal nya: ${controller.tgl.value}');
                            }
                          },
                          onCancel: () {
                            Get.back();
                            controller.tgl.value =
                                CustomHelperFunctions.getFormattedDateDatabase(
                                    DateTime.now());
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
                          padding: const EdgeInsets.only(right: CustomSize.sm),
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
                      frozenColumnsCount: 2,
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
                            width: columnWidths['Tgl']!,
                            columnName: 'Tgl',
                            label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Tgl',
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
                    pageCount: (controller.doHarianModel.length / rowsPerPage)
                        .ceilToDouble(),
                    direction: Axis.horizontal,
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

class AddDOHarian extends StatelessWidget {
  const AddDOHarian({super.key, required this.controller});

  final DataDoHarianController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.addHarianKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal'),
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
                        initialDate: selectedDate,
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
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
            ),
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

class EditDataDOHarian extends StatefulWidget {
  const EditDataDOHarian(
      {super.key, required this.controller, required this.model});

  final DataDoHarianController controller;
  final DoHarianModel model;

  @override
  State<EditDataDOHarian> createState() => _EditDataDOHarianState();
}

class _EditDataDOHarianState extends State<EditDataDOHarian> {
  late int id;
  late String tgl;
  late int idPlant;
  late String? plant;
  late String tujuan;
  late TextEditingController srd;
  late TextEditingController mks;
  late TextEditingController ptk;
  late TextEditingController bjm;

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  final Map<String, String> idPlantMap = {
    '1100': '1', //1
    '1200': '2', //2
    '1300': '3', //3
    '1350': '4', //4
    '1700': '5', //5
    '1800': '6', //6
    '1900': '9', //9
  };

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tgl = widget.model.tgl;
    idPlant = widget.model.idPlant;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    srd = TextEditingController(text: widget.model.srd.toString());
    mks = TextEditingController(text: widget.model.mks.toString());
    ptk = TextEditingController(text: widget.model.ptk.toString());
    bjm = TextEditingController(text: widget.model.bjm.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit data DO Harian',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal'),
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
            DropDownWidget(
              value: plant,
              items: tujuanMap.keys.toList(),
              onChanged: (String? value) {
                setState(() {
                  print('Selected plant: $value');
                  plant = value!;
                  idPlant = int.parse(idPlantMap[value]!);
                  tujuan = tujuanMap[value]!;
                });
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: tujuan,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
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
          onPressed: () => widget.controller.editDOHarian(
            id,
            tgl,
            idPlant,
            tujuan,
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
