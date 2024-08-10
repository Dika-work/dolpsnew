import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/edit_type_motor_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class EditTypeMotorRepository {
  final storageUtil = StorageUtil();

  // FETCH ALL DATA INTO TABLE
  Future<List<EditTypeMotorModel>> fetchAllTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_packing_list_motor.php?action=TipeMotor&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => EditTypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil type SRD');
    }
  }

  // Edit func
  Future<void> editTypeMotor(
      int idPacking, String typeMotor, String daerah, int jumlah) async {
    try {
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/DO/api/api_packing_list_motor.php'),
        body: {
          'id_packing': idPacking.toString(),
          'type_motor': typeMotor,
          'daerah': daerah,
          'jumlah': jumlah.toString()
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Type motor berhasil diubah',
          );
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
          print('...ADA MASALAH DI EDIT TYPE MOTOR REPO...');
        }
        return responseData;
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit Type motor, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error edit di repository Edit Type Motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit Type motor',
      );
    }
  }

  // Hapus func
  Future<void> hapusTypeMotor(int idPacking) async {
    try {
      final response = await http.delete(
        Uri.parse('${storageUtil.baseURL}/DO/api/api_packing_list_motor.php'),
        body: {
          'id_packing': idPacking.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data type motor berhasil dihapus',
          );
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
          print('...ADA MASALAH DI HAPUS TYPE MOTOR REPO...');
        }
        return responseData;
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal menghapus type motor, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error edit di repository Hapus Type Motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus Type motor',
      );
    }
  }
}
