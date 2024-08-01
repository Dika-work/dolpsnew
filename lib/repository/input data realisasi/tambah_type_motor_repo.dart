import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/tambah_type_motor_model.dart';

class TambahTypeMotorRepository {
  final storagetUtil = StorageUtil();

  Future<List<TambahTypeMotorModel>> fetchTambahTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php?action=JumlahMotor&id=$id'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini isinya tambah type motor di repo : ${list.toList()}');
      return list.map((e) => TambahTypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untum mengambil data type motor☠️');
    }
  }
}
