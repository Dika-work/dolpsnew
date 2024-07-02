import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class LoginRepository extends GetxController {
  final storageUtil = Get.put(StorageUtil());

  Future<UserModel?> fetchUserDetails(String username, String password) async {
    try {
      print('Mengirim permintaan ke server...');
      final response = await http.post(
        Uri.parse(
          'http://langgeng.dyndns.biz/DO/api/login_user.php?username=$username&password=$password',
        ),
      );

      print('Respons diterima dari server: ${response.statusCode}');
      print('Body respons: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response'] != null &&
            data['response'] is Map<String, dynamic>) {
          final user = UserModel.fromJson(data['response']);
          storageUtil.saveUserDetails(user);
          Get.offNamed('/rootpage');
          print('Berhasil menyimpan ke local storage: ${user.username}');
          return user;
        } else {
          showErrorSnackbar('Gagal', 'Respon dari server tidak valid.');
        }
      } else {
        showErrorSnackbar('Gagal', 'Username dan password salah..😒');
      }
    } catch (e) {
      handleError(e);
    }
    return null;
  }

  void showErrorSnackbar(String title, String message) {
    Navigator.of(Get.overlayContext!).pop();
    SnackbarLoader.errorSnackBar(title: title, message: message);
  }

  void handleError(dynamic e) {
    print('Terjadi kesalahan saat mencoba login: $e');
    showErrorSnackbar('Error', 'Terjadi kesalahan saat mencoba login: $e');
  }
}
