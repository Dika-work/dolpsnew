import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DoRegulerRepository {
  final storageUtil = StorageUtil();

  Future<List<DoRealisasiModel>> fetchDoRegulerData() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=getDataReguler'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => DoRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do reguler');
    }
  }

  Future<void> tambahJumlahUnit(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=Jumlah'),
          body: {
            'id': id.toString(),
            'status': '1',
          });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'error') {
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😢',
            message: responseData['message'] ?? 'Ada yang salah😒',
          );
          print(responseData['message']);
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.successSnackBar(
            title: 'Sukses🎉',
            message: 'Jumlah unit berhasil ditambahkan',
          );
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
