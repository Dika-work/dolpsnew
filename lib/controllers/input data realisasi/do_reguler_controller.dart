import 'package:doplsnew/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../repository/input data realisasi/do_reguler_repo.dart';
import '../../repository/input data realisasi/kirim_kendaraan_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';
import 'do_mutasi_controller.dart';

class DoRegulerController extends GetxController {
  final isLoadingReguler = Rx<bool>(false);
  final isLoadingRegulerAll = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false);
  RxList<DoRealisasiModel> doRealisasiModel = <DoRealisasiModel>[].obs;
  RxList<DoRealisasiModel> doRealisasiModelAll = <DoRealisasiModel>[].obs;
  RxList<DoRealisasiModel> displayedData = <DoRealisasiModel>[].obs;

  // lazy loading
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 10;
  int loadMoreCount = 5;

  final doRegulerRepo = Get.put(DoRegulerRepository());
  final kirimKendaraanRepo = Get.put(KirimKendaraanRepository());
  final doMutasiController = Get.put(DoMutasiController());

  String roleUser = '';
  String rolePlant = '';
  final storageUtil = StorageUtil();
  String namaUser = '';
  var startPickDate = Rxn<DateTime>();
  var endPickDate = Rxn<DateTime>();

  // roles users
  int rolesLihat = 0;
  int rolesBatal = 0;
  int rolesEdit = 0;
  int rolesJumlah = 0;

  bool get isAdmin => roleUser == 'admin' || roleUser == 'k.pool';
  // bool get isPengurusPabrik => roleUser == 'Pengurus Pabrik';

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
      roleUser = user.tipe;
      rolesLihat = user.lihat;
      rolePlant = user.plant;
      rolesBatal = user.batal;
      rolesEdit = user.edit;
      rolesJumlah = user.jumlah;
    }
  }

  Future<void> fetchRegulerContent() async {
    try {
      isLoadingReguler.value = true;
      final getRegulerDo = await doRegulerRepo.fetchDoRegulerData();

      if (getRegulerDo.isNotEmpty) {
        if (isAdmin) {
          doRealisasiModel.assignAll(getRegulerDo);
        } else {
          doRealisasiModel.assignAll(
              getRegulerDo.where((item) => item.plant == rolePlant).toList());
        }
      } else {
        doRealisasiModel.assignAll([]);
      }
    } catch (e) {
      print('Error while fetching data do reguler asad: $e');
      throw Exception('Gagal mengambil data do reguler');
    } finally {
      isLoadingReguler.value = false;
    }
  }

  Future<void> fetchRegulerAllContent(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      isLoadingRegulerAll.value = true;

      // Fetch semua data dari API
      final getRegulerDo = await doRegulerRepo.fetchAllRegulerData();

      if (getRegulerDo.isNotEmpty) {
        // Filter data berdasarkan range tanggal
        final filteredData = getRegulerDo.where((item) {
          final itemDate = DateTime.parse(item.tgl);

          if (startDate != null && endDate != null) {
            // Jika ada filter range tanggal, lakukan filterisasi
            return itemDate
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                itemDate.isBefore(endDate.add(const Duration(days: 1)));
          }
          return true;
        }).toList();

        print("Filtered data count: ${filteredData.length}");

        // Check rolePlant and isPengurusPabrik
        print("Role Plant: $rolePlant, Is Pengurus Pabrik: $isAdmin");

        // Filter data berdasarkan role
        final roleFilteredData = !isAdmin
            ? filteredData.where((item) => item.plant == rolePlant).toList()
            : filteredData;

        // Simpan data hasil filterisasi di doRealisasiModelAll
        doRealisasiModelAll.assignAll(roleFilteredData);

        // Tampilkan hanya sebagian data di UI untuk lazy loading
        displayedData
            .assignAll(doRealisasiModelAll.take(initialDataCount).toList());
        print(
            'Initial data loaded with filtering: ${displayedData.length} items');
      } else {
        doRealisasiModelAll.assignAll([]);
      }
    } catch (e) {
      print('Error while fetching data do reguler: $e');
      throw Exception('Gagal mengambil data do reguler');
    } finally {
      isLoadingRegulerAll.value = false;
    }
  }

  void resetFilterDate() {
    startPickDate.value = null; // Clear the selected date
    endPickDate.value = null; // Clear the selected date
    fetchRegulerAllContent(); // Fetch all data without filtering
  }

  // lazy loading func
  void scrollListener() {
    print(
        "Scroll Position: ${scrollController.position.pixels}, Max Scroll: ${scrollController.position.maxScrollExtent}");
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingRegulerAll.value &&
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

  Future<void> editRealisasiReguler(
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

    await doRegulerRepo.editDoReguler(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchRegulerContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editRealisasiAllReguler(
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

    await doRegulerRepo.editDoReguler(
        id, plant, tujuan, type, plant2, tujuan2, kendaraan, supir, jumlahUnit);
    await fetchRegulerAllContent();

    CustomFullScreenLoader.stopLoading();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> tambahJumlahUnit(int id, String user, int jumlahUnit) async {
    CustomDialogs.loadingIndicator();

    await doRegulerRepo.tambahJumlahUnit(id, user, jumlahUnit);
    await fetchRegulerContent();
    await fetchRegulerAllContent();
    await doMutasiController.fetchMutasiContent();
    await doMutasiController.fetchMutasiAllContent();

    CustomFullScreenLoader.stopLoading();
  }

  Future<void> plantGabungan(
    int idReq,
    String plant,
    String tujuan,
    String plant2,
    String tujuan2,
    int type,
    int kendaraan,
    String supir,
    String jam,
    String tgl,
    int bulan,
    int tahun,
    String user,
  ) async {
    CustomDialogs.loadingIndicator();
    await kirimKendaraanRepo.addKirimKendaraan(
      idReq,
      plant,
      tujuan,
      plant2,
      tujuan2,
      type,
      kendaraan,
      supir,
      jam,
      tgl,
      bulan,
      tahun,
      user,
    );

    await fetchRegulerContent();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do realisasi..',
    );
    CustomFullScreenLoader.stopLoading();
  }
}
