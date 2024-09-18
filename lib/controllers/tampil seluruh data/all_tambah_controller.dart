import 'package:get/get.dart';

import '../../models/tampil seluruh data/do_tambah_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/tambah_all_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';

class DataAllTambahController extends GetxController {
  final isLoadingGlobalHarian = Rx<bool>(false);
  RxList<DoTambahAllModel> doGlobalHarianModel = <DoTambahAllModel>[].obs;
  final dataGlobalHarianRepo = Get.put(TambahAllRepository());
  final storageUtil = StorageUtil();

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
    fetchDataDoGlobal();
    super.onInit();
  }

  Future<void> fetchDataDoGlobal({DateTime? pickDate}) async {
    try {
      isLoadingGlobalHarian.value = true;
      final dataHarian = await dataGlobalHarianRepo.fetchGlobalHarianContent();

      if (pickDate != null) {
        doGlobalHarianModel.assignAll(dataHarian.where(
          (data) {
            final dataDate = DateTime.parse(data.tgl);

            return dataDate.year == pickDate.year &&
                dataDate.month == pickDate.month &&
                dataDate.day == pickDate.day;
          },
        ));
      } else {
        doGlobalHarianModel.assignAll(dataHarian);
      }
    } catch (e) {
      print('Error fetching data do harian : $e');
      doGlobalHarianModel.assignAll([]);
    } finally {
      isLoadingGlobalHarian.value = false;
    }
  }

  void resetFilterDate() {
    pickDate.value = null; // Clear the selected date
    fetchDataDoGlobal(); // Fetch all data without filtering
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
    await dataGlobalHarianRepo.deleteDOTambahContent(id);

    await fetchDataDoGlobal();
    CustomFullScreenLoader.stopLoading();
  }
}
