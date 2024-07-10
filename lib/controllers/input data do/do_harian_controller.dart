import 'package:doplsnew/models/do_harian_model.dart';
import 'package:doplsnew/repository/input%20data%20do/do_harian_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataDoHarianController extends GetxController {
  final isLoadingHarian = Rx<bool>(false);
  RxList<DoHarianModel> doHarianModel = <DoHarianModel>[].obs;
  final dataHarianRepo = Get.put(DataDoHarianRepository());
  final tgl = ''.obs;
  final plant = '1100'.obs;
  final tujuan = '1'.obs;

  final srdController = TextEditingController();
  final mksController = TextEditingController();
  final ptkController = TextEditingController();
  final bjmController = TextEditingController();

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    '1900': 'Bekasi',
    'DC (Pondok Ungu)': 'Bekasi',
    'TB (Tambun Bekasi)': 'Cikarang',
  };

  String get tujuanDisplayValue => tujuanMap[plant.value] ?? '';

  @override
  void onInit() {
    fetchDataDoHarian();
    super.onInit();
  }

  Future<void> fetchDataDoHarian() async {
    try {
      isLoadingHarian.value = true;
      final dataHarian = await dataHarianRepo.fetchDataHarianContent();
      doHarianModel.assignAll(dataHarian);
    } catch (e) {
      print('Error fetching data do harian : $e');
      doHarianModel.assignAll([]);
    } finally {
      isLoadingHarian.value = false;
    }
  }

  void AddDataDOHarian() {}
}
