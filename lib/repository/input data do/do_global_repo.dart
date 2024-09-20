import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data do/do_global_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataDoGlobalRepository {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalModel>> fetchDataGlobalContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_global.php?action=getData'));
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
  ) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_global.php'),
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
          });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data do global baru..',
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
      CustomFullScreenLoader.stopLoading();
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan internet 😁',
      );
      return;
    }
  }

  Future<void> editDOGlobalContent(
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
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/DO/api/api_do_global.php'),
        body: {
          'id': id.toString(),
          'tgl': tgl,
          'id_plant': idPlant.toString(),
          'tujuan': tujuan,
          'jumlah_1': srd.toString(),
          'jumlah_2': mks.toString(),
          'jumlah_3': ptk.toString(),
          'jumlah_4': bjm.toString(),
        },
      );

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Global berhasil diubah',
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
              'Gagal mengedit DO Global, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do Global: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Global',
      );
    }
  }

  Future<void> deleteDOGlobalContent(
    int id,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Global...');
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_global.php'),
          body: {'id': id.toString()});

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Global berhasil dihapus',
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
              'Gagal menghapus DO Global, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do Global: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Global',
      );
    }
  }
}
