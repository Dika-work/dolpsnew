import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data do/do_harian_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataDoHarianRepository {
  final storageUtil = StorageUtil();

  Future<List<DoHarianModel>> fetchDataHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_harian.php?action=getData'));
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
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_harian.php'),
          body: {
            'id_plant': idPlant,
            'tujuan': tujuan,
            'tgl': tgl,
            'jam': jam,
            'jumlah_1': srd,
            'jumlah_2': mks,
            'jumlah_3': ptk,
            'jumlah_4': bjm,
            'jumlah_5': jumlah5,
            'jumlah_6': jumlah6,
            'user': user,
            'plant': plant,
          });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data do harian baru..',
        );
      } else if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan internet😁',
        );
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Something went wrong, please contact developer🥰',
        );
      }
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan internet 😁',
      );
      return;
    }
  }

  Future<void> editDOHarianContent(
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
      final response = await http.put(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_harian.php'),
          body: {
            'id': id.toString(),
            'tgl': tgl,
            'id_plant': idPlant.toString(),
            'tujuan': tujuan,
            'jumlah_1': srd.toString(),
            'jumlah_2': mks.toString(),
            'jumlah_3': ptk.toString(),
            'jumlah_4': bjm.toString(),
          });

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Harian berhasil diubah',
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
              'Gagal mengedit DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Harian',
      );
    }
  }

  Future<void> deleteDOHarianContent(
    int id,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Harian...');
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_harian.php'),
          body: {'id': id.toString()});

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Harian berhasil dihapus',
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
              'Gagal menghapus DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do Harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Harian',
      );
    }
  }
}
