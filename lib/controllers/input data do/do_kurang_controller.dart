import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data do/do_kurang_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data do/do_kurang_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../home/do_harian_home_bsk_controller.dart';
import '../home/do_harian_home_controller.dart';

class DataDOKurangController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoadingKurang = Rx<bool>(false);
  RxList<DoKurangModel> doKurangModel = <DoKurangModel>[].obs;
  final dataKurangRepo = Get.put(DataDoKurangRepository());
  GlobalKey<FormState> addKurangKey = GlobalKey<FormState>();

  final dataHarianHomeController = Get.put(DataDOHarianHomeController());
  final dataHarianHomeBskController = Get.put(DoHarianHomeBskController());

  final isConnected = Rx<bool>(true);
  final networkManager = Get.find<NetworkManager>();

  final tujuan = '1'.obs;
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final plant = '1100'.obs;
  final idplant = '1'.obs;
  String namaUser = '';
  String roleUser = '';
  String rolePlant = '';

  bool get isAdmin => roleUser == 'admin';

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;

  final srdController = TextEditingController();
  final mksController = TextEditingController();
  final ptkController = TextEditingController();
  final bjmController = TextEditingController();
  final jumlah5 = TextEditingController(text: '0');
  final jumlah6 = TextEditingController(text: '0');

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  final Map<String, String> idPlantMap = {
    '1100': '1', //1
    '1200': '2', //2
    '1300': '3', //3
    '1350': '4', //4
    '1700': '5', //5
    '1800': '6', //6
    '1900': '9', //9
  };

  String get tujuanDisplayValue => tujuanMap[plant.value] ?? '';

  @override
  void onInit() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
      roleUser = user.tipe;
      rolePlant = user.plant;

      // nyesuain plant dengan tipe admin atau bukan
      if (!isAdmin) {
        plant.value = rolePlant;
        idplant.value = idPlantMap[rolePlant] ?? '1';
        tujuan.value = idPlantMap[plant.value] ?? '1';
      } else {
        idplant.value = idPlantMap[plant.value] ?? '1';
      }
    }
    // mengubah idPlant berdasarkan plant yg dipilih
    ever(plant, (_) {
      idplant.value = idPlantMap[plant.value] ?? '1';
    });

    // Listener untuk memantau perubahan koneksi
    networkManager.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Jika koneksi hilang, tampilkan pesan
        if (isConnected.value) {
          isConnected.value = false;
          return;
        }
      } else {
        // Jika koneksi kembali, perbarui status koneksi
        if (!isConnected.value) {
          isConnected.value = true;
          fetchDataDoKurang(); // Otomatis fetch data ketika koneksi kembali
        }
      }
    });

    fetchDataDoKurang();
    super.onInit();
  }

  Future<void> fetchDataDoKurang() async {
    try {
      isLoadingKurang.value = true;
      isConnected.value = true;
      final dataKurang = await dataKurangRepo.fetchDataKurangContent();
      if (dataKurang.isNotEmpty) {
        if (isAdmin) {
          doKurangModel.assignAll(dataKurang);
        } else {
          doKurangModel.assignAll(
              dataKurang.where((e) => e.plant == rolePlant).toList());
        }
      } else {
        doKurangModel.assignAll([]);
      }
    } catch (e) {
      print('Error fetching data do kurang : $e');
      throw Exception('Gagal saat mengambil data do kurang');
    } finally {
      isLoadingKurang.value = false;
    }
  }

  Future<void> addDataDOKurang() async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!addKurangKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    bool isDuplicate = doKurangModel.any((data) =>
        data.idPlant.toString() == idplant.value && data.tgl == tgl.value);

    if (isDuplicate) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Maaf tanggal dan plant sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    await dataKurangRepo.addDataKurang(
        idplant.value,
        tujuanDisplayValue,
        tgl.value,
        CustomHelperFunctions.formattedTime,
        srdController.text.trim(),
        mksController.text.trim(),
        ptkController.text.trim(),
        bjmController.text.trim(),
        jumlah5.text.trim(),
        jumlah6.text.trim(),
        namaUser,
        plant.value);
    print('Stopped loading dialog');

    srdController.clear();
    mksController.clear();
    ptkController.clear();
    bjmController.clear();

    await fetchDataDoKurang();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();

    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editDOGlobal(
    int id,
    String tgl,
    int idPlant,
    String tujuan,
    int srd,
    int mks,
    int ptk,
    int bjm,
  ) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await dataKurangRepo.editDOKurangContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoKurang();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOKurang(
    int id,
  ) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }
    await dataKurangRepo.deleteDOKurangContent(id);

    await fetchDataDoKurang();
    await dataHarianHomeController.fetchDataDoGlobal();
    await dataHarianHomeBskController.fetchHarianBesok();
    CustomFullScreenLoader.stopLoading();
  }
}
