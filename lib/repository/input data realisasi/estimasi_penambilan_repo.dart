import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class EstimasiPenambilanRepository {
  final storageUtil = StorageUtil();

  Future<List<EstimasiPengambilanModel>> fetchEstimasiPengambilan() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_estimasi_kendaraaan.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => EstimasiPengambilanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil seluruh data do estimasi');
    }
  }

  Future<void> addEstimasiPengambilanMotor(
      String idPlant,
      String tujuan,
      int type,
      String jenisKen,
      String jumlah,
      String user,
      String jam,
      String tgl) async {
    try {
      final response = await http.post(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_estimasi_kendaraaan.php'),
          body: {
            'plant': idPlant,
            'tujuan': tujuan,
            'type': type.toString(),
            'jenis': jenisKen,
            'jumlah': jumlah,
            'user': user,
            'jam': jam,
            'tgl': tgl,
          });

      if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan internet😁',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error while adding data estimasi: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan internet😊',
      );
      return;
    }
  }

  Future<void> editEstimasiPengambilanMotor(
      int idPlot,
      int idPlant,
      String tujuan,
      int type,
      String jenisKen,
      int jumlah,
      String user,
      String jam,
      String tgl) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_estimasi_kendaraaan.php'),
          body: {
            'id_plot': idPlot.toString(),
            'plant': idPlant.toString(),
            'tujuan': tujuan,
            'type': type.toString(),
            'jenis': jenisKen,
            'jumlah': jumlah.toString(),
            'user': user,
            'jam': jam,
            'tgl': tgl,
          });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Estimasi pengambilan motor berhasil diubah',
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
              'Gagal mengedit estimasi pengambilan motor, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error di catch di repository estimasi pengambilan motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit estimasi pengambilan motor',
      );
    }
  }

  Future<void> deleteEstimasiPengambilanMotor(
    int idPlot,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Harian...');
      final response = await http.delete(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_estimasi_kendaraaan.php'),
          body: {'id_plot': idPlot.toString()});

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
