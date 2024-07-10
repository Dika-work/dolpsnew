import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:doplsnew/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/get_all_user_model.dart';
import '../../utils/source/data_user_source.dart';
import '../../widgets/curved_edges.dart';

class DataUserScreen extends GetView<DataUserController> {
  const DataUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Username': double.nan,
      'Nama': double.nan,
      'Tipe': double.nan,
      'Gambar': double.nan,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data User',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.toNamed('/rootpage'),
        ),
      ),
      body: Obx(() {
        if (controller.isDataUserLoading.value &&
            controller.dataUserModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.dataUserModel.isEmpty) {
          return Center(
              child: Text('Data User Tidak Tersedia',
                  style: Theme.of(context).textTheme.bodyMedium));
        } else {
          return SafeArea(
            child: SfDataGrid(
              source: DataUserDataSource(dataUser: controller.dataUserModel),
              columnWidthMode: ColumnWidthMode.auto,
              allowPullToRefresh: true,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowColumnsResizing: true,
              onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                columnWidths[details.column.columnName] = details.width;
                return true;
              },
              footer: Container(
                color: AppColors.primary,
                child: Center(
                  child: InkWell(
                      onTap: () =>
                          Get.to(() => AddUserData(controller: controller)),
                      child: Text(
                        'Tambahkan user baru',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.apply(color: AppColors.light),
                      )),
                ),
              ),
              allowEditing: true,
              editingGestureType: EditingGestureType.tap,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              columns: [
                GridColumn(
                    width: columnWidths['No']!,
                    columnName: 'No',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'No',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Username']!,
                    columnName: 'Username',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Username',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Nama']!,
                    columnName: 'Nama',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Nama',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Tipe']!,
                    columnName: 'Tipe',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Tipe',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Gambar']!,
                    columnName: 'Gambar',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Gambar',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
          );
        }
      }),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          'Tambah data user',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: Colors.blueAccent,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: CustomSize.lg),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomSize.lg, vertical: CustomSize.md),
                    child: Obx(() => controller.image.value != null
                        ? Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: Image.file(
                                    controller.image.value!,
                                    width: CustomSize.profileImageSize,
                                    height: CustomSize.profileImageSize,
                                    fit: BoxFit.cover,
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: controller.deleteImage,
                                      icon: const Icon(
                                        Iconsax.trash,
                                        color: AppColors.error,
                                      )),
                                  IconButton(
                                      onPressed: controller.pickImage,
                                      icon: const Icon(Iconsax.edit)),
                                ],
                              )
                            ],
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: InkWell(
                                    onTap: controller.pickImage,
                                    child: Image.asset(
                                      'assets/icons/person.png',
                                      width: CustomSize.profileImageSize,
                                      height: CustomSize.profileImageSize,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Iconsax.add_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomSize.lg, vertical: CustomSize.md),
              child: Form(
                key: controller.addUserKey,
                child: Column(
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
                          print('ini tipenya : ${controller.tipe.value}');
                        },
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    const Text('Pilih Daerah'),
                    Obx(
                      () => DropDownWidget(
                        value: controller.wilayah.value,
                        items: const ['0', '1', '2', '3', '4'],
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
                          '0',
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
                        items: const [
                          '0',
                          'honda',
                          'yamaha',
                          'suzuki',
                          'kawasaki'
                        ],
                        onChanged: (String? value) {
                          controller.dealer.value = value!;
                          print('INI VALUE DEALER... $value');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: CustomSize.md,
                  left: CustomSize.md,
                  right: CustomSize.md),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.image.value == null) {
                      SnackbarLoader.errorSnackBar(
                        title: 'Perhatian😪',
                        message: 'Harap menginput foto 😁',
                      );
                    } else {
                      CustomDialogs.defaultDialog(
                        context: context,
                        titleWidget: Text(
                          'Menambahkan data user baru',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        contentWidget: Text(
                          'Apakah anda yakin ingin menambahkan data user baru?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        confirmText: 'Ya',
                        onConfirm: () async {
                          await controller.addUserData();
                          Get.offNamed('/data-user');
                        },
                      );
                    }
                  },
                  child: const Text('Tambahkan user'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditUserData extends StatefulWidget {
  const EditUserData({
    super.key,
    required this.controller,
    required this.userData,
  });

  final DataUserController controller;
  final DataUserModel userData;

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController namaController;
  late String tipe;
  late String wilayah;
  late String plant;
  late String dealer;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.userData.username);
    passwordController = TextEditingController(text: widget.userData.password);
    namaController = TextEditingController(text: widget.userData.nama);
    tipe = widget.userData.tipe;
    wilayah = widget.userData.wilayah;
    plant = widget.userData.plant;
    dealer = widget.userData.dealer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Edit Data User',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: widget.controller.editUserKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: usernameController,
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
                    controller: passwordController,
                    obscureText: widget.controller.hidePassword.value,
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
                        onPressed: () => widget.controller.hidePassword.value =
                            !widget.controller.hidePassword.value,
                        icon: Icon(
                          widget.controller.hidePassword.value
                              ? Iconsax.eye
                              : Iconsax.eye_slash,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                TextFormField(
                  controller: namaController,
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
                DropDownWidget(
                  value: tipe,
                  items: const ['admin', 'user'],
                  onChanged: (String? value) {
                    setState(() {
                      tipe = value!;
                      print('ini tipe nya : $tipe');
                    });
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                const Text('Pilih Daerah'),
                DropDownWidget(
                  value: wilayah,
                  items: const ['0', '1', '2', '3', '4'],
                  onChanged: (String? value) {
                    setState(() {
                      wilayah = value!;
                    });
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                const Text('Pilih Plant'),
                DropDownWidget(
                  value: plant,
                  items: const [
                    '0',
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
                    setState(() {
                      plant = value!;
                    });
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                const Text('Pilih Dealer'),
                DropDownWidget(
                  value: dealer,
                  items: const ['0', 'honda', 'yamaha', 'suzuki', 'kawasaki'],
                  onChanged: (String? value) {
                    setState(() {
                      dealer = value!;
                    });
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwSections),
                // Button to update user
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.controller.editUserData(
                          usernameController.text,
                          passwordController.text,
                          namaController.text,
                          tipe,
                          wilayah,
                          plant,
                          dealer);
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
