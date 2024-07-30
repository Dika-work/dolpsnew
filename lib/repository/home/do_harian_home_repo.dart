import 'dart:convert';

import 'package:doplsnew/models/home/do_harian_home.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

class DoHarianHomeRepository {
  final storageUtil = StorageUtil();

  Future<List<DoHarianHomeModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_harian.php?action=getDataFix'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoHarianHomeModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Home Harian☠️');
    }
  }
}
