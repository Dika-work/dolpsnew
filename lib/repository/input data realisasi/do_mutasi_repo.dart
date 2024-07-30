import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/do_realisasi_model.dart';

class DoMutasiRepository {
  final storageUtil = StorageUtil();

  Future<List<DoRealisasiModel>> fetchDoMutasiData() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=getDataMutasi'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => DoRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do Mutasi');
    }
  }
}
