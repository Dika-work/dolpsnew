import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/tampil seluruh data/do_tambah_all.dart';

class TambahAllRepository {
  final storageUtil = StorageUtil();

  Future<List<DoTambahAllModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_tambah.php?action=getDataAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoTambahAllModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
    }
  }
}
