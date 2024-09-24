import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/laporan honda/laporan_dealer_model.dart';

class LaporanDealerRepository {
  final storageUtil = StorageUtil();

  Future<List<LaporanDealerModel>> fetchLaporanEstimasi(
      String bulan, String tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_laporan_dealer.php?action=search&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan dealer yg global: ${list.toList()}');
      return list.map((e) => LaporanDealerModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data laporan estimasi☠️');
    }
  }
}
