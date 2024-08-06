import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../models/input data realisasi/edit_type_motor_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/source/input data realisasi/edit_type_kendaraan_source.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dropdown.dart';

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
  int totalPlot = 0; // Inisialisasi dengan nilai default
  final plotController = Get.put(PlotRealisasiController());

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    jumlahUnit = widget.model.jumlahUnit;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    type = widget.model.type;
    jenisKen = widget.model.jenisKen;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    unitMotor = TextEditingController(text: widget.model.jumlahUnit.toString());

    // Fetch total plot
    fetchTotalPlot();
  }

  void fetchTotalPlot() async {
    await plotController.fetchPlotRealisasi(id, jumlahUnit);
    if (plotController.plotModelRealisasi.isNotEmpty) {
      setState(() {
        totalPlot = plotController.plotModelRealisasi.first.jumlahPlot;
      });
    } else {
      setState(() {
        totalPlot = 0; // Atau nilai default lainnya jika tidak ada data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditTypeMotorController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllTypeMotorById(id);
    });

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': double.nan,
      'Daerah Tujuan': double.nan,
      'Jumlah': 120,
      'Edit': 130,
      'Hapus': 130,
    };

    const int rowsPerPage = 5;
    int currentPage = 0;
    const double rowHeight = 65.0;
    const double headerHeight = 32.0;
    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Type Kendaraan',
            maxLines: 2,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomSize.md, vertical: CustomSize.lg),
          children: [
            Text('ini id nya : $id'),
            const Text('Plant'),
            DropDownWidget(
              value: plant,
              items: tujuanMap.keys.toList(),
              onChanged: (String? value) {
                setState(() {
                  print('Selected plant: $value');
                  plant = value!;
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
            const Text('Type'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: type == 0 ? 'REGULER' : 'MUTASI',
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: jenisKen,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('No Polisi'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: noPolisi,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Supir'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: supir,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Unit Motor'),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: unitMotor,
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Total Plot'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.truck_fast),
                  hintText: totalPlot.toString(),
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Obx(
              () {
                if (controller.isLoadingType.value &&
                    controller.doRealisasiModel.isEmpty) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource = EditTypeKendaraanSource(
                    startIndex: currentPage * rowsPerPage,
                    editTypeMotorModel: controller.doRealisasiModel,
                    onEdited: (EditTypeMotorModel model) {
                      print('..INI EDIT TYPE MOTOR..');
                    },
                    onDeleted: (EditTypeMotorModel model) {
                      print('..INI DELETED TYPE MOTOR..');
                    },
                  );

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          SizedBox(
                            height: gridHeight,
                            child: SfDataGrid(
                                source: dataSource,
                                rowHeight: 55,
                                columnWidthMode: ColumnWidthMode.auto,
                                allowPullToRefresh: true,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    width: columnWidths['Daerah Tujuan']!,
                                    columnName: 'Daerah Tujuan',
                                    label: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.lightBlue.shade100,
                                      ),
                                      child: Text(
                                        'Daerah Tujuan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: CustomSize.spaceBtwItems),
                          Center(
                            child: SfDataPager(
                              delegate: dataSource,
                              pageCount: controller.doRealisasiModel.isEmpty
                                  ? 1
                                  : (controller.doRealisasiModel.length /
                                          rowsPerPage)
                                      .ceilToDouble(),
                              direction: Axis.horizontal,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
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
                    print('...INI BAKALAN KE CLASS NAME EDIT TYPE...');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25.0),
                    backgroundColor: AppColors.success,
                  ),
                  child: Text(
                    'Simpan',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
