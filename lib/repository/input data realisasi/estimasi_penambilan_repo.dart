import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../utils/constant/storage_util.dart';

class EstimasiPenambilanRepository {
  final storageUtil = StorageUtil();

  Future<List<EstimasiPengambilanModel>> fetchEstimasiPengambilan() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_estimasi_kendaraaan.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => EstimasiPengambilanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil seluruh data do estimasi');
    }
  }
}
