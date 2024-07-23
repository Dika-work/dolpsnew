import 'dart:convert';

import 'package:doplsnew/models/home/do_global_harian.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class DoGlobalHarianRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalHarianModel>> fetchGlobalHarianContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/api_do_global.php?action=getDataAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalHarianModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }
}
