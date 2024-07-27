import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/lihat_kendaraan_controller.dart';
import '../../controllers/input data realisasi/plot_kendaraan_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/source/input data realisasi/lihat_kendaraan_source.dart';

class LihatKendaraanScreen extends StatelessWidget {
  const LihatKendaraanScreen(
      {super.key,
      required this.model,
      required this.controller,
      required this.plotKendaraanController});

  final RequestKendaraanModel model;
  final LihatKendaraanController controller;
  final PlotKendaraanController plotKendaraanController;

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'No Kendaraan': 150,
      'Kapasitas': 150,
      'Supir': 150,
    };

    const int rowsPerPage = 10;

    int currentPage = 0;

    return Obx(
      () {
        final dataSource = LihatKendaraanSource(
          lihatKendaraanModel: controller.lihatModel,
          startIndex: currentPage * rowsPerPage,
        );
        return AlertDialog(
          content: SizedBox(
              width: double.maxFinite,
              child: controller.isLoadingLihat.value &&
                      controller.lihatModel.isEmpty
                  ? const CustomCircularLoader()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Detail Request Kendaraan',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: CustomSize.spaceBtwSections),
                        SfDataGrid(
                          source: dataSource,
                          columnWidthMode: ColumnWidthMode.auto,
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
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['No Kendaraan']!,
                              columnName: 'No Kendaraan',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'No Kendaraan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['Kapasitas']!,
                              columnName: 'Kapasitas',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Kapasitas',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['Supir']!,
                              columnName: 'Supir',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Supir',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SfDataPager(
                          delegate: dataSource,
                          pageCount: controller.lihatModel.isEmpty
                              ? 1
                              : (controller.lihatModel.length / rowsPerPage)
                                  .ceilToDouble(),
                          direction: Axis.horizontal,
                        ),
                      ],
                    )),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'),
            ),
            if (plotKendaraanController.isJumlahKendaraanSama.value)
              TextButton(
                onPressed: () {
                  print(
                      '..INI SAVE LOGIC PADA LIHAT DETAIL REQUEST KENDARAAN..');
                },
                child: const Text('Save'),
              ),
          ],
        );
      },
    );
  }
}
