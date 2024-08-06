import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/edit_type_motor_model.dart';

class EditTypeMotorRepository {
  final storageUtil = StorageUtil();

  // samarinda
  Future<List<EditTypeMotorModel>> fetchAllTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_packing_list_motor.php?action=TipeMotor&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => EditTypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil type SRD');
    }
  }
}
