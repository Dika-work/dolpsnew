import 'package:doplsnew/models/get_all_user_model.dart';
import 'package:doplsnew/repository/data_user_repo.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
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
  final wilayah = '0'.obs;
  final plant = '0'.obs;
  final dealer = '0'.obs;

  // Text editing controllers for addUser form
  final usernameAddController = TextEditingController();
  final passwordAddController = TextEditingController();
  final namaAddController = TextEditingController();

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
      print('Form validation failed');
      return;
    }

    try {
      await dataUserRepo.addDataUserContent(
        usernameController.text,
        passwordController.text,
        namaController.text,
        tipe.value,
        'do',
        image.value!.path,
        wilayah.value,
        plant.value,
        dealer.value,
      );
      print('Data added successfully');
    } catch (e) {
      print('Error while adding data: $e');
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }

    CustomFullScreenLoader.stopLoading();
    print('Stopped loading dialog');

    // reset text controllers
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
    image.value = null;

    // Reset Rx variables or other state variables if needed
    tipe.value = 'admin';
    wilayah.value = '0';
    plant.value = '0';
    dealer.value = '0';

    print('Controllers and variables reset');
    await fetchUserData();
    print('User data fetched');

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data user baru..',
    );

    print('Navigated back');
  }

  Future<void> editUserData(
    String userName,
    String password,
    String nama,
    String selectedTipe,
    String selectedWilayah,
    String selectedPlant,
    String selectedDealer,
  ) async {
    const CustomCircularLoader();

    try {
      // Perform the edit operation
      await dataUserRepo.editDataUserContent(
        userName,
        password,
        nama,
        selectedTipe,
        'do',
        image.value?.path ?? '',
        selectedWilayah,
        selectedPlant,
        selectedDealer,
      );

      CustomFullScreenLoader.stopLoading();
      fetchUserData();

      // Show success snackbar handled inside editDataUserContent
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit data user',
      );
    }
  }

  // get image from device
  Future<XFile?> pickImage() async {
    try {
      final imagePicker =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicker == null) return null;

      final imageTemporary = File(imagePicker.path);
      image.value = imageTemporary;
    } catch (e) {
      // Show error message
      SnackbarLoader.errorSnackBar(
        title: 'Oops🤷',
        message: 'Gagal mengambil gambar dari gallery',
      );
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
