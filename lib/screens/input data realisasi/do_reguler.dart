import 'package:doplsnew/controllers/input%20data%20realisasi/tambah_type_motor_controller.dart';
import 'package:doplsnew/screens/input%20data%20realisasi/component/tambah_type_kendaraan.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/input data realisasi/do_reguler_source.dart';
import 'component/edit_realisasi.dart';
import 'component/jumlah_unit.dart';

class DoRegulerScreen extends GetView<DoRegulerController> {
  const DoRegulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'User': double.nan,
      'Plant': double.nan,
      'Tgl': 130,
      'Supir(Panggilan)': 200,
      'Kendaraan': 120,
      'Tipe': double.nan,
      'Jenis': double.nan,
      'Status': double.nan,
      'Jumlah': double.nan,
      'Lihat': double.nan,
      'Action': 120,
      'Batal': double.nan,
      'Edit': double.nan,
      'Type': double.nan,
      'Hapus': double.nan,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Reguler DO LPS',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoadingReguler.value &&
              controller.doRealisasiModel.isEmpty) {
            return const CustomCircularLoader();
          } else {
            final dataSource = DoRegulerSource(
              onLihat: (DoRealisasiModel model) {},
              onAction: (DoRealisasiModel model) {
                final tambahTypeMotorController =
                    Get.put(TambahTypeMotorController());
                if (model.status == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return JumlahUnit(model: model);
                    },
                  );
                } else if (model.status == 1 || model.status == 2) {
                  tambahTypeMotorController.fetchTambahTypeMotor(model.id);
                  Get.to(() => TambahTypeKendaraan(
                      model: model, controller: tambahTypeMotorController));
                } else if (model.status == 3) {
                  print('...NAVIGATE KE ACCECORISS MOTORR...');
                }
              },
              onBatal: (DoRealisasiModel model) {},
              onEdit: (DoRealisasiModel model) {
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Edit DO Realisasi'),
                    contentWidget: EditRealisasi(
                      model: model,
                    ),
                    // onConfirm: controller.edit,
                    cancelText: 'Close',
                    confirmText: 'Edit');
              },
              onType: (DoRealisasiModel model) {
                // Get.to(() => EditTypeKendaraan());
              },
              onHapus: (DoRealisasiModel model) {},
              doRealisasiModel: controller.doRealisasiModel,
              startIndex: currentPage * rowsPerPage,
            );

            return LayoutBuilder(builder: (_, __) {
              return Column(
                children: [
                  Expanded(
                    child: SfDataGrid(
                        source: dataSource,
                        columnWidthMode: ColumnWidthMode.auto,
                        rowHeight: 65,
                        allowPullToRefresh: true,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        allowColumnsResizing: true,
                        onColumnResizeUpdate:
                            (ColumnResizeUpdateDetails details) {
                          columnWidths[details.column.columnName] =
                              details.width;
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
                                  ))),
                          GridColumn(
                              width: columnWidths['User']!,
                              columnName: 'User',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'User',
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
                              width: columnWidths['Supir(Panggilan)']!,
                              columnName: 'Supir(Panggilan)',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Supir(Panggilan)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Kendaraan']!,
                              columnName: 'Kendaraan',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Kendaraan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Tipe']!,
                              columnName: 'Tipe',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Tipe',
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
                              width: columnWidths['Status']!,
                              columnName: 'Status',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Status',
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
                              width: columnWidths['Action']!,
                              columnName: 'Action',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Action',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          GridColumn(
                              width: columnWidths['Batal']!,
                              columnName: 'Batal',
                              label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Batal',
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
                                  ))),
                        ]),
                  ),
                  SfDataPager(
                    delegate: dataSource,
                    pageCount: controller.doRealisasiModel.isEmpty
                        ? 1
                        : (controller.doRealisasiModel.length / rowsPerPage)
                            .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ],
              );
            });
          }
        },
      ),
    );
  }
}

class EditTypeKendaraan extends StatefulWidget {
  const EditTypeKendaraan(
      {super.key, required this.controller, required this.model});

  final DoRegulerController controller;
  final DoRealisasiModel model;

  @override
  State<EditTypeKendaraan> createState() => _EditTypeKendaraanState();
}

class _EditTypeKendaraanState extends State<EditTypeKendaraan> {
  late int id;
  late int jumlahUnit;
  late String plant;
  late String tujuan;
  late int type;
  late String jenisKen;
  late String noPolisi;
  late String supir;
  late TextEditingController unitMotor;
  late int totalPlot;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    jumlahUnit = widget.model.jumlahUnit;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    type = widget.model.type;
    jenisKen = '${widget.model.inisialDepan}${widget.model.inisialBelakang}';
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    unitMotor = TextEditingController(text: widget.model.jumlahUnit.toString());

    // total plot
    final plotController = Get.put(PlotRealisasiController());
    plotController.fetchPlotRealisasi(id, jumlahUnit);
    totalPlot = plotController.plotModelRealisasi.first.jumlahPlot;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
