import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:doplsnew/repository/data_user_repo.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../utils/popups/snackbar.dart';

class DataUserController extends GetxController {
  RxList<DataUserModel> dataUserModel = <DataUserModel>[].obs;
  GlobalKey<FormState> addUserKey = GlobalKey<FormState>();

  final isDataUserLoading = Rx<bool>(false);
  final hidePassword = true.obs;
  final dataUserRepo = Get.put(DataUserRepository());

  // textEditingController
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Rx<File?> image = Rx<File?>(null);
  final namaController = TextEditingController();
  final tipe = 'admin'.obs;
  final wilayah = '1'.obs;
  final plant = '1100'.obs;
  final dealer = 'honda'.obs;

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  Future<void> fetchUserData() async {
    try {
      isDataUserLoading.value = true;
      final dataUser = await dataUserRepo.fetchDataUserContent();
      dataUserModel.assignAll(dataUser);
    } catch (e) {
      print('Error fetching user data: $e');
      dataUserModel.assignAll([]);
    } finally {
      isDataUserLoading.value = false;
    }
  }

  Future<void> addUserData() async {
    print('Adding new user data...');
    CustomFullScreenLoader.openLoadingDialog(
      'Adding new user data...',
      'assets/animations/141594-animation-of-docer.json',
    );

    if (!addUserKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      Get.back();
      return;
    }

    await dataUserRepo.addDataUserContent(
        usernameController.text,
        passwordController.text,
        namaController.text,
        tipe.value,
        'do',
        wilayah.value,
        plant.value,
        dealer.value,
        image.value!.path,
        '0');
    CustomFullScreenLoader.stopLoading();

    // reset text controllers
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
    image.value = null;

    // Reset Rx variables or other state variables if needed
    tipe.value = 'admin';
    wilayah.value = '1';
    plant.value = '1100';
    dealer.value = 'honda';

    Get.back();
    print('...SUDAH BERHASIL...');
    fetchUserData();
    print('/// BERHASIL NAMPILIN DATA BARU ///');

    SnackbarLoader.successSnackBar(
      title: 'Berhasil',
      message: 'Menambahkan data user baru..',
    );
  }

  // get image from divice
  Future<XFile?> pickImage() async {
    try {
      final imagePicker =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicker == null) return null;

      final imageTemporary = File(imagePicker.path);
      image.value = imageTemporary;
    } catch (e) {
      // Show error message
      SnackbarLoader.errorSnackBar(title: 'Oops🤷', message: e.toString());
    }
    return null;
  }

  // delete image
  Future<void> deleteImage() async {
    if (image.value != null) {
      await image.value!.delete();
      image.value = null;
    }
  }
}
