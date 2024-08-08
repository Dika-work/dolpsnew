import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/aksesoris_model.dart';
import '../../repository/input data realisasi/aksesoris_repo.dart';

class AksesorisController extends GetxController {
  final isLoadingAksesoris = Rx<bool>(false);
  final AksesorisRepository aksesorisRepo = Get.put(AksesorisRepository());
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
