import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

// class UserRepository extends GetxController {
//   Future<UserModel?> fetchUserDetails(String username, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://langgeng.dyndns.biz/DO/api/login_user.php/'),
//         body: {'username': username, 'password': password},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('Response data: $data');

//         if (data != null) {
//           return UserModel.fromJson(data);
//         } else {
//           SnackbarLoader.errorSnackBar(
//             title: 'Login Gagal',
//             message:
//                 'Nama pengguna atau kata sandi tidak valid. Silakan coba lagi.',
//           );
//           return null;
//         }
//       } else {
//         SnackbarLoader.errorSnackBar(
//           title: 'Login Gagal',
//           message:
//               'Terjadi kesalahan saat mencoba login. Status: ${response.statusCode}',
//         );
//         return null;
//       }
//     } catch (e) {
//       print('ini error di repositorynya : $e');
//       SnackbarLoader.errorSnackBar(
//         title: 'Error',
//         message: 'Terjadi kesalahan saat mencoba login: $e',
//       );
//       return null;
//     }
//   }
// }

class UserRepository extends GetxController {
  Future<UserModel?> fetchUserDetails(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://langgeng.dyndns.biz/DO/api/login_user.php'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');

        if (data != null && data['response'] != null) {
          // Check if status is present in the response
          if (data['response']['status'] == '0') {
            // Handle incorrect username or password
            SnackbarLoader.errorSnackBar(
              title: 'Login Gagal',
              message:
                  'Nama pengguna atau kata sandi tidak valid. Silakan coba lagi.',
            );
            return null;
          } else {
            // Parse the UserModel from JSON
            return UserModel.fromJson(data['response']);
          }
        } else {
          // Handle case where response or response['response'] is null
          SnackbarLoader.errorSnackBar(
            title: 'Login Gagal',
            message:
                'Terjadi kesalahan saat mencoba login. Data respons tidak valid.',
          );
          return null;
        }
      } else {
        // Handle HTTP error
        SnackbarLoader.errorSnackBar(
          title: 'Login Gagal',
          message:
              'Terjadi kesalahan saat mencoba login. Status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      // Handle other errors
      print('Terjadi kesalahan saat mencoba login: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat mencoba login: $e',
      );
      return null;
    }
  }
}
