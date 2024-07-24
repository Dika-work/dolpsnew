import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../controllers/input data realisasi/plot_kendaraan_controller.dart';
import '../../utils/popups/snackbar.dart';

class PlotRepository {
  final storageUtil = StorageUtil();

  Future<List<PlotModel>> jumlahPlot(
      int idReq, String tgl, int type, String plant) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=JumlahKen&tgl=$tgl&type=$type&plant=$plant&id_request=$idReq'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PlotModel.fromJson(json)).toList();
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Something went wrong👻',
          message: 'Please, contact developer...',
        );
        return [];
      }
    } catch (e) {
      print('Error while fetching jumlah plot: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return [];
    }
  }
}
