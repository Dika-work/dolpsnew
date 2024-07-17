import 'dart:convert';

import 'package:doplsnew/models/tampil%20seluruh%20data/do_global_all.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GlobalAllRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalAllModel>> fetchGlobalHarianContent() async {
    final response = await http.get(
        Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_global_all.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalAllModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
    }
  }
}
