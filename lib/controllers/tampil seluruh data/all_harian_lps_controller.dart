import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/tampil seluruh data/do_harian_all_lps.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/harian_all_lps_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataAllHarianLpsController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false); // For lazy loading
  RxList<DoHarianAllLpsModel> doGlobalHarianModel = <DoHarianAllLpsModel>[].obs;
  RxList<DoHarianAllLpsModel> displayedData = <DoHarianAllLpsModel>[].obs;
  final dataGlobalHarianRepo = Get.put(GlobalHarianAllLpsRepository());
  final storageUtil = StorageUtil();

  // Lazy loading parameters
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  final isConnected = Rx<bool>(true);
  final RxBool hasFetchedData = false.obs;
  final networkManager = Get.find<NetworkManager>();

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;

  var pickDate = Rxn<DateTime>();

  @override
  void onInit() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
    }

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
        isConnected.value = true;
        if (!hasFetchedData.value) {
          fetchDataDoGlobal(); // Automatically fetch data when connection is restored
          scrollController.addListener(scrollListener);
          print('data harian all :${displayedData.length}');
          hasFetchedData.value = true;
        }
      }
    });

    fetchDataDoGlobal();
    scrollController.addListener(scrollListener);
    super.onInit();
  }

  Future<void> fetchDataDoGlobal({DateTime? pickDate}) async {
    try {
      isLoadingGlobalHarian.value = true;
      isConnected.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();

      List<DoHarianAllLpsModel> filteredData;

      if (pickDate != null) {
        filteredData = dataHarian.where((data) {
          final dataDate = DateTime.parse(data.tgl);
          return dataDate.year == pickDate.year &&
              dataDate.month == pickDate.month &&
              dataDate.day == pickDate.day;
        }).toList();
      } else {
        filteredData = dataHarian;
      }

      doGlobalHarianModel.assignAll(filteredData);

      // Lazy loading: Display initial data
      displayedData.assignAll(
        doGlobalHarianModel.take(initialDataCount).toList(),
      );
      print('Initial data loaded: ${displayedData.length} items');
    } catch (e) {
      //print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void resetFilterDate() {
    pickDate.value = null; // Clear the selected date
    fetchDataDoGlobal(); // Fetch all data without filtering
  }

  // Scroll listener for lazy loading
  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        displayedData.length < doGlobalHarianModel.length) {
      loadMoreData();
    }
  }

  // Load more data as part of lazy loading
  void loadMoreData() {
    if (displayedData.length < doGlobalHarianModel.length) {
      print("Loading more data...");
      isLoadingMore.value = true;

      final nextData = doGlobalHarianModel
          .skip(displayedData.length)
          .take(loadMoreCount)
          .toList();
      displayedData.addAll(nextData);
      print('Additional data loaded: ${displayedData.length} items');

      isLoadingMore.value = false;
    }
  }

  Future<void> editDOHarian(
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

    await dataGlobalHarianRepo.editDOHarianContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOHarian(
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
    await dataGlobalHarianRepo.deleteDOHarianContent(id);

    await fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }
}
