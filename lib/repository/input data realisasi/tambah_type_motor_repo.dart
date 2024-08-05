import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/tambah_type_motor_model.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class TambahTypeMotorRepository {
  final storagetUtil = StorageUtil();

  Future<List<TambahTypeMotorModel>> fetchTambahTypeMotor(int id) async {
    final response = await http.get(Uri.parse(
        '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php?action=JumlahMotor&id=$id'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini isinya tambah type motor di repo : ${list.toList()}');
      return list.map((e) => TambahTypeMotorModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untum mengambil data type motor☠️');
    }
  }

  // func selesai di tambah type kendaraan
  Future<void> addTypeMotorDaerah(int idRealisasi, String jamDetail,
      String tglDetail, String daerah, String typeMotor, int jumlah) async {
    try {
      final response = await http.post(
          Uri.parse(
              '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php'),
          body: {
            'id_realisasi': idRealisasi.toString(),
            'jam_detail': jamDetail,
            'tgl_detail': tglDetail,
            'daerah': daerah,
            'type_motor': typeMotor,
            'jumlah': jumlah.toString()
          });

      if (response.statusCode != 200) {
        CustomFullScreenLoader.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan wifi kantor 😁',
        );
      }
    } catch (e) {
      CustomFullScreenLoader.stopLoading();
      print('Error while adding data in tambah type motor repo: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return;
    }
  }

  // func total plot di tambah type kendaraan
  Future<List<PlotModelRealisasi>> jumlahPlotRealisasi(int idRealisasi) async {
    try {
      final response = await http.get(Uri.parse(
          '${storagetUtil.baseURL}/DO/api/api_packing_list_motor.php?action=Totalplot&id_realisasi=$idRealisasi'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => PlotModelRealisasi.fromJson(e)).toList();
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Something went wrong👻',
          message: 'Please, contact developer...',
        );
        return [];
      }
    } catch (e) {
      print('Error while fetching jumlah plot realisasi: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
      return [];
    }
  }
}

class PlotModelRealisasi {
  int idRealisasi;
  int jumlahPlot;

  PlotModelRealisasi({
    required this.idRealisasi,
    required this.jumlahPlot,
  });

  factory PlotModelRealisasi.fromJson(Map<String, dynamic> json) {
    return PlotModelRealisasi(
      idRealisasi: json['id_realisasi'] ?? 0,
      jumlahPlot: json['plot'] ?? 0,
    );
  }
}
