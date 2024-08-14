import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class TambahTypeMotorMutasiRepo {
  final storagetUtil = StorageUtil();

  Future<List<TambahTypeMotorMutasiModel>> fetchTambahTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php?action=JumlahMotor&id=$id'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini isinya tambah type motor di repo : ${list.toList()}');
      return list.map((e) => TambahTypeMotorMutasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untum mengambil data type motor☠️');
    }
  }

  // tambah status type motor (change status to 2)
  Future<void> changeStatusTypeMotor(int id, int status) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${storagetUtil.baseURL}/DO/api/api_realisasi.php?action=Tipe'),
          body: {'id': id.toString(), 'status': status.toString()});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('ini ubah status tambah type motor : $responseData');
        if (responseData['status'] == 'error') {
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😢',
            message: responseData['message'] ?? 'Ada yang salah😒',
          );
          print(responseData['message']);
        }
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😢',
          message: 'Server mengembalikan status code ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di tambah jumlah unit: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat tambah jumlah unit',
      );
    }
  }
}
