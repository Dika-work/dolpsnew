import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  // Future<UserModel?> fetchUserDetails(String username, String password) async {
  //   try {
  //     print('Mengirim permintaan ke server...');
  //     final response = await http.post(
  //       Uri.parse('http://langgeng.dyndns.biz/DO/api/login_user.php'),
  //       body: {'username': username, 'password': password},
  //     );

  //     print('Respons diterima dari server: ${response.statusCode}');
  //     print('Body respons-NYA: ${response.body}');
  //     print('...TESTING DISINI...');

  //     if (response.statusCode == 401) {
  //       final data = json.decode(response.body);
  //       print('Data JSON: $data');
  //       print('...TESTING DISINI23...');
  //       SnackbarLoader.errorSnackBar(
  //         title: 'Login Gagal',
  //         message:
  //             'Nama pengguna atau kata sandi tidak valid. Silakan coba lagi.',
  //       );
  //     } else if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       print('Data JSON: $data');
  //       print('...TESTING DISINI23...');
  //       // Handle HTTP error
  //       print('Login berhasil: ${data['response']}');
  //       return UserModel.fromJson(data['response']);
  //     }
  //   } catch (e) {
  //     // Handle other errors
  //     print('Terjadi kesalahan saat mencoba login: $e');
  //     SnackbarLoader.errorSnackBar(
  //       title: 'Error',
  //       message: 'Terjadi kesalahan saat mencoba login: $e',
  //     );
  //     return null;
  //   }
  //   return null;
  // }
  // Future<void> login(String username, String password) async {
  //   try {
  //      final response = await http.post(
  //       Uri.parse('http://langgeng.dyndns.biz/DO/api/login_user.php'),
  //       body: {'username': username, 'password': password},
  //     );
  //       if (response.statusCode == 200){

  //       }
  //   } catch (e) {

  //   }
  // }
}
