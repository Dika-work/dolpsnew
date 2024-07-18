import 'dart:convert';

import 'package:doplsnew/models/input%20data%20realisasi/request_kendaraan_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../utils/popups/snackbar.dart';

class RequestKendaraanRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<RequestKendaraanModel>> fetchTampilRequest() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/req_tampil.php'));
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
      final response = await http.post(Uri.parse(
          '${storageUtil.baseURL}/DO/api/req_tambah.php?jam_req=$jam&tgl_req=$tgl&nama_pengurus=$pengurus&plant_req=$plant&tujuan_req=$tujuan&type_req=$type&jenis_req=$jenis&jumlah_req=$jumlahReq&status_req=$statusReq'));
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
}
