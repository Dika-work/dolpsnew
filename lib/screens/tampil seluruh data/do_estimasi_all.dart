import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/tampil seluruh data/all_estimasi_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/tampil seluruh data/do_estimasi_all.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/tampil seluruh data source/all_estimasi_source.dart';

class AllDoEstimasi extends GetView<AllEstimasiController> {
  const AllDoEstimasi({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': 50,
      'Tgl': 70,
      'HSO - SRD': 80,
      'HSO - MKS': 80,
      'HSO - PTK': 80,
      'Edit': 70,
      'Hapus': 70,
    };

    const int rowsPerPage = 7;
    int currentPage = 0;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new)),
          title: Text('Data DO Estimasi (Tentative)',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Obx(
          () {
            if (controller.isEstimasiLoading.value &&
                controller.doAllEstimasiModel.isEmpty) {
              return const CustomCircularLoader();
            } else {
              final dataSource = AllEstimasiSource(
                  onEdited: (DoEstimasiAllModel model) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditEstimasi(
                          controller: controller,
                          model: model,
                        );
                      },
                    );
                  },
                  onDeleted: (DoEstimasiAllModel model) =>
                      controller.hapusEstimasi(model.id),
                  doEstimasi: controller.doAllEstimasiModel,
                  startIndex: currentPage * rowsPerPage);

              List<GridColumn> column = [
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
                    ),
                  ),
                ),
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
                    ),
                  ),
                ),
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
                  ),
                ),
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
                  ),
                ),
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
                )
              ];

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      CustomDialogs.defaultDialog(
                          context: context,
                          titleWidget: const Text('Tambah Data DO Estimasi'),
                          contentWidget: AddEstimasi(controller: controller),
                          onConfirm: () {
                            if (controller.tgl.value.isEmpty) {
                              SnackbarLoader.errorSnackBar(
                                  title: 'Gagal😒',
                                  message: 'Pastikan tanggal telah di isi👌');
                            } else {
                              controller.addDataEstimasi();
                            }
                          },
                          onCancel: () {
                            controller.srdController.clear();
                            controller.mksController.clear();
                            controller.ptkController.clear();
                            Get.back();
                          },
                          cancelText: 'Close',
                          confirmText: 'Save');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const IconButton(
                            onPressed: null, icon: Icon(Iconsax.add_circle)),
                        Padding(
                          padding: const EdgeInsets.only(right: CustomSize.sm),
                          child: Text(
                            'Tambah Data',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchAllEstimasi();
                    },
                    child: SfDataGrid(
                      source: dataSource,
                      frozenColumnsCount: 2,
                      columnWidthMode: ColumnWidthMode.auto,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      rowHeight: 65,
                      columns: column,
                    ),
                  )),
                  SfDataPager(
                    delegate: dataSource,
                    pageCount: controller.doAllEstimasiModel.isEmpty
                        ? 1
                        : (controller.doAllEstimasiModel.length / rowsPerPage)
                            .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ],
              );
            }
          },
        ));
  }
}

class AddEstimasi extends StatelessWidget {
  const AddEstimasi({super.key, required this.controller});

  final AllEstimasiController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.allEstimasiKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
        ));
  }
}

class EditEstimasi extends StatefulWidget {
  const EditEstimasi(
      {super.key, required this.controller, required this.model});

  final AllEstimasiController controller;
  final DoEstimasiAllModel model;

  @override
  State<EditEstimasi> createState() => _EditEstimasiState();
}

class _EditEstimasiState extends State<EditEstimasi> {
  late int id;
  late String tgl;
  late TextEditingController srd;
  late TextEditingController mks;
  late TextEditingController ptk;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tgl = widget.model.tgl;
    srd = TextEditingController(text: widget.model.jumlah1.toString());
    mks = TextEditingController(text: widget.model.jumlah2.toString());
    ptk = TextEditingController(text: widget.model.jumlah3.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Edit DO Estimasi (Tentative)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () => widget.controller.editEstimasi(id, tgl,
              int.parse(srd.text), int.parse(mks.text), int.parse(ptk.text)),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
