import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/source/data_user_source.dart';

class DataUserScreen extends GetView<DataUserController> {
  const DataUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isDataUserLoading.value &&
              controller.dataUserModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.dataUserModel.isEmpty) {
            return Center(child: Text(controller.dataUserModel.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomSize.md, vertical: CustomSize.sm),
              child: PaginatedDataTable(
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Data User',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                        onPressed: () {
                          CustomDialogs.defaultDialog(
                              context: context,
                              titleWidget: const Text('Tambah user'),
                              contentWidget:
                                  AddUserData(controller: controller),
                              confirmText: 'Tambah');
                        },
                        icon: const Icon(Iconsax.user_add))
                  ],
                ),
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Tipe')),
                  DataColumn(label: Text('Gambar')),
                  DataColumn(label: Text('Action')),
                ],
                source: DataUserDataSource(controller, context),
                rowsPerPage: 10,
              ),
            );
          }
        }),
      ),
    );
  }
}

class AddUserData extends StatelessWidget {
  const AddUserData({
    super.key,
    required this.controller,
  });

  final DataUserController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.addUserKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: CustomSize.spaceBtwItems),
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
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.namaController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.card),
                labelText: 'Nama',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.tipeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tipe harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.card),
                labelText: 'Tipe',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.appController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'App harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.card),
                labelText: 'App',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            SizedBox(
              width: 50,
              height: 50,
              child: Obx(
                () => DropdownButton<String>(
                  value: controller.lihat.value,
                  icon: const Icon(Icons.arrow_downward),
                  hint: const Text('Pilih Lihat'),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String? newValue) {
                    controller.lihat.value = newValue!;
                  },
                  items: <String>[
                    '0',
                    '1',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            SizedBox(
              width: 50,
              height: 50,
              child: Obx(
                () => DropdownButton<String>(
                  value: controller.print.value,
                  icon: const Icon(Icons.arrow_downward),
                  hint: const Text('Pilih Print'),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String? newValue) {
                    controller.print.value = newValue!;
                  },
                  items: <String>[
                    '0',
                    '1',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.tipeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tipe harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.card),
                labelText: 'Tipe',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
