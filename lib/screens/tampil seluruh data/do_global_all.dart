import 'package:doplsnew/models/tampil%20seluruh%20data/do_global_all.dart';
import 'package:doplsnew/utils/source/empty_data_source.dart';
import 'package:doplsnew/utils/source/tampil%20seluruh%20data%20source/all_global_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/tampil seluruh data/all_global_controller.dart';
import '../../helpers/helper_function.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class DoGlobalAll extends GetView<DataAllGlobalController> {
  const DoGlobalAll({super.key});

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
      'Edit': 50,
      'Hapus': 50,
    };

    const int rowsPerPage = 7;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tampil seluruh data DO Global',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingGlobalHarian.value &&
            controller.doAllGlobalModel.isEmpty) {
          return const CustomCircularLoader();
        } else {
          final dataSource = controller.doAllGlobalModel.isEmpty
              ? EmptyAllDataSource()
              : DataAllGlobalSource(
                  allGlobal: controller.doAllGlobalModel,
                  startIndex: currentPage * rowsPerPage,
                  onEdited: (DoGlobalAllModel model) {
                    // Implementasi edit data di sini
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditDoGlobalData(
                          controller: controller,
                          model: model,
                        );
                      },
                    );
                  },
                  onDeleted: () {
                    // Implementasi delete data di sini
                    print('ini deleted btn');
                  },
                );
          return LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Expanded(
                      child: SfDataGrid(
                    source: dataSource,
                    columnWidthMode: ColumnWidthMode.auto,
                    allowPullToRefresh: true,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    allowColumnsResizing: true,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                      columnWidths[details.column.columnName] = details.width;
                      return true;
                    },
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
                          ),
                        ),
                      ),
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
                          ),
                        ),
                      ),
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
                      ),
                    ],
                  )),
                  SfDataPager(
                    delegate: dataSource,
                    pageCount: controller.doAllGlobalModel.isEmpty
                        ? 1
                        : (controller.doAllGlobalModel.length / rowsPerPage)
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

class EditDoGlobalData extends StatefulWidget {
  const EditDoGlobalData(
      {super.key, required this.controller, required this.model});

  final DataAllGlobalController controller;
  final DoGlobalAllModel model;

  @override
  State<EditDoGlobalData> createState() => _EditDoGlobalDataState();
}

class _EditDoGlobalDataState extends State<EditDoGlobalData> {
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

  String get tujuanDisplayValue => tujuanMap[plant] ?? '';

  String get idPlantValue => idPlantMap[idPlant.toString()] ?? '';

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
        'Edit data All Global',
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
            Text(idPlant.toString()),
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
            Text('Tujuan $tujuan'),
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
          onPressed: () => print('...INI GLOBAL ALL DATA...'),
          // onPressed: () => widget.controller.editDOHarian(
          //   id,
          //   tgl,
          //   idPlant,
          //   tujuan,
          //   int.parse(srd.text),
          //   int.parse(mks.text),
          //   int.parse(ptk.text),
          //   int.parse(bjm.text),
          // ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
