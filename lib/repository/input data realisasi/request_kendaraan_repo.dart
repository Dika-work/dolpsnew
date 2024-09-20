import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class RequestKendaraanRepository {
  final storageUtil = StorageUtil();

  Future<List<RequestKendaraanModel>> fetchTampilRequest() async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_request_ken.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list
          .map((model) => RequestKendaraanModel.fromJson(model))
          .toList();
    } else {
      throw Exception('Gagal untuk mengambil data tampil request kendaraan☠️');
    }
  }

  Future<void> addRequestKendaraan(
    String jam,
    String tgl,
    String pengurus,
    String plant,
    String tujuan,
    int type,
    String jenis,
    String jumlahReq,
    int statusReq,
  ) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_request_ken.php'),
          body: {
            'jam_req': jam,
            'tgl_req': tgl,
            'nama_pengurus': pengurus,
            'plant_req': plant,
            'tujuan_req': tujuan,
            'type_req': type.toString(),
            'jenis_req': jenis,
            'jumlah_req': jumlahReq.toString(),
            'status_req': statusReq.toString()
          });
      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data request kendaraan..',
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

  Future<void> editRequestKendaraan(
    int idReq,
    String tgl,
    String plant,
    String tujuan,
    int type,
    String jenisReq,
    int jumlahReq,
  ) async {
    try {
      final response = await http.put(
          Uri.parse('${storageUtil.baseURL}/DO/api/api_request_ken.php'),
          body: {
            'id_req': idReq.toString(),
            'tgl_req': tgl,
            'plant_req': plant,
            'tujuan_req': tujuan,
            'type_req': type.toString(),
            'jenis_req': jenisReq,
            'jumlah_req': jumlahReq.toString()
          });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Request kendaraan berhasil diubah',
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
              'Gagal mengedit Request kendaraan, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error di catch di repository Request Kendaraan: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit Request Kendaraan',
      );
    }
  }
}
