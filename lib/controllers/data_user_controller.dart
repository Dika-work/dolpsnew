import 'package:doplsnew/models/data_user_model.dart';
import 'package:doplsnew/repository/data_user_repo.dart';
import 'package:get/get.dart';

class DataUserController extends GetxController {
  RxList<DataUserModel> dataUserModel = <DataUserModel>[].obs;

  final isDataUserLoading = Rx<bool>(false);
  final dataUserRepo = Get.put(DataUserRepository());

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
      dataUserModel.assignAll([]);
    } finally {
      isDataUserLoading.value = false;
    }
  }
}
