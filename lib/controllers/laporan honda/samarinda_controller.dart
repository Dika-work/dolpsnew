import 'package:get/get.dart';

import '../../models/laporan honda/samarinda_model.dart';

class SamarindaController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<SamarindaModel> samarindaModel = <SamarindaModel>[].obs;
}
