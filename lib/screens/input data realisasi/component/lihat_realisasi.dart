import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/loader/circular_loader.dart';
import '../../../utils/source/input data realisasi/tambah_type_motor_source.dart';

class LihatRealisasi extends StatelessWidget {
  const LihatRealisasi({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahTypeMotorController());
    final parsedDate = DateFormat('yyyy-MM-dd').parse(model.tgl);

    const int rowsPerPage = 5;
    int currentPage = 0;
    const double rowHeight = 55.0;
    const double headerHeight = 32.0;
    const double gridHeight = headerHeight + (rowHeight * rowsPerPage);

    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Type Motor': double.nan,
      'SRD': double.nan,
      'MKS': double.nan,
      'PTK': double.nan,
      'BJM': double.nan,
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'PACKING LIST KENDARAAN\nPT. LANGGENG PRANAMAS SENTOSA',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16.0),
            buildHutangPabrik('Tgl', 'No\nPolisi',
                DateFormat('dd MMM yyyy').format(parsedDate), model.noPolisi),
            const SizedBox(height: 8.0),
            buildHutangPabrik('Tujuan', 'Jenis', model.tujuan,
                '${model.inisialDepan}${model.inisialBelakang}'),
            const SizedBox(height: 8.0),
            buildHutangPabrik('Plant', 'Supir', model.plant, model.supir),
            const SizedBox(height: 8.0),
            buildHutangPabrik(
                'Type',
                'Jml\nUnit Motor',
                model.type == 0 ? 'REGULER' : 'MUTASI',
                model.jumlahUnit.toString()),
            const SizedBox(height: 16.0),
            // Tambahkan SfDataGrid di sini
            Obx(
              () {
                if (controller.isLoadingTambahType.value &&
                    controller.tambahTypeMotorModel.isEmpty) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource = TambahTypeMotorSource(
                    tambahTypeMotorModel: controller.tambahTypeMotorModel,
                    startIndex: currentPage * rowsPerPage,
                  );

                  return Column(
                    children: [
                      SizedBox(
                        height: gridHeight,
                        child: SfDataGrid(
                            source: dataSource,
                            columnWidthMode: ColumnWidthMode.auto,
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ))),
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
                                      ))),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ))),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ))),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ))),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ))),
                            ]),
                      ),
                      SfDataPager(
                        delegate: dataSource,
                        pageCount: controller.tambahTypeMotorModel.isEmpty
                            ? 1
                            : (controller.tambahTypeMotorModel.length /
                                    rowsPerPage)
                                .ceilToDouble(),
                        direction: Axis.horizontal,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Tambahkan Table statis jika masih diperlukan
            Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.bottom,
              thickness: 10.0,
              radius: const Radius.circular(CustomSize.cardRadiusMd),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 800.0, // Ensure the width is specified
                  padding: const EdgeInsets.only(bottom: CustomSize.md),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FixedColumnWidth(60.0),
                      1: FixedColumnWidth(60.0),
                      2: FixedColumnWidth(60.0),
                      3: FixedColumnWidth(60.0),
                      4: FixedColumnWidth(60.0),
                      5: FixedColumnWidth(60.0),
                      6: FixedColumnWidth(60.0),
                      7: FixedColumnWidth(80.0),
                      8: FixedColumnWidth(80.0),
                      9: FixedColumnWidth(60.0),
                    },
                    children: [
                      TableRow(
                        children: const [
                          TableCell(child: Center(child: Text('HLM'))),
                          TableCell(child: Center(child: Text('AC'))),
                          TableCell(child: Center(child: Text('KS'))),
                          TableCell(child: Center(child: Text('TS'))),
                          TableCell(child: Center(child: Text('BP'))),
                          TableCell(child: Center(child: Text('BS'))),
                          TableCell(child: Center(child: Text('PLT'))),
                          TableCell(child: Center(child: Text('STAY L/R'))),
                          TableCell(child: Center(child: Text('AC BESAR'))),
                          TableCell(child: Center(child: Text('PLASTIK'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          for (int i = 0; i < 10; i++)
                            TableCell(child: Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
