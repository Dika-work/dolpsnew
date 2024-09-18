import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/laporan honda/laporan_estimasi_model.dart';

class LaporanEstimasiRepository {
  final storageUtil = StorageUtil();

  Future<List<LaporanEstimasiModel>> fetchLaporanEstimasi(
      String bulan, String tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_laporan_estimasi.php?action=all_data&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => LaporanEstimasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data laporan estimasi☠️');
    }
  }
}
