import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/master data/type_motor_model.dart';
import '../../repository/master data/type_motor_repo.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class TypeMotorController extends GetxController {
  final isLoadingTypeMotor = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false); // For lazy loading

  RxList<TypeMotorModel> typeMotorModel = <TypeMotorModel>[].obs;
  RxList<TypeMotorModel> displayedData = <TypeMotorModel>[].obs;
  final typeMotorRepo = Get.put(TypeMotorRepository());
  GlobalKey<FormState> addTypeMotor = GlobalKey<FormState>();

  // Lazy loading parameters
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  final isConnected = Rx<bool>(true);
  final RxBool hasFetchedData = false.obs;
  final networkManager = Get.find<NetworkManager>();

  final List<String> typeMotorList = [
    'Honda',
    'Yamaha',
    'Kawasaki',
    'Suzuki',
  ];
  RxString merkValue = 'Honda'.obs;

  TextEditingController typeMotorController = TextEditingController();
  RxnInt hlm = RxnInt();
  RxnInt ac = RxnInt();
  RxnInt ks = RxnInt();
  RxnInt ts = RxnInt();
  RxnInt bp = RxnInt();
  RxnInt bs = RxnInt();
  RxnInt plt = RxnInt();
  RxnInt stay = RxnInt();
  RxnInt acBesar = RxnInt();
  RxnInt plastik = RxnInt();

  @override
  void onInit() {
    scrollController.addListener(scrollListener);

    // Listener untuk memantau perubahan koneksi
    networkManager.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Jika koneksi hilang, tampilkan pesan
        if (isConnected.value) {
          isConnected.value = false;
        }
      } else {
        // Jika koneksi kembali, perbarui status koneksi
        isConnected.value = true;
        if (!hasFetchedData.value) {
          fetchTypeMotorData(); // Otomatis fetch data ketika koneksi kembali
          print('data harian all :${displayedData.length}');
          hasFetchedData.value = true;
        }
      }
    });

    fetchTypeMotorData();
    super.onInit();
  }

  // Scroll listener for lazy loading
  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        displayedData.length < typeMotorModel.length) {
      loadMoreData();
    }
  }

  // Load more data as part of lazy loading
  void loadMoreData() {
    if (displayedData.length < typeMotorModel.length) {
      print("Loading more data...");
      isLoadingMore.value = true;

      final nextData = typeMotorModel
          .skip(displayedData.length)
          .take(loadMoreCount)
          .toList();
      displayedData.addAll(nextData);
      print('Additional data loaded: ${displayedData.length} items');

      isLoadingMore.value = false;
    }
  }

  Future<void> fetchTypeMotorData() async {
    try {
      final connectionStatus = await networkManager.isConnected();
      if (!connectionStatus) {
        isConnected.value = false;
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silakan coba lagi setelah koneksi tersedia',
        );
        return;
      }

      isLoadingTypeMotor.value = true;
      isConnected.value = true;
      final getTypeMotor = await typeMotorRepo.fetchTypeMotorContent();
      typeMotorModel.assignAll(getTypeMotor);
      displayedData.assignAll(
        typeMotorModel.take(initialDataCount).toList(),
      );
    } catch (e) {
      print('Error while fetching master type motor: $e');
      typeMotorModel.assignAll([]);
    } finally {
      isLoadingTypeMotor.value = false;
    }
  }

  Future<void> addTypeMotorData() async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!addTypeMotor.currentState!.validate() ||
        hlm.value == null ||
        ac.value == null ||
        ks.value == null ||
        ts.value == null ||
        bp.value == null ||
        bs.value == null ||
        plt.value == null ||
        stay.value == null ||
        acBesar.value == null ||
        plastik.value == null) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Oops👻',
        message: 'Harap di cek kembali...',
      );
      return;
    }

    await typeMotorRepo.addTipeMotor(
        merkValue.value.toLowerCase(),
        typeMotorController.text,
        hlm.value!,
        ac.value!,
        ks.value!,
        ts.value!,
        bp.value!,
        bs.value!,
        plt.value!,
        stay.value!,
        acBesar.value!,
        plastik.value!);

    typeMotorController.clear();
    hlm.value = null;
    ac.value = null;
    ks.value = null;
    ts.value = null;
    bp.value = null;
    bs.value = null;
    plt.value = null;
    stay.value = null;
    acBesar.value = null;
    plastik.value = null;

    await fetchTypeMotorData();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data type motor..',
    );

    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editTypeMotor(
      int idType,
      String merk,
      String typeMotor,
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
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await typeMotorRepo.editTypeMotorData(idType, merk, typeMotor, hlm, ac, ks,
        ts, bp, bs, plt, stay, acBesar, plastik);
    CustomFullScreenLoader.stopLoading();

    await fetchTypeMotorData();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusTypeMotorData(int idType) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await typeMotorRepo.hapusTypeMotor(idType);
    await fetchTypeMotorData();

    CustomFullScreenLoader.stopLoading();
  }
}

class TypeMotorHondaController extends GetxController {
  final isTypeHondaLoading = Rx<bool>(false);
  final typeMotorHondaRepo = Get.put(TypeMotorHondaRepository());
  RxList<TypeMotorHondaModel> typeMotorHondaModel = <TypeMotorHondaModel>[].obs;

  RxString selectedTypeMotor = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTypeMotorHonda();
  }

  List<TypeMotorHondaModel> get filteredMerkMotor {
    if (selectedTypeMotor.value.isEmpty) {
      return typeMotorHondaModel;
    }

    final filtered = typeMotorHondaModel
        .where((motor) => motor.typeMotor
            .toLowerCase()
            .contains(selectedTypeMotor.value.toLowerCase()))
        .toList();

    return filtered;
  }

  void updateSelectedTypeMotor(String value) {
    selectedTypeMotor.value = value;
  }

  void setSelectedTypeMotor(String typeMotor) {
    selectedTypeMotor.value = typeMotor;
  }

  void resetSelectedTypeMotor() {
    selectedTypeMotor.value = '';
  }

  Future<void> fetchTypeMotorHonda() async {
    try {
      isTypeHondaLoading(true);
      final dataHonda = await typeMotorHondaRepo.fetchTypeMotorHondaContent();
      typeMotorHondaModel.assignAll(dataHonda);
    } catch (e) {
      typeMotorHondaModel.assignAll([]);
    } finally {
      isTypeHondaLoading(false);
    }
  }
}
