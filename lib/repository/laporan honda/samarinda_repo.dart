import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/laporan honda/samarinda_model.dart';
import '../../utils/constant/storage_util.dart';

class SamarindaRepository {
  final storageUtil = StorageUtil();

  Future<List<SamarindaModel>> fetchLaporanSamarinda(int tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_laporan_samarinda.php?action=all_data&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => SamarindaModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }
}
