import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/laporan honda/laporan_realisasi_model.dart';

class LaporanRealisasiRepository {
  final storagUtil = StorageUtil();

  Future<List<LaporanRealisasiModel>> fetchLaporanRealisasi(
      int bulan, int tahun) async {
    final response = await http.get(Uri.parse(
        '${storagUtil.baseURL}/DO/api/api_laporan_realisasi.php?action=laporan_realisasi&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil response laporan realisasi: ${list.toList()}');
      return list.map((e) => LaporanRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data laporan realisasi');
    }
  }
}
