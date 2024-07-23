import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/popups/snackbar.dart';

class PlotRepository extends GetxController {
  final storageUtil = StorageUtil();

  Future<void> jumlahPlot(int idReq, String tgl, type, plant) async {
    try {
      final response = await http.post(
        Uri.parse('${storageUtil.baseURL}/DO/api/api_realisasi.php'),
        body: {
          'id_request': idReq.toString(),
          'tgl': tgl,
          'type': type.toString(),
          'plant': plant,
        },
      );

      if (response.statusCode != 200) {
        SnackbarLoader.errorSnackBar(
          title: 'Something went wrong👻',
          message: 'Please, contact developer...',
        );
      }
    } catch (e) {
      print('Error while jumlah plot kendaraan: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
    }
  }
}
