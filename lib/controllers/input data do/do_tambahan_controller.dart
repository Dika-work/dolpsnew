import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataDoTambahanController extends GetxController {
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

  void AddDataDOTambahan() {}
}
