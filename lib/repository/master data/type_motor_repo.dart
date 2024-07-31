import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/master data/type_motor.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class TypeMotorRepository {
  final storageUtil = StorageUtil();

  Future<List<TypeMotorModel>> fetchTypeMotorContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_type_motor.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => TypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data Type Motor☠️');
    }
  }

  Future<void> addTipeMotor(
      String merk,
      String typeMotor,
      int hlm,
      int ac,
      int ks,
      int ts,
      int bp,
      int bs,
      int plt,
      int stay,
      int acBesar,
      int plastik) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_type_motor.php'),
          body: {
            'merk': merk,
            'type_motor': typeMotor,
            'hlm': hlm.toString(),
            'ac': ac.toString(),
            'ks': ks.toString(),
            'ts': ts.toString(),
            'bp': bp.toString(),
            'bs': bs.toString(),
            'plt': plt.toString(),
            'stay': stay.toString(),
            'ac_besar': acBesar.toString(),
            'plastik': plastik.toString()
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
      print('Error while adding data type motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }

  Future<void> editTypeMotorData(
      int idType,
      String merk,
      String typeMotor,
      int hlm,
      int ac,
      int ks,
      int ts,
      int bp,
      int bs,
      int plt,
      int stay,
      int acBesar,
      int plastik) async {
    try {
      final response = await http.put(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_type_motor.php'),
          body: {
            'id_type': idType.toString(),
            'merk': merk,
            'type_motor': typeMotor,
            'hlm': hlm.toString(),
            'ac': ac.toString(),
            'ks': ks.toString(),
            'ts': ts.toString(),
            'bp': bp.toString(),
            'bs': bs.toString(),
            'plt': plt.toString(),
            'stay': stay.toString(),
            'ac_besar': acBesar.toString(),
            'plastik': plastik.toString()
          });

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
      print('Error di catch di repository Type motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit Type motor',
      );
    }
  }
}
