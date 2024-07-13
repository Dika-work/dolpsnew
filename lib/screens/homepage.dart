import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../controllers/input data do/do_global_harian_controller.dart';
import '../utils/source/empty_data_source.dart';
import '../utils/source/home/data_do_global_harian_source.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataDOGlobalHarianController());

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': 100,
      'Tujuan': double.nan,
      'Jumlah': double.nan,
      'HSO - SRD': double.nan,
      'HSO - MKS': double.nan,
      'HSO - PTK': double.nan,
      'BJM': double.nan,
    };

    return ListView(
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
                    text:
                        CustomHelperFunctions.getFormattedDate(DateTime.now()),
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
                    ? EmptyDataSource()
                    : DataDoGlobalHarianSource(
                        doGlobalHarian: controller.doGlobalHarianModel,
                      );

                return SfDataGrid(
                  source: dataSource,
                  columnWidthMode: ColumnWidthMode.auto,
                  allowPullToRefresh: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  allowColumnsResizing: true,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                    columnWidths[details.column.columnName] = details.width;
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
                  ],
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
              if (controller.isLoadingGlobalHarian.value) {
                return const CustomCircularLoader();
              } else {
                final dataSource = controller.doGlobalHarianModel.isEmpty
                    ? EmptyDataSource()
                    : DataDoGlobalHarianSource(
                        doGlobalHarian: controller.doGlobalHarianModel,
                      );

                return SfDataGrid(
                  source: dataSource,
                  columnWidthMode: ColumnWidthMode.auto,
                  allowPullToRefresh: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  allowColumnsResizing: true,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                    columnWidths[details.column.columnName] = details.width;
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
                  ],
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
                    text:
                        CustomHelperFunctions.getFormattedDate(DateTime.now()),
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
                    ? EmptyDataSource()
                    : DataDoGlobalHarianSource(
                        doGlobalHarian: controller.doGlobalHarianModel,
                      );

                return SfDataGrid(
                  source: dataSource,
                  columnWidthMode: ColumnWidthMode.auto,
                  allowPullToRefresh: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  allowColumnsResizing: true,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                    columnWidths[details.column.columnName] = details.width;
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
                  ],
                );
              }
            });
          },
        ),
      ],
    );
  }
}
