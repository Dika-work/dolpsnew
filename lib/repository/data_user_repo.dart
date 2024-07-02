import 'dart:convert';

import 'package:doplsnew/models/data_user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataUserRepository extends GetxController {
  Future<List<DataUserModel>> fetchDataUserContent() async {
    final response = await http
        .get(Uri.parse('http://langgeng.dyndns.biz/DO/api/tampil_user.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      // print(list.toList());
      return list.map((model) => DataUserModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data user');
    }
  }
}
