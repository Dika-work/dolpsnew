import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class TambahTypeMotorRepository {
  final storagetUtil = StorageUtil();

  Future<List<TambahTypeMotorModel>> fetchTambahTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php?action=JumlahMotor&id=$id'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini isinya tambah type motor di repo : ${list.toList()}');
      return list.map((e) => TambahTypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untum mengambil data type motor☠️');
    }
  }

  Future<void> addTypeMotorDaerah(
      int idPacking,
      int idRealisasi,
      String jamDetail,
      String tglDetail,
      String daerah,
      String typeMotor,
      int jumlah) async {
    try {
      final response = await http.post(
          Uri.parse(
              '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php'),
          body: {
            'id_packing': idPacking,
            'id_realisasi': idRealisasi,
            'jam_detail': jamDetail,
            'tgl_detail': tglDetail,
            'daerah': daerah,
            'type_motor': typeMotor,
            'jumlah': jumlah
          });

      if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error while adding data in tambah type motor repo: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }
}
