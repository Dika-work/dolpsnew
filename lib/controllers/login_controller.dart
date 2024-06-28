import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../repository/user_repo.dart';
import '../utils/constant/storage_util.dart';
import '../utils/popups/full_screen_loader.dart';

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
    usernameController.text = localStorage.read('REMEMBER_ME_EMAIL') ?? "";
    passwordController.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? "";
    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    print('awalan controller ..');
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    if (rememberMe.value) {
      localStorage.write('REMEMBER_ME_EMAIL', usernameController.text.trim());
      localStorage.write(
          'REMEMBER_ME_PASSWORD', passwordController.text.trim());
    }

    print('awalan controller B ..');

    try {
      CustomFullScreenLoader.openLoadingDialog(
        'Mohon tunggu...',
        'assets/animations/141594-animation-of-docer.json',
      );

      print('awalan controller C ..');

      final userRepository = Get.put(UserRepository());

      print('awalan controller D ..');

      final user = await userRepository.fetchUserDetails(
        usernameController.text,
        passwordController.text,
      );

      print('awalan controller E ..');

      Navigator.of(Get.overlayContext!)
          .pop(); // Tutup dialog loading setelah selesai

      if (user != null) {
        // Simpan detail pengguna ke StorageUtil setelah login
        print('ini udah mau ke simpen ke local storage');
        print('...INI DATA USER NYA...');

        storageUtil.saveUserDetails(
          username: user.username,
          nama: user.nama,
          tipe: user.tipe,
          app: user.app,
          lihat: user.lihat,
          print: user.print,
          tambah: user.tambah,
          edit: user.edit,
          hapus: user.hapus,
          jumlah: user.jumlah,
          kirim: user.kirim,
          batal: user.batal,
          cekUnit: user.cekUnit,
          wilayah: user.wilayah,
          plant: user.plant,
          cekReguler: user.cekReguler,
          cekMutasi: user.cekMutasi,
          acc1: user.acc1,
          acc2: user.acc2,
          acc3: user.acc3,
          menu1: user.menu1,
          menu2: user.menu2,
          menu3: user.menu3,
          menu4: user.menu4,
          menu5: user.menu5,
          menu6: user.menu6,
          menu7: user.menu7,
          menu8: user.menu8,
          menu9: user.menu9,
          menu10: user.menu10,
          gambar: user.gambar,
          online: user.online,
        );
        print('sudah tersimpan ke local storage ${user.username}');

        Get.offNamed(
            '/rootpage'); // Navigasi ke halaman beranda setelah login berhasil
      } else {
        // Jika user null, berarti ada kesalahan dalam proses login
        SnackbarLoader.errorSnackBar(
          title: 'Login Gagal',
          message:
              'Nama pengguna atau kata sandi tidak valid. Silakan coba lagi.',
        );
      }
    } catch (e) {
      // Tangkap kesalahan saat proses login
      Navigator.of(Get.overlayContext!)
          .pop(); // Tutup dialog loading jika terjadi kesalahan
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat mencoba login: $e',
      );
      print('ini error nya : $e');
    }
  }
}
