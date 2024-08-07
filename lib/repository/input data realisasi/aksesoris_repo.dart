import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/aksesoris_model.dart';

class AksesorisRepository {
  final storageUtil = StorageUtil();

  Future<List<AksesorisModel>> fetchAksesoris(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=JumlahAcc&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => AksesorisModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }
}
