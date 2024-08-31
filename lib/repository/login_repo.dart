import 'package:doplsnew/models/user_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class LoginRepository {
  final storageUtil = Get.put(StorageUtil());

  Future<UserModel?> fetchUserDetails(String username, String password) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${storageUtil.baseURL}/DO/api/api_user.php?action=Login&username=$username&password=$password',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Periksa kunci yang benar
        if (data['status'] == 'success' && data['data'] != null) {
          final user = UserModel.fromJson(data['data']);
          storageUtil.saveUserDetails(user);
          Get.offAllNamed('/rootpage');
          return user;
        } else {
          showErrorSnackbar('Gagal😪', 'Username dan password salah..😒 ');
        }
      } else {
        showErrorSnackbar(
            'Gagal😪', 'Respon dari server tidak valid.${response.statusCode}');
      }
    } catch (e) {
      handleError(e);
    }
    return null;
  }

  void showErrorSnackbar(String title, String message) {
    CustomFullScreenLoader.stopLoading();
    SnackbarLoader.errorSnackBar(title: title, message: message);
  }

  void handleError(dynamic e) {
    print('Terjadi kesalahan saat mencoba login: $e');
    showErrorSnackbar('Error☠️', e.toString());
  }
}
