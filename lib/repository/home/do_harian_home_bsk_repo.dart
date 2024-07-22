import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/home/do_harian_home_bsk.dart';
import '../../utils/constant/storage_util.dart';

class DoHarianHomeBskRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoHarianHomeBskModel>> fetchGlobalHarianBesokContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_harian.php?action=getDataBesok'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoHarianHomeBskModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Home Harian☠️');
    }
  }
}
