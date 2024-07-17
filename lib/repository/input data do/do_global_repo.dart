import 'dart:convert';

import 'package:doplsnew/models/input%20data%20do/do_global_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../utils/popups/snackbar.dart';

class DataDoGlobalRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalModel>> fetchDataGlobalContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_global.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global☠️');
    }
  }

  Future<void> addDataGlobal(
    String idPlant,
    String tujuan,
    String tgl,
    String jam,
    String srd,
    String mks,
    String ptk,
    String bjm,
    String jumlah5,
    String jumlah6,
    String user,
    String plant,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${storageUtil.baseURL}/DO/api/tambah_do_global.php?id_plant=$idPlant&tujuan=$tujuan&tgl=$tgl&jam=$jam&jumlah_1=$srd&jumlah_2=$mks&jumlah_3=$ptk&jumlah_4=$bjm&jumlah_5=$jumlah5&jumlah_6=$jumlah6&user=$user&plant=$plant'),
      );

      if (response.statusCode != 200) {
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
        );
      }
    } catch (e) {
      print('Error while adding data: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }

  Future<Map<String, dynamic>> editDOGlobalContent(
    int id,
    String tgl,
    int idPlant,
    String tujuan,
    int srd,
    int mks,
    int ptk,
    int bjm,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.post(Uri.parse(
          '${storageUtil.baseURL}/DO/api/edit_do_global.php?id=$id&tgl=$tgl&id_plant=$idPlant&tujuan=$tujuan&jumlah_1=$srd&jumlah_2=$mks&jumlah_3=$ptk&jumlah_4=$bjm'));

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Global berhasil diubah',
          );
        } else {
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
        }
        return responseData;
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit DO Global, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error di catch di repository do Global: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Global',
      );
    }
    return {};
  }
}
