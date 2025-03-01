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
      print('ini DO REGULER..: ${list.toList()}');
      return list.map((e) => DoRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do reguler');
    }
  }

  Future<List<DoRealisasiModel>> fetchAllRegulerData() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=getDataRegulerAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini..ALL DO REGULER..');
      return list.map((e) => DoRealisasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data do reguler');
    }
  }

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=Jumlah'),
          body: {
            'id': id.toString(),
            'user_pengurus': user,
            'jumlah_unit': jumlahUnit.toString(),
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
          print('..INI DATA DARI RESPONSE DO REGULER NYA :$responseData');
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

  Future<void> editDoReguler(
      int id,
      String plant,
      String tujuan,
      int type,
      String? plant2,
      String? tujuan2,
      String kendaraan,
      String supir,
      int jumlahUnit) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=Edit_Data'),
        body: {
          'id': id.toString(),
          'plant': plant,
          'tujuan': tujuan,
          'type': type.toString(),
          'plant_2': plant2 ?? '',
          'tujuan_2': tujuan2 ?? '',
          'kendaraan': kendaraan,
          'supir': supir,
          'jumlah_unit': jumlahUnit.toString()
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Do reguler berhasil diubah',
          );
        } else {
          CustomFullScreenLoader.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
          print('...ADA MASALAH DI EDIT DO REGULER REPO...');
        }
        return responseData;
      } else {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit do reguler, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error edit di repository DO Reguler: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit do reguler',
      );
    }
  }
}
