import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/sopir_model.dart';
import '../../repository/input data realisasi/sopir_repo.dart';

class FetchSopirController extends GetxController {
  final sopirRepo = Get.put(SopirRepository());
  RxList<SopirModel> sopirModel = <SopirModel>[].obs;
  RxString selectedSopirDisplay = ''.obs;
  RxString selectedSopirNama = ''.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    fetchSopirData();
    super.onInit();
  }

  void updateSelectedSopir(String value) {
    selectedSopirDisplay.value = value;
    final sopir = sopirModel.firstWhere(
      (sopir) => '${sopir.nama} - (${sopir.namaPanggilan})' == value,
      orElse: () =>
          SopirModel(id: 0, nama: '', namaPanggilan: '', namaDivisi: ''),
    );
    selectedSopirNama.value = sopir.nama;
  }

  Future<void> fetchSopirData() async {
    try {
      final dataSopir = await sopirRepo.fetchGlobalHarianContent();
      sopirModel.assignAll(dataSopir);
      if (sopirModel.isNotEmpty) {
        selectedSopirDisplay.value =
            '${sopirModel.first.nama} - (${sopirModel.first.namaPanggilan})';
        selectedSopirNama.value = sopirModel.first.nama;
      }
    } catch (e) {
      print('Error while fetching sopir data: $e');
      sopirModel.assignAll([]);
    }
  }

  List<SopirModel> get filteredSopir {
    if (searchQuery.value.isEmpty) {
      return sopirModel;
    }
    return sopirModel.where((sopir) =>
        sopir.nama.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        sopir.namaPanggilan.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }
}