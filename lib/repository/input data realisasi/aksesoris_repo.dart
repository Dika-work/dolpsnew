import 'dart:convert';

import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/input data realisasi/aksesoris_model.dart';

class AksesorisRepository {
  final storageUtil = StorageUtil();

  Future<List<AksesorisModel>> fetchAksesoris(int id) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=JumlahAcc&id=$id'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      // print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => AksesorisModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data DO Global Harian zzz☠️');
    }
  }

  Future<void> accMotor(
      int id,
      String user,
      String jam,
      String tgl,
      int hlm,
      int ac,
      int ks,
      int ts,
      int bp,
      int bs,
      int plt,
      int stay,
      int acBesar,
      int plastik) async {
    try {
      final response = await http.post(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=MotorAcc'),
          body: {
            'no_realisasi': id.toString(),
            'user_1': user,
            'jam_1': jam,
            'tgl_1': tgl,
            'hlm_1': hlm.toString(),
            'ac_1': ac.toString(),
            'ks_1': ks.toString(),
            'ts_1': ts.toString(),
            'bp_1': bp.toString(),
            'bs_1': bs.toString(),
            'plt_1': plt.toString(),
            'stay_1': stay.toString(),
            'ac_besar_1': acBesar.toString(),
            'plastik_1': plastik.toString(),
          });
      if (response.statusCode != 200) {
        // print('Failed to send motor data: ${response.body}');
        throw Exception('Failed to send motor data');
      } else {
        // print('Motor data sent successfully: ${response.body}');
      }
    } catch (e) {
      // print('Error in accMotor: $e');
      rethrow;
    }
  }

  Future<void> accHutang(
    int id,
    String user,
    String jam,
    String tgl,
    int hlm,
    int ac,
    int ks,
    int ts,
    int bp,
    int bs,
    int plt,
    int stay,
    int acBesar,
    int plastik,
  ) async {
    try {
      final response = await http.post(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_AccMotor.php?action=HutangAcc'),
          body: {
            'no_realisasi_hutang': id.toString(),
            'user_hutang': user,
            'jam_hutang': jam,
            'tgl_hutang': tgl,
            'hutang_hlm': hlm.toString(),
            'hutang_ac': ac.toString(),
            'hutang_ks': ks.toString(),
            'hutang_ts': ts.toString(),
            'hutang_bp': bp.toString(),
            'hutang_bs': bs.toString(),
            'hutang_plt': plt.toString(),
            'hutang_stay': stay.toString(),
            'hutang_ac_besar': acBesar.toString(),
            'hutang_plastik': plastik.toString(),
          });
      if (response.statusCode != 200) {
        // print('Failed to send hutang data: ${response.body}');
        throw Exception('Failed to send hutang data');
      } else {
        // print('Hutang data sent successfully: ${response.body}');
      }
    } catch (e) {
      // print('Error in accHutang: $e');
      rethrow;
    }
  }

  Future<void> accSelesai(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${storageUtil.baseURL}/DO/api/api_realisasi.php?action=Acc_Selesai'),
          body: {
            'id': id.toString(),
            'status': '4',
          });
      if (response.statusCode != 200) {
        print('Failed to mark as selesai: ${response.body}');
        throw Exception('Failed to mark as selesai');
      } else {
        print('Marked as selesai successfully: ${response.body}');
      }
    } catch (e) {
      print('Error in accSelesai: $e');
      throw Exception('Something went wrong, please contact developer');
    }
  }
}
