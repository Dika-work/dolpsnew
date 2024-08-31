import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/aksesoris_model.dart';
import '../../repository/input data realisasi/aksesoris_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import 'do_reguler_controller.dart';

class AksesorisController extends GetxController {
  final isLoadingAksesoris = Rx<bool>(false);
  final AksesorisRepository aksesorisRepo = Get.put(AksesorisRepository());
  final DoRegulerController doRegulerController =
      Get.put(DoRegulerController());
  RxList<AksesorisModel> aksesorisModel = <AksesorisModel>[].obs;
  RxList<bool> checkboxStatus = RxList<bool>.filled(
      10, false); // Sesuaikan panjang list sesuai jumlah checkbox
  RxList<int> accValues = RxList<int>.filled(10, 0);
  RxList<int> newValues = RxList<int>.filled(10, 0);
  RxList<TextEditingController> controllers =
      RxList<TextEditingController>.generate(
          10, (_) => TextEditingController());
  RxList<int> hutangValues = RxList<int>.filled(10, 0);

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < 10; i++) {
      controllers[i].addListener(() {
        if (checkboxStatus[i]) {
          newValues[i] = int.tryParse(controllers[i].text) ?? 0;
          updateHutangValues();
        }
      });
    }
  }

  void resetCheckboxes() {
    checkboxStatus.value = List<bool>.filled(checkboxStatus.length, false);
    for (var controller in controllers) {
      controller.clear();
    }
    updateHutangValues(); // Untuk memastikan hutangValues juga di-reset
  }

  Future<void> fetchAksesoris(int id) async {
    try {
      isLoadingAksesoris.value = true;
      final getAksesoris = await aksesorisRepo.fetchAksesoris(id);
      aksesorisModel.assignAll(getAksesoris);

      // Initialize accValues with fetched data
      if (aksesorisModel.isNotEmpty) {
        accValues[0] = aksesorisModel.first.accHLM;
        accValues[1] = aksesorisModel.first.accAC;
        accValues[2] = aksesorisModel.first.accKS;
        accValues[3] = aksesorisModel.first.accTS;
        accValues[4] = aksesorisModel.first.accBP;
        accValues[5] = aksesorisModel.first.accBS;
        accValues[6] = aksesorisModel.first.accPLT;
        accValues[7] = aksesorisModel.first.accSTAY;
        accValues[8] = aksesorisModel.first.accAcBesar;
        accValues[9] = aksesorisModel.first.accPlastik;

        for (int i = 0; i < 10; i++) {
          controllers[i].text = accValues[i].toString();
          newValues[i] = accValues[i];
        }

        updateHutangValues();
      }
    } catch (e) {
      print('Error while fetching aksesoris: $e');
    } finally {
      isLoadingAksesoris.value = false;
    }
  }

  Future<void> accSelesai(
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
    int hutangHlm,
    int hutangAc,
    int hutangKs,
    int hutangTs,
    int hutangBp,
    int hutangBs,
    int hutangPlt,
    int hutangStay,
    int hutangAcBesar,
    int hutangPlastik,
  ) async {
    CustomDialogs.loadingIndicator();
    try {
      print('Sending motor data:');
      print({
        'no_realisasi': id,
        'user_1': user,
        'jam_1': jam,
        'tgl_1': tgl,
        'hlm_1': hlm,
        'ac_1': ac,
        'ks_1': ks,
        'ts_1': ts,
        'bp_1': bp,
        'bs_1': bs,
        'plt_1': plt,
        'stay_1': stay,
        'ac_besar_1': acBesar,
        'plastik_1': plastik,
      });
      await aksesorisRepo.accMotor(id, user, jam, tgl, hlm, ac, ks, ts, bp, bs,
          plt, stay, acBesar, plastik);

      print('Sending hutang data:');
      print({
        'no_realisasi_hutang': id,
        'user_hutang': user,
        'jam_hutang': jam,
        'tgl_hutang': tgl,
        'hutang_hlm': hutangHlm,
        'hutang_ac': hutangAc,
        'hutang_ks': hutangKs,
        'hutang_ts': hutangTs,
        'hutang_bp': hutangBp,
        'hutang_bs': hutangBs,
        'hutang_plt': hutangPlt,
        'hutang_stay': hutangStay,
        'hutang_ac_besar': hutangAcBesar,
        'hutang_plastik': hutangPlastik,
      });
      await aksesorisRepo.accHutang(
          id,
          user,
          jam,
          tgl,
          hutangHlm,
          hutangAc,
          hutangKs,
          hutangTs,
          hutangBp,
          hutangBs,
          hutangPlt,
          hutangStay,
          hutangAcBesar,
          hutangPlastik);

      print('Marking as selesai:');
      await aksesorisRepo.accSelesai(id);
      resetCheckboxes();

      CustomFullScreenLoader.stopLoading();

      await doRegulerController.fetchRegulerContent();
      await doRegulerController.fetchRegulerAllContent();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil✨',
        message: 'Menambahkan data do harian baru..',
      );

      CustomFullScreenLoader.stopLoading();
    } catch (e) {
      print('Error in accSelesai: $e');
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan wifi kantor 😁',
      );
    }
  }

  void updateHutangValues() {
    for (int i = 0; i < newValues.length; i++) {
      if (checkboxStatus[i]) {
        hutangValues[i] = accValues[i] - newValues[i];
      } else {
        hutangValues[i] = 0;
      }
    }
  }

  bool get areAllCheckboxesChecked =>
      checkboxStatus.every((status) => status == true);
}
