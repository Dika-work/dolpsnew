import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/popups/snackbar.dart';

class KirimKendaraanRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<void> addKirimKendaraan(
    int idReq,
    String plant,
    String tujuan,
    String plant2,
    String tujuan2,
    int type,
    String kendaraan,
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
            'plant2': plant2,
            'tujuan2': tujuan2,
            'type': type.toString(),
            'kendaraan': kendaraan,
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
}
