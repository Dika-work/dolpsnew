import 'dart:convert';

import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/popups/snackbar.dart';

class DataUserRepository extends GetxController {
  // fetch data
  Future<List<DataUserModel>> fetchDataUserContent() async {
    final response = await http
        .get(Uri.parse('http://langgeng.dyndns.biz/DO/api/tampil_user.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DataUserModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data user');
    }
  }

  // add data
  Future<void> addDataUserContent(
      String username,
      String password,
      String nama,
      String tipe,
      String app,
      String gambar,
      String wilayah,
      String plant,
      String dealer,
      String online) async {
    try {
      print('...PROSES AWALAN DI REPOSITORY ADD DATA USER...');
      final response = await http.post(Uri.parse(
          'http://langgeng.dyndns.biz/DO/api/tambah_user.php?username=$username&password=$password&nama=$nama&tipe=$tipe&app=$app&gambar=$gambar&wilayah=$wilayah&plant=$plant&dealer=$dealer&online=$online)}'));
      print('...BERHASIL DI REPOSITORY...');

      print('INI RESPONSE NYA $response');

      if (response.statusCode != 200) {
        SnackbarLoader.errorSnackBar(
          title: 'Gagal',
          message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
        );
      }
    } catch (e) {
      print('ini error di catch di repository user $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal',
        message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
      );
    }
  }
}
