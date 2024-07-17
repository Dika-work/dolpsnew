import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_kurang_all.dart';

class KurangAllRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoKurangAllModel>> fetchGlobalHarianContent() async {
    final response = await http.get(
        Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_kurang_all.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoKurangAllModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
    }
  }
}
