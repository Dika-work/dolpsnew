import 'dart:convert';

import 'package:doplsnew/models/do_global_harian.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class DoGlobalHarianRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalHarianModel>> fetchGlobalHarianContent() async {
    final response = await http.get(
        Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_global_harian.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalHarianModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
    }
  }
}
