import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/estimasi_pengambilan_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/empty_data_source.dart';
import '../../utils/source/input data realisasi/estimasi_source.dart';

class TableEstimasiPM extends GetView<EstimasiPengambilanController> {
  const TableEstimasiPM({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDataEstimasiPengambilan();
    });
    late Map<String, double> columnEstimasi = {
      'No': double.nan,
      'Plant': 80,
      'Tujuan': 120,
      'Jumlah': double.nan,
      'Jumlah_M16': double.nan,
      'Jumlah_M40': double.nan,
      'Jumlah_M64': double.nan,
      'Jumlah_M86': double.nan,
      'Estimation_M16': double.nan,
      'Estimation_M40': double.nan,
      'Estimation_M64': double.nan,
      'Estimation_M86': double.nan,
      'TOTAL': double.nan,
    };

    late Map<String, double> columnEstimasiYamaha = {
      'No': double.nan,
      'Plant': 180,
      'Tujuan': 120,
      'Jumlah': double.nan,
      'Jumlah_M16': double.nan,
      'Jumlah_M40': double.nan,
      'Jumlah_M64': double.nan,
      'Jumlah_M86': double.nan,
      'Estimation_M16': double.nan,
      'Estimation_M40': double.nan,
      'Estimation_M64': double.nan,
      'Estimation_M86': double.nan,
      'TOTAL': double.nan,
    };

    const double rowHeight = 50.0;
    const double headerHeight = 56.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Table Estimasi Pengambilan Motor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadDataEstimasiPengambilan();
        },
        child: ListView(
          children: [
            Obx(
              () {
                if (controller.isLoadingEstimasi.value) {
                  return const CustomCircularLoader();
                } else {
                  final dataEstimasiSource = controller
                          .estimasiPengambilanModel.isEmpty
                      ? EmptyEstimasiSource()
                      : EstimasiSource(
                          estimasiModel: controller.estimasiPengambilanModel);

                  print(
                      "Is data empty: ${controller.estimasiPengambilanModel.isEmpty}");

                  final bool isTableEmpty =
                      controller.estimasiPengambilanModel.isEmpty;

                  final double tableHeight = isTableEmpty
                      ? 460
                      : headerHeight +
                          (rowHeight * 10).clamp(0,
                              headerHeight + (rowHeight * 10) - headerHeight);

                  List<GridColumn> columns = [
                    GridColumn(
                      width: columnEstimasi['No']!,
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
                      width: columnEstimasi['Plant']!,
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
                      width: columnEstimasi['Tujuan']!,
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
                      width: columnEstimasi['Jumlah']!,
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
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Jumlah_M16']!,
                      columnName: 'Jumlah_M16',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-16',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Jumlah_M40']!,
                      columnName: 'Jumlah_M40',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-40',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Jumlah_M64']!,
                      columnName: 'Jumlah_M64',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-64',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Jumlah_M86']!,
                      columnName: 'Jumlah_M86',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-86',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Columns for Total Estimasi
                    GridColumn(
                      width: columnEstimasi['Estimation_M16']!,
                      columnName: 'Estimation_M16',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-16',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Estimation_M40']!,
                      columnName: 'Estimation_M40',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-40',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Estimation_M64']!,
                      columnName: 'Estimation_M64',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-64',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['Estimation_M86']!,
                      columnName: 'Estimation_M86',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-86',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasi['TOTAL']!,
                      columnName: 'TOTAL',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'TOTAL',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ];

                  return SizedBox(
                    height: tableHeight,
                    child: SfDataGrid(
                      source: dataEstimasiSource,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.horizontal,
                      columns: columns,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: [
                              'Jumlah_M16',
                              'Jumlah_M40',
                              'Jumlah_M64',
                              'Jumlah_M86'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Jumlah Ritase Mobil',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          StackedHeaderCell(
                            columnNames: [
                              'Estimation_M16',
                              'Estimation_M40',
                              'Estimation_M64',
                              'Estimation_M86'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Total Estimasi Unit Motor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Obx(
              () {
                if (controller.isLoadingEstimasi.value) {
                  return const CustomCircularLoader();
                } else {
                  final dataEstimasiSource =
                      controller.estimasiPengambilanModel.isEmpty
                          ? EmptyEstimasiYamahaSuzukiSource()
                          : EstimasiYamahaSuzuki(
                              estimasiYamahaModel:
                                  controller.estimasiPengambilanModel);

                  final bool isTableEmpty =
                      controller.estimasiPengambilanModel.isEmpty;

                  final double tableHeight = isTableEmpty
                      ? 213
                      : headerHeight +
                          (rowHeight * 4).clamp(
                              0, headerHeight + (rowHeight * 4) - headerHeight);

                  List<GridColumn> columns = [
                    GridColumn(
                      width: columnEstimasiYamaha['No']!,
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
                      width: columnEstimasiYamaha['Plant']!,
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
                      width: columnEstimasiYamaha['Tujuan']!,
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
                      width: columnEstimasiYamaha['Jumlah']!,
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
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Jumlah_M16']!,
                      columnName: 'Jumlah_M16',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-16',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Jumlah_M40']!,
                      columnName: 'Jumlah_M40',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-40',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Jumlah_M64']!,
                      columnName: 'Jumlah_M64',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-64',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Jumlah_M86']!,
                      columnName: 'Jumlah_M86',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-86',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Columns for Total Estimasi
                    GridColumn(
                      width: columnEstimasiYamaha['Estimation_M16']!,
                      columnName: 'Estimation_M16',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-16',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Estimation_M40']!,
                      columnName: 'Estimation_M40',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-40',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Estimation_M64']!,
                      columnName: 'Estimation_M64',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-64',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['Estimation_M86']!,
                      columnName: 'Estimation_M86',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'M-86',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GridColumn(
                      width: columnEstimasiYamaha['TOTAL']!,
                      columnName: 'TOTAL',
                      label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'TOTAL',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ];

                  return SizedBox(
                    height: tableHeight,
                    child: SfDataGrid(
                      source: dataEstimasiSource,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.horizontal,
                      columns: columns,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: [
                              'Jumlah_M16',
                              'Jumlah_M40',
                              'Jumlah_M64',
                              'Jumlah_M86'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Jumlah Ritase Mobil',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          StackedHeaderCell(
                            columnNames: [
                              'Estimation_M16',
                              'Estimation_M40',
                              'Estimation_M64',
                              'Estimation_M86'
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Total Estimasi Unit Motor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
