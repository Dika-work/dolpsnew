import 'dart:convert';

import 'package:doplsnew/models/input%20data%20realisasi/kirim_kendaraan_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../utils/popups/snackbar.dart';

class KirimKendaraanRepository {
  final storageUtil = StorageUtil();

  Future<List<KirimKendaraanModel>> fetchKirimKendaraan() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((e) => KirimKendaraanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data Kirim Kendaraan ☠');
    }
  }

  Future<void> addKirimKendaraan(
    int idReq,
    String plant,
    String tujuan,
    String plant2,
    String tujuan2,
    int type,
    int kendaraan,
    String supir,
    String jam,
    String tgl,
    int bulan,
    int tahun,
    String user,
  ) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_realisasi.php'),
          body: {
            'id_request': idReq.toString(),
            'plant': plant,
            'tujuan': tujuan,
            'plant_2': plant2,
            'tujuan_2': tujuan2,
            'type': type.toString(),
            'kendaraan': kendaraan.toString(),
            'supir': supir,
            'jam': jam,
            'tgl': tgl,
            'bulan': bulan.toString(),
            'tahun': tahun.toString(),
            'user': user,
          });

      if (response.statusCode != 200) {
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
        );
      }
    } catch (e) {
      print('Error while adding data kirim kendaraan: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }

  Future<void> hapusKirimKendaraan(int id) async {
    try {
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_realisasi.php'),
          body: {'id': id.toString()});

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
      print('Error di hapus kirim kendaraan: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus kirim kendaraan',
      );
    }
  }
}
