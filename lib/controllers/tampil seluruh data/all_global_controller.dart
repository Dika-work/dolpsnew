import 'package:connectivity_plus/connectivity_plus.dart';
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
  RxList<DoGlobalAllModel> doAllGlobalModel = <DoGlobalAllModel>[].obs;
  final dataGlobalAllRepo = Get.put(GlobalAllRepository());
  final storageUtil = StorageUtil();

  final isConnected = Rx<bool>(true);
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
        if (!isConnected.value) {
          isConnected.value = true;
          fetchAllGlobalData(); // Otomatis fetch data ketika koneksi kembali
        }
      }
    });

    fetchAllGlobalData();
    super.onInit();
  }

  Future<void> fetchAllGlobalData({DateTime? pickDate}) async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalAllRepo.fetchGlobalHarianContent();

      if (pickDate != null) {
        doAllGlobalModel.assignAll(dataHarian.where((data) {
          final dataDate = DateTime.parse(data.tgl);
          // Compare if the day, month, and year of both dates are the same
          return dataDate.year == pickDate.year &&
              dataDate.month == pickDate.month &&
              dataDate.day == pickDate.day;
        }).toList());
      } else {
        doAllGlobalModel.assignAll(dataHarian);
      }
    } catch (e) {
      print('Error fetching data do harian: $e');
      doAllGlobalModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void resetFilterDate() {
    pickDate.value = null; // Clear the selected date
    fetchAllGlobalData(); // Fetch all data without filtering
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

  Future<void> hapusDOGlobal(
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
    await dataGlobalAllRepo.deleteDOGlobalContent(id);

    await fetchAllGlobalData();
    CustomFullScreenLoader.stopLoading();
  }
}
