import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/tampil seluruh data/do_global_all.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class GlobalAllRepository {
  final storageUtil = StorageUtil();

  Future<List<DoGlobalAllModel>> fetchGlobalHarianContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_global.php?action=getDataAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoGlobalAllModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian☠️');
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
