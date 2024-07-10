import 'dart:convert';

import 'package:doplsnew/models/do_tambah_model.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../utils/popups/snackbar.dart';

class DataDoTambahRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<List<DoTambahModel>> fetchDataTambahContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/DO/api/tampil_do_tambah.php'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DoTambahModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Harian☠️');
    }
  }

  Future<void> addDataTambah(
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
        Uri.parse(
            '${storageUtil.baseURL}/DO/api/tambah_do_tambah.php?id_plant=$idPlant&tujuan=$tujuan&tgl=$tgl&jam=$jam&jumlah_1=$srd&jumlah_2=$mks&jumlah_3=$ptk&jumlah_4=$bjm&jumlah_5=$jumlah5&jumlah_6=$jumlah6&user=$user&plant=$plant'),
      );

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
