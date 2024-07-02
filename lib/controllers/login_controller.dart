import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../repository/login_repo.dart';
import '../utils/popups/full_screen_loader.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final loginRepository = Get.put(LoginRepository());
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

    CustomFullScreenLoader.openLoadingDialog(
      'Mohon tunggu...',
      'assets/animations/141594-animation-of-docer.json',
    );

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    await loginRepository.fetchUserDetails(username, password);
  }
}
