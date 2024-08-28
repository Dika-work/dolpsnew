import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../repository/input data realisasi/estimasi_penambilan_repo.dart';

class EstimasiPengambilanController extends GetxController {
  final isEstimasiPengambilan = Rx<bool>(false);
  RxList<EstimasiPengambilanModel> estimasiPengambilanModel =
      <EstimasiPengambilanModel>[].obs;
  final estimasiPengambilanRepo = Get.put(EstimasiPenambilanRepository());
  GlobalKey<FormState> estimasiKey = GlobalKey<FormState>();

  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final jumlah = TextEditingController(text: '0');
  final plant = '1100'.obs;
  final typeDO = 'REGULER'.obs;
  final idplant = '1'.obs;
  final typeDOValue = 0.obs;
  final jenisKendaraan = 'MOBIL MOTOR 16'.obs;

  final List<String> regulerPlants = [
    '1100',
    '1200',
    '1300',
    '1350',
    '1700',
    '1800',
    'DC (Pondok Ungu)',
    'TB (Tambun Bekasi)',
    '1900'
  ];

  final List<String> jenisKendaraanList = [
    'MOBIL MOTOR 16',
    'MOBIL MOTOR 40',
    'MOBIL MOTOR 64',
    'MOBIL MOTOR 86',
  ];

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    'DC (Pondok Ungu)': 'Bekasi',
    'TB (Tambun Bekasi)': 'Bekasi',
    '1900': 'Bekasi',
  };

  final Map<String, String> idPlantMap = {
    '1100': '1',
    '1200': '2',
    '1300': '3',
    '1350': '4',
    '1700': '5',
    '1800': '6',
    'DC (Pondok Ungu)': '7',
    'TB (Tambun Bekasi)': '8',
    '1900': '9',
  };

  final Map<String, int> typeDOMap = {
    'REGULER': 0,
    'MUTASI': 1,
  };

  String get tujuanDisplayValue => tujuanMap[plant.value] ?? '';

  // void updateJumlahHarian() {
  //   if (typeDO.value == 'MUTASI') {
  //     jumlahHarian.value = 0;
  //   } else {
  //     final selectedPlant = plant.value;
  //     final data = dataDOHarianHomeController.doHarianHomeModel
  //         .firstWhereOrNull((element) => element.plant == selectedPlant);
  //     jumlahHarian.value = data?.jumlah ?? 0;
  //   }
  // }

  // @override
  // void onInit() {
  //   ever(plant, (_) {
  //     idplant.value = idPlantMap[plant.value] ?? '1';
  //     updateJumlahHarian();
  //   });

  //   ever(typeDO, (_) {
  //     typeDOValue.value = typeDOMap[typeDO.value] ?? 0;
  //     updateJumlahHarian();
  //   });
  //   super.onInit();
  // }
}
