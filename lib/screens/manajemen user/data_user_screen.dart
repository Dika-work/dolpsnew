import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:doplsnew/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constant/storage_util.dart';
import '../../utils/custom_drawer.dart';
import '../../utils/source/data_user_source.dart';

class DataUserScreen extends GetView<DataUserController> {
  const DataUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data User'),
        leading: IconButton(
          icon: const Icon(Iconsax.firstline),
          onPressed: () {
            storageUtil.scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(
          onItemTapped: storageUtil.onItemTapped,
          selectedIndex: storageUtil.selectedIndex.value,
          logout: storageUtil.logout,
          closeDrawer: () =>
              storageUtil.scaffoldKey.currentState!.closeDrawer()),
      key: storageUtil.scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.isDataUserLoading.value &&
                controller.dataUserModel.isEmpty) {
              return const CustomCircularLoader();
            } else if (controller.dataUserModel.isEmpty) {
              return Center(child: Text(controller.dataUserModel.toString()));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomSize.md, vertical: CustomSize.md),
                child: PaginatedDataTable(
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tambah Data User',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                          onPressed: () {
                            CustomDialogs.defaultDialog(
                                context: context,
                                titleWidget: const Text('Tambah user'),
                                contentWidget:
                                    AddUserData(controller: controller),
                                onConfirm: () => controller.addUserData(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Text('Pilih Tipe'),
            Obx(
              () => DropDownWidget(
                value: controller.tipe.value,
                items: const ['admin', 'user'],
                onChanged: (String? value) {
                  controller.tipe.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Pilih Daerah'),
            Obx(
              () => DropDownWidget(
                value: controller.wilayah.value,
                items: const ['1', '2', '3', '4'],
                onChanged: (String? value) {
                  controller.wilayah.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Pilih Plant'),
            Obx(
              () => DropDownWidget(
                value: controller.plant.value,
                items: const [
                  '1100',
                  '1200',
                  '1300',
                  '1350',
                  '1700',
                  '1800',
                  '1900',
                  'DC (Pondok Ungu)',
                  'TB (Tambun Bekasi)'
                ],
                onChanged: (String? value) {
                  controller.plant.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Pilih Dealer'),
            Obx(
              () => DropDownWidget(
                value: controller.dealer.value,
                items: const ['honda', 'yamaha', 'suzuki', 'kawasaki'],
                onChanged: (String? value) {
                  controller.dealer.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.gambarController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'gambar harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.card),
                labelText: 'gambar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
