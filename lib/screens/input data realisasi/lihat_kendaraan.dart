import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/lihat_kendaraan_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/source/input data realisasi/lihat_kendaraan_source.dart';

class LihatKendaraanScreen extends StatelessWidget {
  const LihatKendaraanScreen({super.key, required this.model});

  final RequestKendaraanModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LihatKendaraanController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLihatKendaraan(
        model.type,
        model.plant,
        model.idReq,
      );
    });

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'No Kendaraan': 150,
      'Jenis': 150,
      'Supir': 150,
    };

    const int rowsPerPage = 10;
    int currentPage = 0;
    const double rowHeight = 50.0;
    const double headerHeight = 56.0;

    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    return Obx(
      () {
        final dataSource = LihatKendaraanSource(
          lihatKendaraanModel: controller.lihatModel,
          startIndex: currentPage * rowsPerPage,
        );

        final bool isTableEmpty = controller.lihatModel.isEmpty;
        final bool isNotTableEmpty = controller.lihatModel.isNotEmpty;

        final rowCount = controller.lihatModel.length;

        final double tableHeight = isTableEmpty
            ? 110
            : headerHeight +
                (rowHeight * rowCount).clamp(0, gridHeight - headerHeight);
        return AlertDialog(
          title: Center(
            child: Text('Detail Request Kendaraan',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          content: SizedBox(
              width: double.maxFinite,
              child: controller.isLoadingLihat.value &&
                      controller.lihatModel.isEmpty
                  ? const CustomCircularLoader()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: tableHeight,
                          child: SfDataGrid(
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isNotTableEmpty)
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
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Close'),
              ),
            ),
          ],
        );
      },
    );
  }
}
