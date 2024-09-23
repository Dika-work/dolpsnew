import 'package:doplsnew/utils/source/empty_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/tampil seluruh data/all_harian_lps_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/tampil seluruh data/do_harian_all_lps.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/tampil seluruh data source/all_harian_lps_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class DoHarianLps extends GetView<DataAllHarianLpsController> {
  const DoHarianLps({super.key});

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
      if (controller.rolesEdit == 1) 'Edit': double.nan,
      if (controller.rolesHapus == 1) 'Hapus': double.nan,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tampil seluruh data DO Harian',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        print(
            'Obx Rebuilt: isLoadingGlobal=${controller.isLoadingGlobalHarian.value}, doGlobalHarianModel length=${controller.doGlobalHarianModel.length}');
        if (controller.isLoadingGlobalHarian.value &&
            controller.doGlobalHarianModel.isEmpty) {
          return const CustomCircularLoader();
        } else {
          final dataSource = controller.doGlobalHarianModel.isEmpty ||
                  !controller.isConnected.value
              ? EmptyAllDataSource()
              : DataAllHarianLpsSource(
                  allGlobal: controller.displayedData,
                  onEdited: (DoHarianAllLpsModel model) {
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
                  onDeleted: (DoHarianAllLpsModel model) {
                    // Implementasi delete data di sini
                    controller.hapusDOHarian(model.id);
                    print('ini deleted btn: ${model.id}');
                  },
                );

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
          ];

          if (controller.rolesEdit == 1) {
            column.add(GridColumn(
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
            ));
          }

          if (controller.rolesHapus == 1) {
            column.add(GridColumn(
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
            ));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(CustomSize.sm),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() => TextFormField(
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    locale: const Locale("id", "ID"),
                                    initialDate: controller.pickDate.value ??
                                        DateTime.now(),
                                    firstDate: DateTime(1850),
                                    lastDate: DateTime(2040),
                                  ).then((newSelectedDate) {
                                    if (newSelectedDate != null) {
                                      controller.pickDate.value =
                                          newSelectedDate;
                                      print(
                                          'ini tanggal yang di pilih ${controller.pickDate.value}');
                                    }
                                  });
                                },
                                icon: const Icon(Iconsax.calendar),
                              ),
                              // Reactive hintText, updates when pickDate is set
                              hintText: controller.pickDate.value != null
                                  ? CustomHelperFunctions.getFormattedDate(
                                      controller.pickDate.value!)
                                  : 'Tanggal',
                            ),
                          )),
                    ),
                    const SizedBox(width: CustomSize.sm),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.pickDate.value != null
                              ? controller.fetchDataDoGlobal(
                                  pickDate: controller.pickDate.value)
                              : SnackbarLoader.errorSnackBar(
                                  title: 'Oops😒',
                                  message:
                                      'Harap pilih tanggal terlebih dahulu');
                        },
                        child: const Text('Apply Filter'),
                      ),
                    ),
                    if (controller.pickDate.value != null)
                      const SizedBox(width: CustomSize.sm),
                    if (controller.pickDate.value != null)
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => controller.resetFilterDate(),
                          child: const Text('Reset'),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  if (!await controller.networkManager.isConnected()) {
                    controller.isConnected.value = false;
                    return;
                  }
                  controller.isConnected.value = true;
                  if (!controller.hasFetchedData.value) {
                    await controller
                        .fetchDataDoGlobal(); // Hanya panggil sekali
                    controller.hasFetchedData.value =
                        true; // Update flag setelah fetching
                  }
                },
                child: SfDataGrid(
                  source: dataSource,
                  frozenColumnsCount: 2,
                  columnWidthMode: ColumnWidthMode.auto,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  rowHeight: 65,
                  verticalScrollController: controller.scrollController,
                  columns: column,
                ),
              )),
              if (controller
                  .isLoadingMore.value) // Loader di bawah ketika lazy loading
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }
      }),
    );
  }
}

class EditDoGlobalData extends StatefulWidget {
  const EditDoGlobalData(
      {super.key, required this.controller, required this.model});

  final DataAllHarianLpsController controller;
  final DoHarianAllLpsModel model;

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
        'Edit Do Harian Honda',
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
