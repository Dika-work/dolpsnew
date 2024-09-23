import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/tampil seluruh data/do_tambah_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/tambah_all_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataAllTambahController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false); // For lazy loading
  RxList<DoTambahAllModel> doGlobalHarianModel = <DoTambahAllModel>[].obs;
  RxList<DoTambahAllModel> displayedData = <DoTambahAllModel>[].obs;
  final dataGlobalHarianRepo = Get.put(TambahAllRepository());
  final networkManager = Get.find<NetworkManager>();
  final storageUtil = StorageUtil();

  // Lazy loading parameters
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  // roles users
  int rolesEdit = 0;
  int rolesHapus = 0;

  var pickDate = Rxn<DateTime>();
  final isConnected = Rx<bool>(true);
  final RxBool hasFetchedData = false.obs;

  @override
  void onInit() {
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      rolesEdit = user.edit;
      rolesHapus = user.hapus;
    }
    // Listener for connection changes
    networkManager.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
        return;
      } else {
        isConnected.value = true;
        if (!hasFetchedData.value) {
          fetchDataDoGlobal(); // Automatically fetch data when connection is restored
          scrollController.addListener(scrollListener);
          print('data global all :${displayedData.length}');
          hasFetchedData.value = true;
        }
      }
    });

    fetchDataDoGlobal(); // Initial fetch
    scrollController
        .addListener(scrollListener); // Add scroll listener for lazy loading
    super.onInit();
  }

  Future<void> fetchDataDoGlobal({DateTime? pickDate}) async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();

      List<DoTambahAllModel> filteredData;
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

  Future<void> editDOTambah(
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

    await dataGlobalHarianRepo.editDOTambahContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOTambah(
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

    await dataGlobalHarianRepo.deleteDOTambahContent(id);

    await fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }
}
