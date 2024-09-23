import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/tampil seluruh data/do_global_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/global_all_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class DataAllGlobalController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false); // For lazy loading

  RxList<DoGlobalAllModel> doAllGlobalModel = <DoGlobalAllModel>[].obs;
  RxList<DoGlobalAllModel> displayedData = <DoGlobalAllModel>[].obs;

  final dataGlobalAllRepo = Get.put(GlobalAllRepository());
  final storageUtil = StorageUtil();

  // Lazy loading parameters
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  final isConnected = Rx<bool>(true);
  final RxBool hasFetchedData = false.obs;

  final networkManager = Get.find<NetworkManager>();

  // Roles
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

    // Listener for connection changes
    networkManager.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
        return;
      } else {
        isConnected.value = true;
        if (!hasFetchedData.value) {
          fetchAllGlobalData(); // Automatically fetch data when connection is restored
          scrollController.addListener(scrollListener);
          print('data global all :${displayedData.length}');
          hasFetchedData.value = true;
        }
      }
    });

    fetchAllGlobalData(); // Initial fetch
    scrollController
        .addListener(scrollListener); // Add scroll listener for lazy loading
    super.onInit();
  }

  Future<void> fetchAllGlobalData({DateTime? pickDate}) async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalAllRepo.fetchGlobalHarianContent();

      List<DoGlobalAllModel> filteredData;
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

      doAllGlobalModel.assignAll(filteredData);

      // Lazy loading: Display initial data
      displayedData.assignAll(
        doAllGlobalModel.take(initialDataCount).toList(),
      );
      print('Initial data loaded: ${displayedData.length} items');
    } catch (e) {
      print('Error fetching global data: $e');
      doAllGlobalModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  // Reset filter date
  void resetFilterDate() {
    pickDate.value = null;
    fetchAllGlobalData();
  }

  // Scroll listener for lazy loading
  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        displayedData.length < doAllGlobalModel.length) {
      loadMoreData();
    }
  }

  // Load more data as part of lazy loading
  void loadMoreData() {
    if (displayedData.length < doAllGlobalModel.length) {
      print("Loading more data...");
      isLoadingMore.value = true;

      final nextData = doAllGlobalModel
          .skip(displayedData.length)
          .take(loadMoreCount)
          .toList();
      displayedData.addAll(nextData);
      print('Additional data loaded: ${displayedData.length} items');

      isLoadingMore.value = false;
    }
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

    await dataGlobalAllRepo.editDOGlobalContent(
        id, tgl, idPlant, tujuan, srd, mks, ptk, bjm);
    CustomFullScreenLoader.stopLoading();

    await fetchAllGlobalData();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusDOGlobal(int id) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }
    await dataGlobalAllRepo.deleteDOGlobalContent(id);

    await fetchAllGlobalData();
    CustomFullScreenLoader.stopLoading();
  }
}
