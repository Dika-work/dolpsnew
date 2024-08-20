import 'dart:convert';

import 'package:doplsnew/models/home/do_global_harian.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

class DoGlobalHarianRepository {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalHarianModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_global.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalHarianModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }
}
