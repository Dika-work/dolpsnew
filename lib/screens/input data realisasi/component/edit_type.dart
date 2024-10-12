import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/edit_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../controllers/master data/type_motor_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../models/input data realisasi/edit_type_motor_model.dart';
import '../../../models/master data/type_motor_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/popups/dialogs.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/source/input data realisasi/edit_type_kendaraan_source.dart';
import '../../../utils/theme/app_colors.dart';

class EditTypeKendaraan extends StatefulWidget {
  const EditTypeKendaraan(
      {super.key, required this.model, required this.onConfirm});

  final DoRealisasiModel model;
  final void Function()? onConfirm;

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
  final typeMotorHondaController = Get.put(TypeMotorHondaController());
  final controller = Get.put(EditTypeMotorController());

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
    typeMotorHondaController.fetchTypeMotorHonda();

    // Fetch total plot
    fetchTotalPlot();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllTypeMotorById(id);
    });
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
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': 120,
      'Daerah Tujuan': 120,
      'Jumlah': 120,
      'Action': 230,
    };

    const int rowsPerPage = 5;
    int currentPage = 0;
    const double rowHeight = 80.0;
    const double headerHeight = 50.0;
    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Type Kendaraan',
            maxLines: 2,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: PopScope(
          canPop: false,
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomSize.md, vertical: CustomSize.lg),
            children: [
              const Text('Plant'),
              TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: plant,
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Tujuan'),
              TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
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
                        // Set nilai awal selectedTypeMotor dengan model.typeMotor
                        typeMotorHondaController
                            .setSelectedTypeMotor(model.typeMotor);

                        // Inisialisasi nilai default
                        String selectedTypeMotor = model.typeMotor;
                        String selectedDaerah = model.daerah;
                        String jumlahMotor = model.jumlah.toString();

                        CustomDialogs.defaultDialog(
                          context: context,
                          titleWidget: Text(
                            'Edit Type Kendaraan',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          confirmText: 'Save',
                          onConfirm: () {
                            print('..INI VALUE YANG BERUBAH..');
                            print('Type Motor: $selectedTypeMotor');
                            print('Daerah Tujuan: $selectedDaerah');
                            print('Jumlah: $jumlahMotor');
                            print('...SELESAI....');
                            controller.editTypeMotorContent(
                                model.id,
                                model.idPacking,
                                selectedTypeMotor,
                                selectedDaerah,
                                int.parse(jumlahMotor),
                                fetchTotalPlot);
                          },
                          contentWidget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Type Motor')),
                                  const SizedBox(width: CustomSize.md),
                                  Expanded(
                                    flex: 2,
                                    child: Obx(() {
                                      return DropdownSearch<
                                          TypeMotorHondaModel>(
                                        items: typeMotorHondaController
                                            .typeMotorHondaModel,
                                        itemAsString:
                                            (TypeMotorHondaModel kendaraan) =>
                                                kendaraan.typeMotor,
                                        selectedItem: typeMotorHondaController
                                            .typeMotorHondaModel
                                            .firstWhere(
                                          (motor) =>
                                              motor.typeMotor ==
                                              model.typeMotor,
                                          orElse: () => typeMotorHondaController
                                              .typeMotorHondaModel.first,
                                        ),
                                        dropdownBuilder: (context,
                                            TypeMotorHondaModel? selectedItem) {
                                          return Text(
                                            selectedItem != null
                                                ? selectedItem.typeMotor
                                                : 'Pilih Type Motor',
                                            style: TextStyle(
                                              color: selectedItem == null
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          );
                                        },
                                        onChanged:
                                            (TypeMotorHondaModel? kendaraan) {
                                          if (kendaraan != null) {
                                            selectedTypeMotor =
                                                kendaraan.typeMotor;
                                            typeMotorHondaController
                                                .setSelectedTypeMotor(
                                                    kendaraan.typeMotor);
                                          } else {
                                            typeMotorHondaController
                                                .resetSelectedTypeMotor();
                                          }
                                        },
                                        popupProps: const PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              hintText: 'Search Type Motor...',
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              model.daerah == '-'
                                  ? const SizedBox.shrink()
                                  : const SizedBox(
                                      height: CustomSize.spaceBtwItems),
                              model.daerah == '-'
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        const Expanded(
                                            flex: 1,
                                            child: Text('Daerah\nTujuan')),
                                        const SizedBox(width: CustomSize.md),
                                        Expanded(
                                          flex: 2,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: model.daerah,
                                            items: [
                                              'SAMARINDA',
                                              'MAKASAR',
                                              'PONTIANAK',
                                              'BANJARMASIN'
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                selectedDaerah = newValue;
                                                setState(() {
                                                  model.daerah = newValue;
                                                });
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: CustomSize.spaceBtwItems),
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Jumlah')),
                                  const SizedBox(width: CustomSize.md),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      initialValue: model.jumlah.toString(),
                                      onChanged: (value) {
                                        jumlahMotor = value;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      onDeleted: (EditTypeMotorModel model) {
                        CustomDialogs.deleteDialog(
                          context: context,
                          onConfirm: () => controller.hapusTypeMotorContent(
                              model.id, model.idPacking, fetchTotalPlot),
                        );
                      },
                    );

                    final bool isTableEmpty =
                        controller.doRealisasiModel.isEmpty;
                    final rowCount = controller.doRealisasiModel.length;
                    final double tableHeight = isTableEmpty
                        ? 110
                        : headerHeight +
                            (rowHeight * rowCount)
                                .clamp(0, gridHeight - headerHeight);

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            SizedBox(
                              height: tableHeight,
                              child: SfDataGrid(
                                  source: dataSource,
                                  rowHeight: 65,
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
                                          border:
                                              Border.all(color: Colors.grey),
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
                                          border:
                                              Border.all(color: Colors.grey),
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
                                          border:
                                              Border.all(color: Colors.grey),
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
                                          border:
                                              Border.all(color: Colors.grey),
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
                                      width: columnWidths['Action']!,
                                      columnName: 'Action',
                                      label: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.lightBlue.shade100,
                                        ),
                                        child: Text(
                                          'Action',
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
                            if (controller.doRealisasiModel.length >= 5)
                              const SizedBox(height: CustomSize.spaceBtwItems),
                            if (controller.doRealisasiModel.length >= 5)
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
                      CustomFullScreenLoader.stopLoading();
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
                    onPressed: widget.onConfirm,
                    // onPressed: () => controller.editdanHapusTypeKendaraan(id),
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
          ),
        ));
  }
}
