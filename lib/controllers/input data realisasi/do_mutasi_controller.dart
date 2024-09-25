import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_mutasi_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';

class DoMutasiController extends GetxController {
  final isLoadingMutasi = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  RxList<DoRealisasiModel> doRealisasiModelAll = <DoRealisasiModel>[].obs;
  RxList<DoRealisasiModel> displayedData = <DoRealisasiModel>[].obs;

  // lazy loading
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  final doMutasiRepo = Get.put(DoMutasiRepository());

  String rolePlant = '';
  String roleUser = '';

  // roles users
  int rolesLihat = 0;
  int rolesBatal = 0;
  int rolesEdit = 0;
  int rolesJumlah = 0;

  final storageUtil = StorageUtil();
  var startPickDate = Rxn<DateTime>();
  var endPickDate = Rxn<DateTime>();

  bool get isAdmin => roleUser == 'admin' || roleUser == 'k.pool';
  bool get isPengurusPabrik => roleUser == 'Pengurus Pabrik';

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      rolesLihat = user.lihat;
      rolesBatal = user.batal;
      rolesEdit = user.edit;
      rolesJumlah = user.jumlah;
      roleUser = user.tipe;
      rolePlant = user.plant;
    }
  }

  Future<void> fetchMutasiContent() async {
    try {
      isLoadingMutasi.value = true;
      final getMutasiDo = await doMutasiRepo.fetchDoMutasiData();

      if (getMutasiDo.isNotEmpty) {
        if (isAdmin) {
          doRealisasiModel.assignAll(getMutasiDo);
        } else {
          doRealisasiModel.assignAll(
              getMutasiDo.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doRealisasiModel.assignAll([]);
      }
    } catch (e) {
      print('Error while fetching data do Mutasi: $e');
      throw Exception('Gagal mengambil data do mutasi');
    } finally {
      isLoadingMutasi.value = false;
    }
  }

  Future<void> fetchMutasiAllContent(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      isLoadingMutasi.value = true;

      // Fetch all Mutasi data from the repository
      final getRegulerDo = await doMutasiRepo.fetchAllMutasiData();
      print("Raw data fetched: ${getRegulerDo.length} items");

      if (getRegulerDo.isNotEmpty) {
        // Step 1: Filter by date if the date range is provided
        final filteredData = getRegulerDo.where((item) {
          final itemDate = DateTime.parse(item.tgl);

          if (startDate != null && endDate != null) {
            return itemDate
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                itemDate.isBefore(endDate.add(const Duration(days: 1)));
          }
          return true; // If no date range is provided, include all items
        }).toList();

        print("Filtered by date: ${filteredData.length} items");

        // Step 2: Filter by rolePlant if necessary
        List<DoRealisasiModel> roleFilteredData = filteredData;

        if (!isPengurusPabrik) {
          if (rolePlant != '0') {
            roleFilteredData =
                filteredData.where((item) => item.plant == rolePlant).toList();
            print(
                "Filtered by rolePlant ($rolePlant): ${roleFilteredData.length} items");
          } else {
            print(
                "Skipping rolePlant filtering because rolePlant is 0 or null");
          }
        } else {
          print("User is Pengurus Pabrik, no filtering by plant.");
        }

        // Step 3: Assign the filtered data to doRealisasiModelAll
        doRealisasiModelAll.assignAll(roleFilteredData);

        print("Final data assigned: ${doRealisasiModelAll.length}");

        // Step 4: Lazy loading: assign initial data to displayedData
        displayedData
            .assignAll(doRealisasiModelAll.take(initialDataCount).toList());
        print(
            'Initial data loaded with filtering: ${displayedData.length} items');
      } else {
        doRealisasiModelAll.assignAll([]);
      }
    } catch (e) {
      print('Error while fetching data do mutasi: $e');
      throw Exception('Gagal mengambil data do mutasi');
    } finally {
      isLoadingMutasi.value = false;
    }
  }

  void resetFilterDate() {
    startPickDate.value = null; // Clear the selected date
    endPickDate.value = null; // Clear the selected date
    fetchMutasiAllContent(); // Fetch all data without filtering
  }

  // lazy loading func
  void scrollListener() {
    print(
        "Scroll Position: ${scrollController.position.pixels}, Max Scroll: ${scrollController.position.maxScrollExtent}");
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMutasi.value &&
        !isLoadingMore.value) {
      // Load more data when reaching the bottom
      loadMoreData();
    }
  }

  void loadMoreData() {
    // Load additional data if available
    if (displayedData.length < doRealisasiModelAll.length &&
        !isLoadingMore.value) {
      print("Loading more data...");
      isLoadingMore.value = true;
      final nextData = doRealisasiModelAll
          .skip(displayedData.length)
          .take(loadMoreCount)
          .toList();
      displayedData.addAll(nextData);

      print(
          'Additional data loaded: ${displayedData.length} items'); // Cetak jumlah data setelah load more
      isLoadingMore.value = false;
    }
  }

  Future<void> editRealisasiMutasi(
      int id,
      String plant,
      String tujuan,
      int type,
      String plant2,
      String tujuan2,
      String kendaraan,
      String supir,
      int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doMutasiRepo.editDoMutasi(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchMutasiContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editRealisasiAllMutasi(
      int id,
      String plant,
      String tujuan,
      int type,
      String plant2,
      String tujuan2,
      String kendaraan,
      String supir,
      int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doMutasiRepo.editDoMutasi(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchMutasiAllContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doMutasiRepo.tambahJumlahUnit(id, user, jumlahUnit);
    await fetchMutasiContent();

    CustomFullScreenLoader.stopLoading();
  }
}
