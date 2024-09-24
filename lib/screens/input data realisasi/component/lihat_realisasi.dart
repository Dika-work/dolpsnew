import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/hutang_reguler_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../controllers/input data realisasi/tambah_type_motor_mutasi_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/source/input data realisasi/reguler_kelengkapan_dan_hutang_source.dart';
import '../../../utils/source/input data realisasi/tambah_type_motor_source.dart';
import '../../../utils/source/input data realisasi/tambah_type_mutasi_source.dart';

class LihatRealisasi extends StatelessWidget {
  const LihatRealisasi({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahTypeMotorController());
    final controllerMutasi = Get.put(TambahTypeMotorMutasiController());
    final hutangController = Get.put(HutangRegulerController());
    final parsedDate = DateFormat('yyyy-MM-dd').parse(model.tgl);

    const int rowsPerPage = 5;
    int currentPage = 0;
    const double rowHeight = 50.0;
    const double headerHeight = 56.0;
    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (model.type == 0) {
        await controller.fetchTambahTypeMotor(model.id);
        await hutangController.fetchKelengkapan(model.id);
        await hutangController.fetchHutang(model.id);
      } else if (model.type == 1) {
        await controllerMutasi.fetchTambahTypeMotorMutasi(model.id);
      }
    });

    late Map<String, double> columnWidths = {
      'No': 50,
      'Type Motor': double.nan,
      'SRD': 70,
      'MKS': 70,
      'PTK': 70,
      'BJM': 70,
    };

    late Map<String, double> columnWidthsMutasi = {
      'No': double.nan,
      'Type Motor': 130,
      'Unit': double.nan,
    };

    late Map<String, double> columnWidthsHutang = {
      'HLM': 70,
      'AC': 70,
      'KS': 70,
      'TS': 70,
      'BP': 70,
      'BS': 70,
      'PLT': 70,
      'STAY L/R': 70,
      'AC BESAR': 70,
      'PLASTIK': 70,
    };

    Widget buildHutangPabrik(
        String label1, String label2, String value1, String value2) {
      return Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                label1,
                style: Theme.of(context).textTheme.labelLarge,
              )),
          Text(
            ' : ',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Expanded(
              flex: 2,
              child: Text(
                value1,
                style: Theme.of(context).textTheme.labelMedium,
              )),
          const SizedBox(width: 8.0),
          Expanded(
              flex: 1,
              child: Text(
                label2,
                style: Theme.of(context).textTheme.labelLarge,
              )),
          Text(
            ' : ',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Expanded(
              flex: 2,
              child: Text(
                value2,
                style: Theme.of(context).textTheme.labelMedium,
              )),
        ],
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomSize.md, vertical: CustomSize.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                model.type == 0
                    ? 'PACKING LIST KENDARAAN\nPT. LANGGENG PRANAMAS SENTOSA'
                    : 'PACKING LIST KENDARAAN\nPT. LANGGENG PRANAMAS SENTOSA MUTASI',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: CustomSize.xs),
            buildHutangPabrik('Tgl', 'No\nPolisi',
                DateFormat('dd MMM yyyy').format(parsedDate), model.noPolisi),
            const SizedBox(height: CustomSize.xs),
            buildHutangPabrik('Plant', 'Supir', model.plant, model.supir),
            const SizedBox(height: CustomSize.xs),
            buildHutangPabrik('Tujuan', 'Jenis', model.tujuan,
                '${model.inisialDepan}${model.inisialBelakang}'),
            const SizedBox(height: CustomSize.xs),
            buildHutangPabrik(
                'Type',
                'Jml\nUnit Motor',
                model.type == 0 ? 'REGULER' : 'MUTASI',
                model.jumlahUnit.toString()),
            const SizedBox(height: CustomSize.sm),
            model.type == 0
                ? Obx(
                    () {
                      if (controller.isLoadingTambahType.value &&
                          controller.tambahTypeMotorModel.isEmpty) {
                        return const CustomCircularLoader();
                      } else {
                        final dataSource = TambahTypeMotorSource(
                          tambahTypeMotorModel: controller.tambahTypeMotorModel,
                        );

                        final bool isTableEmpty =
                            controller.tambahTypeMotorModel.isEmpty;
                        final rowCount =
                            controller.tambahTypeMotorModel.length + 1;
                        final double tableHeight = isTableEmpty
                            ? 110
                            : headerHeight +
                                (rowHeight * rowCount)
                                    .clamp(0, gridHeight - headerHeight);

                        return Column(
                          children: [
                            SizedBox(
                              height: tableHeight,
                              child: SfDataGrid(
                                  source: dataSource,
                                  columnWidthMode: ColumnWidthMode.auto,
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
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'No',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['Type Motor']!,
                                        columnName: 'Type Motor',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Type Motor',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['SRD']!,
                                        columnName: 'SRD',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'SRD',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['MKS']!,
                                        columnName: 'MKS',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'MKS',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['PTK']!,
                                        columnName: 'PTK',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'PTK',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        width: columnWidths['BJM']!,
                                        columnName: 'BJM',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'BJM',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                  ]),
                            ),
                            if (controller.tambahTypeMotorModel.isNotEmpty)
                              SfDataPager(
                                delegate: dataSource,
                                pageCount: isTableEmpty
                                    ? 1
                                    : (rowCount / rowsPerPage).ceilToDouble(),
                                direction: Axis.horizontal,
                              ),
                          ],
                        );
                      }
                    },
                  )
                : const SizedBox.shrink(),
            model.type == 1
                ? Obx(
                    () {
                      if (controllerMutasi.isLoadingMutasi.value &&
                          controllerMutasi.tambahTypeMotorMutasiModel.isEmpty) {
                        return const CustomCircularLoader();
                      } else {
                        final dataSource = TambahTypeMutasiSource(
                            tambahTypeMotorMutasiModel:
                                controllerMutasi.tambahTypeMotorMutasiModel,
                            startIndex: currentPage * rowsPerPage);

                        final bool isTableEmpty =
                            controllerMutasi.tambahTypeMotorMutasiModel.isEmpty;
                        final rowCount =
                            controllerMutasi.tambahTypeMotorMutasiModel.length +
                                1;
                        final double tableHeight = isTableEmpty
                            ? 110
                            : headerHeight +
                                (rowHeight * rowCount)
                                    .clamp(0, gridHeight - headerHeight);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: tableHeight,
                              child: SfDataGrid(
                                source: dataSource,
                                columnWidthMode: ColumnWidthMode.fill,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                verticalScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                columns: [
                                  GridColumn(
                                    width: columnWidthsMutasi['No']!,
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
                                    width: columnWidthsMutasi['Type Motor']!,
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
                                    width: columnWidthsMutasi['Unit']!,
                                    columnName: 'Unit',
                                    label: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.lightBlue.shade100,
                                      ),
                                      child: Text(
                                        'Unit',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (controllerMutasi
                                .tambahTypeMotorMutasiModel.isNotEmpty)
                              SfDataPager(
                                delegate: dataSource,
                                pageCount: isTableEmpty
                                    ? 1
                                    : (rowCount / rowsPerPage).ceilToDouble(),
                                direction: Axis.horizontal,
                              ),
                          ],
                        );
                      }
                    },
                  )
                : const SizedBox.shrink(),
            // Kelengkapan
            if (model.type == 0)
              const Divider(
                  height: CustomSize.dividerHeight, color: AppColors.black),
            if (model.type == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: CustomSize.sm),
                  child: Text('ALAT-ALAT MOTOR DARI PABRIK',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.apply(color: AppColors.success)),
                ),
              ),
            if (model.type == 0) const SizedBox(height: CustomSize.sm),
            model.type == 0
                ? Obx(() {
                    if (hutangController.isLoadingHutang.value &&
                        hutangController.doKelengkapan.isEmpty) {
                      return const CustomCircularLoader();
                    } else {
                      final dataSourceHutang = KelengkapanAlatSource(
                          alatModel: hutangController.doKelengkapan);

                      final bool isTableEmpty =
                          hutangController.doKelengkapan.isEmpty;
                      final rowCount = hutangController.doKelengkapan.length;
                      final double tableHeight = isTableEmpty
                          ? 110
                          : headerHeight +
                              (rowHeight * rowCount)
                                  .clamp(0, gridHeight - headerHeight);

                      return Column(
                        children: [
                          SizedBox(
                            height: tableHeight,
                            child: SfDataGrid(
                                source: dataSourceHutang,
                                columnWidthMode: ColumnWidthMode.auto,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                verticalScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                columns: [
                                  GridColumn(
                                      width: columnWidthsHutang['HLM']!,
                                      columnName: 'HLM',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'HLM',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['AC']!,
                                      columnName: 'AC',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'AC',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['KS']!,
                                      columnName: 'KS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'KS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['TS']!,
                                      columnName: 'TS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'TS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['BP']!,
                                      columnName: 'BP',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'BP',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['BS']!,
                                      columnName: 'BS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'BS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['PLT']!,
                                      columnName: 'PLT',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'PLT',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['STAY L/R']!,
                                      columnName: 'STAY L/R',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'STAY L/R',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['AC BESAR']!,
                                      columnName: 'AC BESAR',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'AC BESAR',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['PLASTIK']!,
                                      columnName: 'PLASTIK',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'PLASTIK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                ]),
                          ),
                          hutangController.doKelengkapan.isEmpty
                              ? const SizedBox.shrink()
                              : SfDataPager(
                                  delegate: dataSourceHutang,
                                  pageCount: isTableEmpty
                                      ? 1
                                      : (rowCount / rowsPerPage).ceilToDouble(),
                                  direction: Axis.horizontal,
                                ),
                        ],
                      );
                    }
                  })
                : const SizedBox.shrink(),
            // Hutang
            if (model.type == 0)
              const Divider(
                  height: CustomSize.dividerHeight, color: AppColors.black),
            if (model.type == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: CustomSize.sm),
                  child: Text('HUTANG ALAT-ALAT MOTOR DARI PABRIK',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.apply(color: AppColors.error)),
                ),
              ),
            if (model.type == 0) const SizedBox(height: CustomSize.sm),
            model.type == 0
                ? Obx(() {
                    if (hutangController.isLoadingHutang.value &&
                        hutangController.doHutang.isEmpty) {
                      return const CustomCircularLoader();
                    } else {
                      final dataSourceHutang = RegulerHutangSource(
                          doHutangModel: hutangController.doHutang);

                      final bool isTableEmpty =
                          hutangController.doHutang.isEmpty;
                      final rowCount = hutangController.doHutang.length;
                      final double tableHeight = isTableEmpty
                          ? 110
                          : headerHeight +
                              (rowHeight * rowCount)
                                  .clamp(0, gridHeight - headerHeight);
                      return Column(
                        children: [
                          SizedBox(
                            height: tableHeight,
                            child: SfDataGrid(
                                source: dataSourceHutang,
                                columnWidthMode: ColumnWidthMode.auto,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                verticalScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                columns: [
                                  GridColumn(
                                      width: columnWidthsHutang['HLM']!,
                                      columnName: 'HLM',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'HLM',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['AC']!,
                                      columnName: 'AC',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'AC',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['KS']!,
                                      columnName: 'KS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'KS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['TS']!,
                                      columnName: 'TS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'TS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['BP']!,
                                      columnName: 'BP',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'BP',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['BS']!,
                                      columnName: 'BS',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'BS',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['PLT']!,
                                      columnName: 'PLT',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'PLT',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['STAY L/R']!,
                                      columnName: 'STAY L/R',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'STAY L/R',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['AC BESAR']!,
                                      columnName: 'AC BESAR',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'AC BESAR',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidthsHutang['PLASTIK']!,
                                      columnName: 'PLASTIK',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'PLASTIK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                ]),
                          ),
                          if (hutangController.doHutang.isNotEmpty)
                            SfDataPager(
                              delegate: dataSourceHutang,
                              pageCount: isTableEmpty
                                  ? 1
                                  : (rowCount / rowsPerPage).ceilToDouble(),
                              direction: Axis.horizontal,
                            ),
                        ],
                      );
                    }
                  })
                : const SizedBox.shrink(),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () => Get.back(), child: const Text('Kembali')),
            )
          ],
        ),
      ),
    );
  }
}
