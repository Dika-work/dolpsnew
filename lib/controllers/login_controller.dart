import 'dart:convert';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/popups/full_screen_loader.dart';
import '../utils/popups/snackbar.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final storageUtil = StorageUtil();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    usernameController.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    passwordController.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    print('Awalan controller..');
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    if (rememberMe.value) {
      localStorage.write('REMEMBER_ME_EMAIL', usernameController.text.trim());
      localStorage.write(
          'REMEMBER_ME_PASSWORD', passwordController.text.trim());
    }

    try {
      CustomFullScreenLoader.openLoadingDialog(
        'Mohon tunggu...',
        'assets/animations/141594-animation-of-docer.json',
      );

      final response = await http.post(
        Uri.parse(
            'http://langgeng.dyndns.biz/DO/api/login_user.php?username=${usernameController.text}&password=${passwordController.text}'),
      );

      print('Respons diterima dari server: ${response.statusCode}');
      print('Body respons: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response'] != null && data['response']['status'] == '401') {
          print('Login gagal: Nama pengguna atau kata sandi tidak valid');
          SnackbarLoader.errorSnackBar(
            title: 'Login Gagal',
            message:
                'Nama pengguna atau kata sandi tidak valid. Silakan coba lagi.',
          );
        } else {
          // Login berhasil, simpan data pengguna ke local storage
          final user = data['response'];
          storageUtil.saveUserDetails(
            username: user['username'],
            nama: user['nama'],
            tipe: user['tipe'],
            app: user['app'],
            lihat: user['lihat'],
            print: user['print'],
            tambah: user['tambah'],
            edit: user['edit'],
            hapus: user['hapus'],
            jumlah: user['jumlah'],
            kirim: user['kirim'],
            batal: user['batal'],
            cekUnit: user['cek_unit'],
            wilayah: user['wilayah'],
            plant: user['plant'],
            cekReguler: user['cek_reguler'],
            cekMutasi: user['cek_mutasi'],
            acc1: user['acc_1'],
            acc2: user['acc_2'],
            acc3: user['acc_3'],
            menu1: user['menu1'],
            menu2: user['menu2'],
            menu3: user['menu3'],
            menu4: user['menu4'],
            menu5: user['menu5'],
            menu6: user['menu6'],
            menu7: user['menu7'],
            menu8: user['menu8'],
            menu9: user['menu9'],
            menu10: user['menu10'],
            gambar: user['gambar'],
            online: user['online'],
          );

          Get.offNamed(
              '/rootpage'); // Navigate to rootpage after successful login

          print('Berhasil menyimpan ke local storage: ${user['username']}');
        }
      } else {
        print('Terjadi kesalahan saat mencoba login: ${response.statusCode}');
        SnackbarLoader.errorSnackBar(
          title: 'Gagal',
          message: 'Username dan password salah..',
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat mencoba login: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat mencoba login: $e',
      );
    }
  }
}
