import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/lihat_kendaraan_model.dart';

class LihatKendaraanRepository {
  final storageUtil = StorageUtil();

  Future<List<LihatKendaraanModel>> fetchLihatKendaraan(
      int type, String plant, int idReq) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=getDataReq&type=${type.toString()}&plant=$plant&id_request=${idReq.toString()}'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini isinya lihat kendaraan repo : ${list.toList()}');
      return list.map((e) => LihatKendaraanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data Kirim Kendaraan ☠');
    }
  }
}
