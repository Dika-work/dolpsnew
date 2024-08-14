import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/source/input data realisasi/tambah_type_mutasi_source.dart';
import '../../../utils/theme/app_colors.dart';

class TerimaMotorMutasi extends StatefulWidget {
  const TerimaMotorMutasi({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<TerimaMotorMutasi> createState() => _TerimaMotorMutasiState();
}

class _TerimaMotorMutasiState extends State<TerimaMotorMutasi> {
  late int id;
  late String tujuan;
  late String plant;
  late int type;
  late String jenis;
  late String noPolisi;
  late String supir;
  late int jumlahUnit;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type;
    jenis = widget.model.jenisKen;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    jumlahUnit = widget.model.jumlahUnit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TambahTypeMotorMutasiController>()
          .fetchTambahTypeMotorMutasi(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahTypeMotorMutasiController());
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': 150,
      'Jumlah Unit': double.nan,
    };

    const int rowsPerPage = 5;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cheking Mutasi Unit Motor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomSize.md, vertical: CustomSize.lg),
        children: [
          _buildAlignedText('Tujuan', tujuan),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('Plant', plant),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('Type', type == 0 ? 'REGULER' : 'MUTASI'),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('Jenis', jenis),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('No Polisi', noPolisi),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('Supir', supir),
          const SizedBox(height: CustomSize.spaceBtwItems),
          _buildAlignedText('Jumlah Unit', jumlahUnit.toString()),
          const SizedBox(height: CustomSize.spaceBtwInputFields),
          // table mutasi nya
          Obx(
            () {
              if (controller.isLoadingMutasi.value &&
                  controller.tambahTypeMotorMutasiModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = TambahTypeMutasiSource(
                    tambahTypeMotorMutasiModel:
                        controller.tambahTypeMotorMutasiModel,
                    startIndex: currentPage * rowsPerPage);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: SfDataGrid(
                        source: dataSource,
                        columnWidthMode: ColumnWidthMode.fill,
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
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            width: columnWidths['Jumlah Unit']!,
                            columnName: 'Jumlah Unit',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Jumlah Unit',
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
                      pageCount: controller.tambahTypeMotorMutasiModel.isEmpty
                          ? 1
                          : (controller.tambahTypeMotorMutasiModel.length /
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
                onPressed: () => controller.simpanDataMutasi(id),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                ),
                child: Text(
                  'Simpan Data',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.apply(color: AppColors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildAlignedText(String label, String valueTextForm) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            )),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: valueTextForm),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
        ),
      ],
    );
  }
}
