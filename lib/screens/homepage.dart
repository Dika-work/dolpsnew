import 'package:doplsnew/controllers/home/do_harian_home_bsk_controller.dart';
import 'package:doplsnew/controllers/home/do_harian_home_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/source/home/data_do_harian_bsk_source.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../controllers/home/do_global_harian_controller.dart';
import '../utils/source/empty_data_source.dart';
import '../utils/source/home/data_do_global_harian_source.dart';
import '../utils/source/home/data_do_harian_home_source.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataDOGlobalHarianController());
    final controllerHarianHome = Get.put(DataDOHarianHomeController());
    final controllerHarianBskHome = Get.put(DoHarianHomeBskController());

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': 80,
      'Tujuan': double.nan,
      'Jml': double.nan,
      'SRD': double.nan,
      'MKS': double.nan,
      'PTK': double.nan,
      'BJM': double.nan,
    };

    // Tinggi per baris dan header
    const double rowHeight = 50.0;
    const double headerHeight = 56.0;
    const int numberOfRows = 8;

    // Total tinggi untuk 7 baris termasuk header
    const double gridHeight = headerHeight + (rowHeight * numberOfRows);
    const double emptygridHeight = headerHeight + (rowHeight * 7);

    return RefreshIndicator(
      onRefresh: () async {
        await controllerHarianHome.fetchDataDoGlobal();
        await controllerHarianBskHome.fetchHarianBesok();
        await controller.fetchDataDoGlobal();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CustomSize.md),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'DO HARIAN TGL : ',
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: CustomHelperFunctions.getFormattedDate(
                          DateTime.now()),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.apply(color: AppColors.primary),
                    )
                  ],
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                if (controllerHarianHome.isLoadingGlobalHarian.value) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource =
                      controllerHarianHome.doHarianHomeModel.isEmpty
                          ? EmptyDataSource(
                              isAdmin: controllerHarianHome.roleUser ==
                                  'admin', // Berdasarkan respons JSON
                              userPlant: controllerHarianHome.rolePlant,
                            )
                          : DataDoHarianHomeSource(
                              doGlobalHarian:
                                  controllerHarianHome.doHarianHomeModel,
                              isAdmin: controllerHarianHome.isAdmin,
                              userPlant: controllerHarianHome.rolePlant);

                  final rowCount =
                      controllerHarianHome.doHarianHomeModel.length + 1;
                  final double tableHeight =
                      controllerHarianHome.doHarianHomeModel.isEmpty &&
                              controllerHarianHome.roleUser != 'admin'
                          ? 110
                          : headerHeight +
                              (rowHeight * rowCount)
                                  .clamp(0, gridHeight - headerHeight);

                  return SizedBox(
                    height: controllerHarianHome.roleUser == 'admin' &&
                            controllerHarianHome.doHarianHomeModel.isEmpty
                        ? emptygridHeight
                        : controllerHarianHome.roleUser == 'admin' &&
                                controllerHarianHome
                                    .doHarianHomeModel.isNotEmpty
                            ? gridHeight
                            : tableHeight,
                    child: SfDataGrid(
                      source: dataSource,
                      columnWidthMode: ColumnWidthMode.auto,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
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
                          width: columnWidths['Jml']!,
                          columnName: 'Jml',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Jml',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['SRD']!,
                          columnName: 'SRD',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'SRD',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['MKS']!,
                          columnName: 'MKS',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'MKS',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['PTK']!,
                          columnName: 'PTK',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'PTK',
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
                      ],
                    ),
                  );
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CustomSize.md),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'DO HARIAN TGL : ',
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: CustomHelperFunctions.getFormattedDate(
                          DateTime.now().add(const Duration(days: 1))),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.apply(color: AppColors.primary),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Tabel ketiga (menggunakan model dan controller yang berbeda)
          LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                if (controllerHarianBskHome.isLoadingGlobalHarian.value) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource =
                      controllerHarianBskHome.doHarianHomeBskModel.isEmpty
                          ? EmptyDataSource(
                              isAdmin: controllerHarianBskHome.roleUser ==
                                  'admin', // Berdasarkan respons JSON
                              userPlant: controllerHarianBskHome.rolePlant,
                            )
                          : DataDoHarianBskHomeSource(
                              doGlobalHarian:
                                  controllerHarianBskHome.doHarianHomeBskModel,
                              isAdmin: controllerHarianBskHome.isAdmin,
                              userPlant: controllerHarianBskHome.rolePlant);

                  final rowCount =
                      controllerHarianBskHome.doHarianHomeBskModel.length + 1;
                  final double tableHeight =
                      controllerHarianBskHome.doHarianHomeBskModel.isEmpty &&
                              controllerHarianBskHome.roleUser != 'admin'
                          ? 110
                          : headerHeight +
                              (rowHeight * rowCount)
                                  .clamp(0, gridHeight - headerHeight);

                  return SizedBox(
                    height: controllerHarianBskHome.roleUser == 'admin' &&
                            controllerHarianBskHome.doHarianHomeBskModel.isEmpty
                        ? emptygridHeight
                        : controllerHarianBskHome.roleUser == 'admin' &&
                                controllerHarianBskHome
                                    .doHarianHomeBskModel.isNotEmpty
                            ? gridHeight
                            : tableHeight,
                    child: SfDataGrid(
                      source: dataSource,
                      columnWidthMode: ColumnWidthMode.auto,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
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
                          width: columnWidths['Jml']!,
                          columnName: 'Jml',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Jml',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['SRD']!,
                          columnName: 'SRD',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'SRD',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['MKS']!,
                          columnName: 'MKS',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'MKS',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['PTK']!,
                          columnName: 'PTK',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'PTK',
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
                      ],
                    ),
                  );
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CustomSize.md),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'DO GLOBAL TGL : ',
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: CustomHelperFunctions.getFormattedDate(
                          DateTime.now()),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.apply(color: AppColors.primary),
                    )
                  ],
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                if (controller.isLoadingGlobalHarian.value) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource = controller.doGlobalHarianModel.isEmpty
                      ? EmptyDataSource(
                          isAdmin: controller.roleUser ==
                              'admin', // Berdasarkan respons JSON
                          userPlant: controller.rolePlant,
                        )
                      : DataDoGlobalHarianSource(
                          doGlobalHarian: controller.doGlobalHarianModel,
                          isAdmin: controller.isAdmin,
                          userPlant: controller.rolePlant);

                  final rowCount = controller.doGlobalHarianModel.length + 1;
                  final double tableHeight =
                      controller.doGlobalHarianModel.isEmpty &&
                              controller.roleUser != 'admin'
                          ? 110
                          : headerHeight +
                              (rowHeight * rowCount)
                                  .clamp(0, gridHeight - headerHeight);

                  return SizedBox(
                    height: controller.roleUser == 'admin' &&
                            controller.doGlobalHarianModel.isEmpty
                        ? emptygridHeight
                        : controller.roleUser == 'admin' &&
                                controller.doGlobalHarianModel.isNotEmpty
                            ? gridHeight
                            : tableHeight,
                    child: SfDataGrid(
                      source: dataSource,
                      columnWidthMode: ColumnWidthMode.auto,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
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
                          width: columnWidths['Jml']!,
                          columnName: 'Jml',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Jml',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['SRD']!,
                          columnName: 'SRD',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'SRD',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['MKS']!,
                          columnName: 'MKS',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'MKS',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          width: columnWidths['PTK']!,
                          columnName: 'PTK',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'PTK',
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
                      ],
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
