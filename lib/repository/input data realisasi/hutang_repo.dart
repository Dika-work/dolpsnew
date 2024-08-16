import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/input data realisasi/hutang_reguler_model.dart';
import '../../utils/constant/storage_util.dart';

class HutangRepository {
  final storageUtil = StorageUtil();
  // hutang
  Future<List<HutangRegulerModel>> fetchHutang(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=HutangAcc&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI HUTANG REGULER.. ${list.toList()}');
      return list.map((e) => HutangRegulerModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do Mutasi');
    }
  }

  // kelengkapan
  Future<List<AlatKelengkapanModel>> fetchKelengkapan(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=ListAcc&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI HUTANG REGULER.. ${list.toList()}');
      return list.map((e) => AlatKelengkapanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do Mutasi');
    }
  }
}
