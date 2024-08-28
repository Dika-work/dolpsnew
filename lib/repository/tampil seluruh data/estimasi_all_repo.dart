import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/tampil seluruh data/do_estimasi_all.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class EstimasiAllRepository {
  final storageUtil = StorageUtil();

  Future<List<DoEstimasiAllModel>> fetchEstimasiContent() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_do_estimasi.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => DoEstimasiAllModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil seluruh data do estimasi');
    }
  }

  Future<void> addEstimasi(
    String tgl,
    String jam,
    int srd,
    int mks,
    int ptk,
    String user,
  ) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_estimasi.php'),
          body: {
            'tgl': tgl,
            'jam': jam,
            'jumlah_1': srd.toString(),
            'jumlah_2': mks.toString(),
            'jumlah_3': ptk.toString(),
            'jumlah_4': 0.toString(),
            'user': user,
          });
      if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Ada kesalahan, harap coba lagi : ${response.statusCode}😁',
        );
      }
    } catch (e) {
      print('ini error nya di estimasi all : ${e.toString()}');
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }

  Future<void> editEstimasi(
    int id,
    String tgl,
    int srd,
    int mks,
    int ptk,
  ) async {
    try {
      final response = await http.put(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_estimasi.php'),
          body: {
            'id': id.toString(),
            'tgl': tgl,
            'jumlah_1': srd.toString(),
            'jumlah_2': mks.toString(),
            'jumlah_3': ptk.toString(),
          });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Estimasi berhasil diubah',
          );
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message:
                'Gagal mengedit DO estimasi, status code: ${response.statusCode}',
          );
        }
        return responseData;
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit DO Estimasi, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do estimasi: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO estimasi',
      );
    }
  }

  Future<void> deleteEstimasi(int id) async {
    try {
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_do_estimasi.php'),
          body: {'id': id.toString()});

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Estimasi berhasil dihapus',
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
              'Gagal menghapus DO Estimasi, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository do Estimasi: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Estimasi',
      );
    }
  }
}
