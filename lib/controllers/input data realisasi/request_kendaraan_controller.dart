import 'package:doplsnew/repository/input%20data%20realisasi/request_kendaraan_repo.dart';
import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../models/user_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../home/do_harian_home_controller.dart';

class RequestKendaraanController extends GetxController {
  final storageUtil = StorageUtil();
  final isRequestLoading = Rx<bool>(false);
  GlobalKey<FormState> requestKendaraanKey = GlobalKey<FormState>();

  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  String namaUser = '';
  final plant = '1100'.obs;
  final typeDO = 'REGULER'.obs;
  final idplant = '1'.obs;
  final typeDOValue = 0.obs;
  final jenisKendaraan = 'MOBIL MOTOR 16'.obs;
  TextEditingController jumlahKendaraanController = TextEditingController();

  // roles users
  RxInt rolesLihat = 0.obs;
  RxInt rolesKirim = 0.obs;
  RxInt rolesEdit = 0.obs;

  RxList<RequestKendaraanModel> requestKendaraanModel =
      <RequestKendaraanModel>[].obs;
  final dataDOHarianHomeController = Get.put(DataDOHarianHomeController());
  final requestRepo = Get.put(RequestKendaraanRepository());

  final Rx<int> jumlahHarian = 0.obs;

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
  String get idPlantValue => idPlantMap[idplant.value] ?? '';

  @override
  void onInit() {
    ever(plant, (_) {
      idplant.value = idPlantMap[plant.value] ?? '1';
      updateJumlahHarian();
    });

    ever(typeDO, (_) {
      typeDOValue.value = typeDOMap[typeDO.value] ?? 0;
      updateJumlahHarian();
    });

    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      rolesLihat.value = user.lihat;
      rolesKirim.value = user.kirim;
      rolesEdit.value = user.edit;
    }

    fetchRequestKendaraan();
    super.onInit();
  }

  void updateJumlahHarian() {
    if (typeDO.value == 'MUTASI') {
      jumlahHarian.value = 0;
    } else {
      final selectedPlant = plant.value;
      final data = dataDOHarianHomeController.doGlobalHarianModel
          .firstWhereOrNull((element) => element.plant == selectedPlant);
      jumlahHarian.value = data?.jumlah ?? 0;
    }
  }

  int getTypeDOValue() {
    return typeDOMap[typeDO.value] ?? 0;
  }

  Future<void> fetchRequestKendaraan() async {
    try {
      isRequestLoading.value = true;
      final requestKendaraan = await requestRepo.fetchTampilRequest();
      requestKendaraanModel.assignAll(requestKendaraan);
    } catch (e) {
      print('Error fetching request tampil kendaraan : $e');
      throw Exception('Gagal saat mengambil data request kendaraan');
    } finally {
      isRequestLoading.value = false;
    }
  }

  Future<void> addRequestKendaraan() async {
    CustomDialogs.loadingIndicator();

    if (!requestKendaraanKey.currentState!.validate()) {
      return;
    }

    await requestRepo.addRequestKendaraan(
        CustomHelperFunctions.formattedTime, //
        tgl.value, //
        namaUser,
        plant.value, //
        tujuanDisplayValue, //
        typeDOValue.value, //
        jenisKendaraan.value,
        jumlahKendaraanController.text.trim(),
        0);

    plant.value = '1100';
    jenisKendaraan.value = 'MOBIL MOTOR 16';
    jumlahKendaraanController.clear();

    await fetchRequestKendaraan();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do global baru..',
    );
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editReqKendaraan(
    int idReq,
    String tgl,
    String plant,
    String tujuan,
    int type,
    String jenisReq,
    int jumlahReq,
  ) async {
    CustomDialogs.loadingIndicator();

    await requestRepo.editRequestKendaraan(
        idReq, tgl, plant, tujuan, type, jenisReq, jumlahReq);
    await fetchRequestKendaraan();
    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  // Future<void> hapusReqKendaraan(int id) async {
  //   await requestRepo.deleteReqKendaraan(id);
  // }
}
