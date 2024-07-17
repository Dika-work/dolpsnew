import 'dart:convert';

import 'package:doplsnew/models/input%20data%20do/do_harian_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../utils/popups/snackbar.dart';

class DataDoHarianRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoHarianModel>> fetchDataHarianContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_harian.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoHarianModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Harian☠️');
    }
  }

  Future<void> addDataHarian(
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
            '${storageUtil.baseURL}/DO/api/tambah_do_harian.php?id_plant=$idPlant&tujuan=$tujuan&tgl=$tgl&jam=$jam&jumlah_1=$srd&jumlah_2=$mks&jumlah_3=$ptk&jumlah_4=$bjm&jumlah_5=$jumlah5&jumlah_6=$jumlah6&user=$user&plant=$plant'),
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

  Future<Map<String, dynamic>> editDOHarianContent(
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
      print('...PROSES AWALANAN DI REPOSITORY DO HARIAN...');
      final response = await http.post(Uri.parse(
          '${storageUtil.baseURL}/DO/api/edit_do_harian.php?id=$id&tgl=$tgl&id_plant=$idPlant&tujuan=$tujuan&jumlah_1=$srd&jumlah_2=$mks&jumlah_3=$ptk&jumlah_4=$bjm'));

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Harian berhasil diubah',
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
              'Gagal mengedit DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error di catch di repository do harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Harian',
      );
    }
    return {};
  }

  Future<Map<String, dynamic>> deleteDOHarianContent(
    int id,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Harian...');
      final response = await http.post(Uri.parse(
          '${storageUtil.baseURL}/DO/api/hapus_do_harian.php?id=$id'));

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Harian berhasil dihapus',
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
              'Gagal menghapus DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error di catch di repository do Harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Harian',
      );
    }
    return {};
  }
}
