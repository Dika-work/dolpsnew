import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/sopir_model.dart';

class SopirRepository {
  final storageUtil = StorageUtil();

  Future<List<SopirModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_master_data.php?action=Sopir'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => SopirModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }
}
