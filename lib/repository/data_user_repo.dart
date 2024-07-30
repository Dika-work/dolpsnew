import 'dart:convert';

import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../utils/popups/full_screen_loader.dart';
import '../utils/popups/snackbar.dart';

class DataUserRepository {
  final storageUtil = StorageUtil();

  // fetch data
  Future<List<DataUserModel>> fetchDataUserContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_user.php?action=getUsers'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DataUserModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data user🙄');
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
      String dealer) async {
    try {
      print('...PROSES AWALAN DI REPOSITORY ADD DATA USER...');
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/DO/api/api_user.php'), body: {
        'username': username,
        'password': password,
        'nama': nama,
        'tipe': tipe,
        'app': app,
        'gambar': gambar,
        'wilayah': wilayah,
        'plant': plant,
        'dealer': dealer
      });
      print('...BERHASIL DI REPOSITORY...');

      print('INI RESPONSE NYA $response');

      if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Pastikan telah terkoneksi dengan wifi kantor : ${response.statusCode}😁',
        );
      }
    } catch (e) {
      print('ini error di catch di repository user $e');
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
      );
    }
  }

  // edit data user
  Future<void> editDataUserContent(
    String username,
    String password,
    String nama,
    String tipe,
    String app,
    String gambar,
    String wilayah,
    String plant,
    String dealer,
  ) async {
    try {
      print('...PROSES AWALAN DI REPOSITORY EDIT DATA USER...');
      final response = await http.put(
          Uri.parse(
            '${storageUtil.baseURL}/DO/api/api_user.php',
          ),
          body: {
            'username': username,
            'password': password,
            'nama': nama,
            'tipe': tipe,
            'app': app,
            'gambar': gambar,
            'wilayah': wilayah,
            'plant': plant,
            'dealer': dealer
          });

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data user berhasil diubah',
          );
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
        }
        return responseData;
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit data user, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository user: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit data user',
      );
    }
  }

  // hapus user
  // Future<void> hapusDataUserContent() async {
  //   try {
  //     print('...PROSES AWALAN DI REPOSITORY EDIT DATA USER...');
  //     final response = await http.delete(
  //       Uri.parse(
  //         '${storageUtil.baseURL}/DO/api/api_user.php',
  //       ),
  //     );

  //     print('...BERHASIL DI REPOSITORY...');

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       if (responseData['status'] == 'success') {
  //         SnackbarLoader.successSnackBar(
  //           title: 'Sukses 😃',
  //           message: 'Data user berhasil diubah',
  //         );
  //       } else {
  //         SnackbarLoader.errorSnackBar(
  //           title: 'Gagal😪',
  //           message: responseData['message'] ?? 'Ada yang salah🤷',
  //         );
  //       }
  //       return responseData;
  //     } else {
  //       SnackbarLoader.errorSnackBar(
  //         title: 'Gagal😪',
  //         message:
  //             'Gagal mengedit data user, status code: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error di catch di repository user: $e');
  //     SnackbarLoader.errorSnackBar(
  //       title: 'Gagal😪',
  //       message: 'Terjadi kesalahan saat mengedit data user',
  //     );
  //   }
  // }
}
