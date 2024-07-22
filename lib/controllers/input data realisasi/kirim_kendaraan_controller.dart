import 'package:doplsnew/models/input%20data%20realisasi/kirim_kendaraan_model.dart';
import 'package:get/get.dart';

class KirimKendaraanController extends GetxController {
  final isLoadingKendaraan = Rx<bool>(false);
  RxList<KirimKendaraanModel> kirimKendaraanModel = <KirimKendaraanModel>[].obs;
}
