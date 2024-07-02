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
  final cekRegulerController = TextEditingController();
  final cekMutasiController = TextEditingController();
  final acc1Controller = TextEditingController();
  final acc2Controller = TextEditingController();
  final acc3Controller = TextEditingController();
  final menu1Controller = TextEditingController();
  final menu2Controller = TextEditingController();
  final menu3Controller = TextEditingController();
  final menu4Controller = TextEditingController();
  final menu5Controller = TextEditingController();
  final menu6Controller = TextEditingController();
  final menu7Controller = TextEditingController();
  final menu8Controller = TextEditingController();
  final menu9Controller = TextEditingController();
  final menu10Controller = TextEditingController();
  final gambarController = TextEditingController();
  final onlineController = TextEditingController();

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  Future<void> fetchUserData() async {
    try {
      isDataUserLoading.value = true;
      final dataUser = await dataUserRepo.fetchDataUserContent();
      print('ini data usernya ' + dataUserModel.toString());
      dataUserModel.assignAll(dataUser);
    } catch (e) {
      print('ini error nya ya : $e');
      dataUserModel.assignAll([]);
    } finally {
      isDataUserLoading.value = false;
    }
  }
}
