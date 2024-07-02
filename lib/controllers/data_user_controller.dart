import 'package:doplsnew/models/data_user_model.dart';
import 'package:doplsnew/repository/data_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataUserController extends GetxController {
  RxList<DataUserModel> dataUserModel = <DataUserModel>[].obs;
  GlobalKey<FormState> addUserKey = GlobalKey<FormState>();

  final isDataUserLoading = Rx<bool>(false);
  final hidePassword = true.obs;
  final dataUserRepo = Get.put(DataUserRepository());

  // textEditingController
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();
  final tipeController = TextEditingController();
  final appController = TextEditingController();
  final lihat = '0'.obs;
  final print = '0'.obs;
  final tambah = '0'.obs;
  final edit = '0'.obs;
  final hapus = '0'.obs;
  final jumlah = '0'.obs;
  final kirim = '0'.obs;
  final batal = '0'.obs;
  final cekUnit = '0'.obs;
  final wilayahController = TextEditingController();
  final plantController = TextEditingController();
  final cekReguler = '0'.obs;
  final cekMutasi = '0'.obs;
  final acc1 = '0'.obs;
  final acc2 = '0'.obs;
  final acc3 = '0'.obs;
  final menu1 = '0'.obs;
  final menu2 = '0'.obs;
  final menu3 = '0'.obs;
  final menu4 = '0'.obs;
  final menu5 = '0'.obs;
  final menu6 = '0'.obs;
  final menu7 = '0'.obs;
  final menu8 = '0'.obs;
  final menu9 = '0'.obs;
  final menu10 = '0'.obs;
  final gambarController = TextEditingController();
  final online = '0'.obs;

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  Future<void> fetchUserData() async {
    try {
      isDataUserLoading.value = true;
      final dataUser = await dataUserRepo.fetchDataUserContent();
      dataUserModel.assignAll(dataUser);
    } catch (e) {
      print('ini error nya ya : $e');
      dataUserModel.assignAll([]);
    } finally {
      isDataUserLoading.value = false;
    }
  }
}
