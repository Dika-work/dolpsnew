import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/laporan honda/laporan_plant_model.dart';
import '../../utils/constant/storage_util.dart';

class LaporanPlantRepository {
  final storageUtil = StorageUtil();

  Future<List<LaporanPlantModel>> fetchLaporanPlant(
      String bulan, String tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_laporan_harian.php?action=all_data&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      // print('INI HASIL DARI LAPORAN PLANT REPOSITORY: ${list.toList()}');
      return list.map((model) => LaporanPlantModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data laporan harian☠️');
    }
  }

  Future<List<LaporanDoRealisasiModel>> fetchLaporanRealisasi(
      String bulan, String tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_laporan_realisasi.php?action=all_data&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('INI HASIL DARI LAPORAN DO REALISASI: ${list.toList()}');
      return list.map((e) => LaporanDoRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil laporan do realisasi');
    }
  }
}
