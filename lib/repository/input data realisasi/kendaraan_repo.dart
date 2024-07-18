import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../models/input data realisasi/kendaraan_model.dart';

class KendaraanRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<KendaraanModel>> fetchKendaraanContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/kendaraan_tampil.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => KendaraanModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }
}
