import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan honda/laporan_plant_model.dart';

class LaporanPlantSource extends DataGridSource {
  final int selectedYear;
  final int selectedMonth;
  final int lastDayOfMonth;
  final List<LaporanPlantModel> plantModel;
  final List<LaporanDoRealisasiModel> plantRealisasi;
  final String selectedPlant;

  LaporanPlantSource(
      {required this.plantModel,
      required this.plantRealisasi,
      required this.selectedYear,
      required this.selectedMonth,
      required this.selectedPlant})
      : lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day {
    _buildData();
  }

  List<DataGridRow> laporanData = [];

  void _buildData() {
    // Daftar daerah
    List<String> regions = ['SRD', 'MKS', 'PTK', 'BJM'];
    Map<String, String> regionMapping = {
      'SRD': 'SAMARINDA',
      'MKS': 'MAKASAR',
      'PTK': 'PONTIANAK',
      'BJM': 'BANJARMASIN'
    };

    // Generate data untuk setiap daerah
    for (String region in regions) {
      List<int> totalDO = List.generate(lastDayOfMonth, (index) => 0);
      List<int> realisasiDO = List.generate(lastDayOfMonth, (index) => 0);
      List<int> unfilledDO = List.generate(lastDayOfMonth, (index) => 0);

      // Get TOTAL DO HARIAN from LaporanPlantModel
      for (var model in plantModel) {
        if (int.parse(model.bulan) == selectedMonth &&
            model.tahun == selectedYear.toString() &&
            model.plant == selectedPlant) {
          int day = int.parse(model.tgl.split('-')[2]);

          switch (region) {
            case 'SRD':
              totalDO[day - 1] += model.totalHarianSRD;
              break;
            case 'MKS':
              totalDO[day - 1] += model.totalHarianMKS;
              break;
            case 'PTK':
              totalDO[day - 1] += model.totalHarianPTK;
              break;
            case 'BJM':
              totalDO[day - 1] += model.totalHarianBJM;
              break;
          }
        }
      }

      // Get DO REALISASI from LaporanDoRealisasiModel
      for (var realisasi in plantRealisasi) {
        if (int.parse(realisasi.bulan) == selectedMonth &&
            realisasi.tahun == selectedYear.toString() &&
            realisasi.plant == selectedPlant) {
          int day = int.parse(realisasi.tgl.split('-')[2]);

          if (realisasi.daerah == regionMapping[region]) {
            realisasiDO[day - 1] += realisasi.jumlahMotor;
          }
        }
      }

      // Calculate UNFILLED DO as the difference between TOTAL DO HARIAN and DO REALISASI
      for (int i = 0; i < lastDayOfMonth; i++) {
        unfilledDO[i] = totalDO[i] - realisasiDO[i];
      }

      // Calculate totals for each category
      int totalDOHarian = totalDO.reduce((a, b) => a + b);
      int totalRealisasiDO = realisasiDO.reduce((a, b) => a + b);
      int totalUnfilledDO = unfilledDO.reduce((a, b) => a + b);

      // Add rows for the region
      laporanData.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Daerah', value: region),
          ...List.generate(
            lastDayOfMonth,
            (index) =>
                DataGridCell<String>(columnName: 'Total DO $index', value: '-'),
          ),
          const DataGridCell<String>(columnName: 'TOTAL', value: '-'),
        ]),
      );

      // Add row for TOTAL DO HARIAN
      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'TOTAL DO HARIAN'),
          ...List.generate(
            lastDayOfMonth,
            (index) => DataGridCell<int>(
                columnName: 'Total DO Harian $index', value: totalDO[index]),
          ),
          DataGridCell<int>(columnName: 'TOTAL', value: totalDOHarian),
        ]),
      );

      // Add row for DO REALISASI
      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'DO REALISASI'),
          ...List.generate(
            lastDayOfMonth,
            (index) => DataGridCell<int>(
                columnName: 'Realisasi DO $index', value: realisasiDO[index]),
          ),
          DataGridCell<int>(columnName: 'TOTAL', value: totalRealisasiDO),
        ]),
      );

      // Add row for DO UNFILLED
      laporanData.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Daerah', value: 'DO UNFILLED'),
          ...List.generate(
            lastDayOfMonth,
            (index) => DataGridCell<int>(
                columnName: 'Unfilled DO $index', value: unfilledDO[index]),
          ),
          DataGridCell<int>(columnName: 'TOTAL', value: totalUnfilledDO),
        ]),
      );
    }
  }

  @override
  List<DataGridRow> get rows => laporanData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final region = row.getCells().first.value.toString();

    Color backgroundColor;
    switch (region) {
      case 'SRD':
        backgroundColor = Colors.yellow.shade300;
        break;
      case 'MKS':
        backgroundColor = Colors.yellow.shade300;
        break;
      case 'PTK':
        backgroundColor = Colors.yellow.shade300;
        break;
      case 'BJM':
        backgroundColor = Colors.yellow.shade300;
        break;
      default:
        backgroundColor = Colors.white;
    }

    return DataGridRowAdapter(
        color: backgroundColor,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              dataGridCell.value.toString(),
              style: TextStyle(
                  color: (dataGridCell.columnName.contains('Unfilled') &&
                          dataGridCell.value < 0)
                      ? Colors.red
                      : Colors.black),
            ),
          );
        }).toList());
  }
}
