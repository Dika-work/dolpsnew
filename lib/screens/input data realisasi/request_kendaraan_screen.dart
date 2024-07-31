import 'package:doplsnew/screens/input%20data%20realisasi/kirim_kendaraan.dart';
import 'package:doplsnew/screens/input%20data%20realisasi/lihat_kendaraan.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/lihat_kendaraan_controller.dart';
import '../../controllers/input data realisasi/plot_kendaraan_controller.dart';
import '../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data realisasi/request_mobil_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class RequestKendaraanScreen extends GetView<RequestKendaraanController> {
  const RequestKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Pengurus': double.nan,
      'Tanggal': 130,
      'Jam': 100,
      'Plant': double.nan,
      'Tujuan': double.nan,
      'Type': 130,
      'Jenis': 150,
      'Jumlah': double.nan,
      'Lihat': 100,
      'Kirim': 100,
      'Edit': 100,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Kendaraan Honda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isRequestLoading.value &&
              controller.requestKendaraanModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.requestKendaraanModel.isEmpty) {
            return GestureDetector(
              onTap: () {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Tambah Request Kendaraan'),
                    contentWidget: AddRequestKendaraan(
                      controller: controller,
                    ),
                    onConfirm: () {
                      if (controller.tgl.value.isEmpty) {
                        SnackbarLoader.errorSnackBar(
                          title: 'Gagal😪',
                          message: 'Pastikan tanggal telah di isi 😁',
                        );
                      } else {
                        controller.addRequestKendaraan();
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
            final dataSource = RequestMobilSource(
              onLihat: (RequestKendaraanModel model) {
                final lihatKendaraanController =
                    Get.put(LihatKendaraanController());
                final plotKendaraanController =
                    Get.put(PlotKendaraanController());

                showDialog(
                  context: context,
                  builder: (context) {
                    return LihatKendaraanScreen(
                      model: model,
                      controller: lihatKendaraanController,
                      plotKendaraanController: plotKendaraanController,
                    );
                  },
                );

                lihatKendaraanController.fetchLihatKendaraan(
                  model.type,
                  model.plant,
                  model.idReq,
                );

                plotKendaraanController.fetchPlot(
                  model.idReq,
                  model.tgl,
                  model.type,
                  model.plant,
                  model.jumlah,
                );
              },
              onKirim: (RequestKendaraanModel model) =>
                  Get.to(() => KirimKendaraanScreen(
                        model: model,
                        selectedIndex: model.idReq,
                      )),
              onEdit: (RequestKendaraanModel model) {
                Map<String, dynamic> updatedValues = {};

                CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: Text(
                    'Edit Request Kendaraan Honda',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  contentWidget: EditRequestKendaraan(
                    controller: controller,
                    model: model,
                    onUpdated: ({
                      required String tgl,
                      required String plant,
                      required String tujuan,
                      required String typeDo,
                      required String jenis,
                      required int jumlah,
                    }) {
                      updatedValues = {
                        'tgl': tgl,
                        'plant': plant,
                        'tujuan': tujuan,
                        'typeDo': typeDo,
                        'jenis': jenis,
                        'jumlah': jumlah,
                      };
                    },
                  ),
                  onConfirm: () {
                    print('Updated values: $updatedValues');
                    // Simulasi untuk print data sebelum dikirim ke controller
                    final typeDoValue =
                        controller.typeDOMap[updatedValues['typeDo']] ?? 0;

                    print('ID Req: ${model.idReq}');
                    print('Tanggal: ${updatedValues['tgl']}');
                    print('Plant: ${updatedValues['plant']}');
                    print('Tujuan: ${updatedValues['tujuan']}');
                    print('Type DO: $typeDoValue');
                    print('Jenis: ${updatedValues['jenis']}');
                    print('Jumlah: ${updatedValues['jumlah']}');

                    controller.editReqKendaraan(
                      model.idReq,
                      updatedValues['tgl'],
                      updatedValues['plant'],
                      updatedValues['tujuan'],
                      typeDoValue,
                      updatedValues['jenis'],
                      updatedValues['jumlah'],
                    );
                  },
                  cancelText: 'Close',
                  confirmText: 'Save',
                );
              },
              requestKendaraanModel: controller.requestKendaraanModel,
              startIndex: currentPage * rowsPerPage,
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
                      ))),
              GridColumn(
                  width: columnWidths['Pengurus']!,
                  columnName: 'Pengurus',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Pengurus',
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
                  width: columnWidths['Type']!,
                  columnName: 'Type',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Type',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['Jenis']!,
                  columnName: 'Jenis',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Jenis',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['Jumlah']!,
                  columnName: 'Jumlah',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Jumlah',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['Lihat']!,
                  columnName: 'Lihat',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Lihat',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['Kirim']!,
                  columnName: 'Kirim',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Kirim',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
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
                      ))),
            ];

            return LayoutBuilder(
              builder: (_, __) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        CustomDialogs.defaultDialog(
                            context: context,
                            titleWidget: const Text('Tambah Request Kendaraan'),
                            contentWidget: AddRequestKendaraan(
                              controller: controller,
                            ),
                            onConfirm: () {
                              if (controller.tgl.value.isEmpty) {
                                SnackbarLoader.errorSnackBar(
                                  title: 'Gagal😪',
                                  message: 'Pastikan tanggal telah di isi 😁',
                                );
                              } else {
                                controller.addRequestKendaraan();
                              }
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
                      rowHeight: 65,
                      columnWidthMode: ColumnWidthMode.auto,
                      allowPullToRefresh: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
                      columns: column,
                    )),
                    SfDataPager(
                      delegate: dataSource,
                      pageCount: controller.requestKendaraanModel.isEmpty
                          ? 1
                          : (controller.requestKendaraanModel.length /
                                  rowsPerPage)
                              .ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AddRequestKendaraan extends StatelessWidget {
  const AddRequestKendaraan({super.key, required this.controller});

  final RequestKendaraanController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.requestKendaraanKey,
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
            Text('Hari ini jam : ${CustomHelperFunctions.formattedTime}'),
            const Text('Type DO'),
            Obx(
              () => DropDownWidget(
                value: controller.typeDO.value,
                items: controller.typeDOMap.keys.toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.typeDO.value = newValue;
                    print(
                        'ini value dari typeDO ${controller.typeDOValue.value}');
                  }
                },
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
            const Text('Jumlah DO Harian'),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.truck_fast),
                    hintText: controller.jumlahHarian.toString(),
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis'),
            Obx(
              () => DropDownWidget(
                value: controller.jenisKendaraan.value,
                items: controller.jenisKendaraanList,
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  controller.jenisKendaraan.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.jumlahKendaraanController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah kendaraan harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.truck),
                hintText: 'Jumlah Kendaraan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditRequestKendaraan extends StatefulWidget {
  const EditRequestKendaraan({
    super.key,
    required this.controller,
    required this.model,
    required this.onUpdated,
  });

  final RequestKendaraanController controller;
  final RequestKendaraanModel model;
  final void Function({
    required String tgl,
    required String plant,
    required String tujuan,
    required String typeDo,
    required String jenis,
    required int jumlah,
  }) onUpdated;

  @override
  State<EditRequestKendaraan> createState() => _EditRequestKendaraanState();
}

class _EditRequestKendaraanState extends State<EditRequestKendaraan> {
  late String tgl;
  late String typeDo;
  late TextEditingController jumlah;

  @override
  void initState() {
    super.initState();
    tgl = widget.model.tgl;
    typeDo = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
    jumlah = TextEditingController(text: widget.model.jumlah.toString());
  }

  String get tujuanDisplayValue =>
      widget.controller.tujuanMap[widget.model.plant] ?? '';

  void _updateValues() {
    widget.onUpdated(
      tgl: tgl,
      plant: widget.model.plant,
      tujuan: tujuanDisplayValue,
      typeDo: typeDo,
      jenis: widget.model.jenis,
      jumlah: int.tryParse(jumlah.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal Req',
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
                      setState(() {
                        tgl = CustomHelperFunctions.getFormattedDateDatabase(
                            newSelectedDate);
                        _updateValues();
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
          const SizedBox(height: 8.0), // Add some spacing between rows
          Text(
            'Plant',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          DropDownWidget(
            value: widget.model.plant,
            items: widget.controller.tujuanMap.keys.toList(),
            onChanged: (String? value) {
              setState(() {
                print('Selected plant: $value');
                widget.model.plant = value!;
                _updateValues();
                print('ini plant baru yg di pilih : ${widget.model.plant}');
              });
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            'Tujuan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: tujuanDisplayValue,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Type DO',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          DropDownWidget(
            value: typeDo,
            items: widget.controller.typeDOMap.keys.toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  typeDo = newValue;
                  _updateValues();
                  print('ini value dari typeDO $typeDo');
                });
              }
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            'Jenis Ken',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          DropDownWidget(
            value: widget.model.jenis,
            items: widget.controller.jenisKendaraanList,
            onChanged: (String? value) {
              setState(() {
                print('Selected plant: $value');
                widget.model.jenis = value!;
                _updateValues();
              });
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            'Jumlah Ken',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextFormField(
            controller: jumlah,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah kendaraan harus di isi';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.truck),
              hintText: 'Jumlah Kendaraan',
            ),
            onChanged: (value) {
              _updateValues();
            },
          ),
        ],
      ),
    );
  }
}
