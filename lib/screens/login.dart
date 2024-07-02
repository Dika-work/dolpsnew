import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/login_bg.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: controller.loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "PT. Langgeng Pranamas Sentosa",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller.usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username harus di isi';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Username',
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Obx(
                                () => TextFormField(
                                  controller: controller.passwordController,
                                  obscureText: controller.hidePassword.value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password harus di isi';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          controller.hidePassword.value =
                                              !controller.hidePassword.value,
                                      icon: Icon(
                                        controller.hidePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Obx(
                                        () => SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: controller.rememberMe.value,
                                            onChanged: (value) => controller
                                                    .rememberMe.value =
                                                !controller.rememberMe.value,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Ingat Saya',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.emailAndPasswordSignIn();
                                  },
                                  child: const Text('Sign In'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
