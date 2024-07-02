import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtil {
  final prefs = GetStorage();

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
    prefs.remove('user');
    Get.offAllNamed('/login');
    SnackbarLoader.successSnackBar(
        title: 'Logged Out', message: 'Anda telah berhasil keluar 👍');
  }
}
