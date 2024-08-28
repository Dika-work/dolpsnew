import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helper_function.dart';
import '../../models/tampil seluruh data/do_estimasi_all.dart';
import '../../models/user_model.dart';
import '../../repository/tampil seluruh data/estimasi_all_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/snackbar.dart';

class AllEstimasiController extends GetxController {
  final isEstimasiLoading = Rx<bool>(false);
  RxList<DoEstimasiAllModel> doAllEstimasiModel = <DoEstimasiAllModel>[].obs;
  final estimasiRepo = Get.put(EstimasiAllRepository());
  GlobalKey<FormState> allEstimasiKey = GlobalKey<FormState>();

  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final srdController = TextEditingController();
  final mksController = TextEditingController();
  final ptkController = TextEditingController();
  final storageUtil = StorageUtil();
  String namaUser = '';

  @override
  void onInit() {
    super.onInit();
    fetchAllEstimasi();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      namaUser = user.nama;
    }
  }

  Future<void> fetchAllEstimasi() async {
    try {
      isEstimasiLoading.value = true;
      final dataEstimasi = await estimasiRepo.fetchEstimasiContent();
      doAllEstimasiModel.assignAll(dataEstimasi);
    } catch (e) {
      print('Error while fetching data all do estimasi: $e');
      doAllEstimasiModel.assignAll([]);
    } finally {
      isEstimasiLoading.value = false;
    }
  }

  Future<void> addDataEstimasi() async {
    CustomDialogs.loadingIndicator();

    if (!allEstimasiKey.currentState!.validate()) {
      CustomFullScreenLoader.stopLoading();
      return;
    }

    bool isDuplicate = doAllEstimasiModel.any((data) => data.tgl == tgl.value);

    if (isDuplicate) {
      CustomFullScreenLoader.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Gagal😢',
          message: 'Maaf tanggal sudah di masukkan sebelumnya');
      return;
    }

    await estimasiRepo.addEstimasi(
        tgl.value,
        CustomHelperFunctions.formattedTime,
        int.parse(srdController.text),
        int.parse(mksController.text),
        int.parse(ptkController.text),
        namaUser);

    srdController.clear();
    mksController.clear();
    ptkController.clear();

    await fetchAllEstimasi();
    CustomFullScreenLoader.stopLoading();

    SnackbarLoader.successSnackBar(
      title: 'Berhasil✨',
      message: 'Menambahkan data do estimasi baru..',
    );
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> editEstimasi(
    int id,
    String tgl,
    int srd,
    int mks,
    int ptk,
  ) async {
    CustomDialogs.loadingIndicator();
    await estimasiRepo.editEstimasi(id, tgl, srd, mks, ptk);
    CustomFullScreenLoader.stopLoading();

    await fetchAllEstimasi();
    CustomFullScreenLoader.stopLoading();
  }

  Future<void> hapusEstimasi(int id) async {
    CustomDialogs.loadingIndicator();

    await estimasiRepo.deleteEstimasi(id);
    await fetchAllEstimasi();
    CustomFullScreenLoader.stopLoading();
  }
}
