import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/home/do_global_harian_controller.dart';
import '../../controllers/home/do_harian_home_bsk_controller.dart';
import '../../controllers/home/do_harian_home_controller.dart';
import '../../controllers/login_controller.dart';
import '../../screens/homepage.dart';

class StorageUtil {
  final prefs = GetStorage();
  final baseURL = 'http://langgeng.dyndns.biz';

  UserModel? getUserDetails() {
    final data = prefs.read('user');
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  void saveUserDetails(UserModel user) {
    prefs.write('user', user.toJson());
  }

void logout() {
  // Hapus controller yang terkait
  Get.delete<DataDOHarianHomeController>(); 
  Get.delete<DoHarianHomeBskController>();
  Get.delete<DataDOGlobalHarianController>();

  final loginController = Get.find<LoginController>();
  loginController.resetFormKey(); // Reset GlobalKey untuk form

  // Hapus data user dari GetStorage
  prefs.remove('user');
  prefs.remove('userToken');

  Get.offAllNamed('/login'); // Arahkan kembali ke halaman login

  SnackbarLoader.successSnackBar(
      title: 'Logged Out', message: 'Anda telah berhasil keluar 👍');
}


  final selectedIndex = 0.obs;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> widgetOptions = <Widget>[
    const Homepage(),
  ];

  onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
