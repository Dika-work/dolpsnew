import 'dart:convert';

import 'package:doplsnew/models/tampil%20seluruh%20data/do_harian_all_lps.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

class GlobalHarianAllLpsRepository {
  final storageUtil = StorageUtil();

  Future<List<DoHarianAllLpsModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_harian.php?action=getDataAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoHarianAllLpsModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
    }
  }
}
