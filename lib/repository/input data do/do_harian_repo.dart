import 'dart:convert';

import 'package:doplsnew/models/do_harian_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class DataDoHarianRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoHarianModel>> fetchDataHarianContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_harian.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoHarianModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Harian☠️');
    }
  }
}
