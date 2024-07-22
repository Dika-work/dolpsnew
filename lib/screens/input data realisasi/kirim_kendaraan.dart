import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/input data realisasi/fetch_kendaraan_controller.dart';
import '../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../controllers/input data realisasi/kirim_kendaraan_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../widgets/dropdown.dart';

class KirimKendaraanScreen extends StatelessWidget {
  const KirimKendaraanScreen(this.model, {super.key});

  final RequestKendaraanModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KirimKendaraanController());
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': double.nan,
      'Type': 130,
      'Kendaraan': 150,
      'Jenis': double.nan,
      'Status': double.nan,
      'LV Kerusakan': double.nan,
      'Supir': double.nan,
      'Hapus': 50,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah data plant kendaraan honda',
          maxLines: 2,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(model.pengurus),
            Text(model.tgl),
            Text(model.jam),
            Text(model.plant),
            Text(model.tujuan),
            Text(model.type == 0 ? 'REGULER' : 'MUTASI'),
            Text(model.jenis),
            Text(model.jumlah.toString()),
          ],
        ),
      ),
      // body: Obx(
      //   () {
      //     if (controller.isLoadingKendaraan.value &&
      //         controller.kirimKendaraanModel.isEmpty) {
      //       return const CustomCircularLoader();
      //     } else if (controller.kirimKendaraanModel.isEmpty) {
      //       return GestureDetector(
      //         onTap: () {},
      //         child: CustomAnimationLoaderWidget(
      //           text: 'Tambahkan Data Baru',
      //           animation: 'assets/animations/add-data-animation.json',
      //           height: CustomHelperFunctions.screenHeight() * 0.4,
      //           width: CustomHelperFunctions.screenHeight(),
      //         ),
      //       );
      //     } else
      //   },
      // ),
    );
  }
}

class AddKirimKendaraan extends StatefulWidget {
  const AddKirimKendaraan({super.key, required this.model});

  final RequestKendaraanModel model;

  @override
  State<AddKirimKendaraan> createState() => _AddKirimKendaraanState();
}

class _AddKirimKendaraanState extends State<AddKirimKendaraan> {
  GlobalKey<FormState> kirimKendaraanKey = GlobalKey<FormState>();

  late String tgl;
  late String plant;
  late String tujuan;
  late int typeDO;
  late String jenisKendaraan;
  late int jumlahKendaraan;

  @override
  void initState() {
    super.initState();
    tgl = CustomHelperFunctions.getFormattedDate(
        DateFormat('yyyy-MM-dd').parse(widget.model.tgl));
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    typeDO = widget.model.type;
    jenisKendaraan = widget.model.jenis;
    jumlahKendaraan = widget.model.jumlah;

    // Set default value for jenisKendaraan di controller
    final fetchKendaraanController = Get.put(FetchKendaraanController());
    fetchKendaraanController.setSelectedJenisKendaraan(jenisKendaraan);
  }

  @override
  Widget build(BuildContext context) {
    final fetchKendaraanController = Get.put(FetchKendaraanController());
    final sopirController = Get.put(FetchSopirController());

    return Form(
      key: kirimKendaraanKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Plant'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: plant,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: tujuan,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type DO'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: typeDO == 0 ? 'REGULER' : 'MUTASI',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tanggal Request'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: tgl,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis Kendaraan'),
            Obx(() {
              return DropDownWidget(
                value: fetchKendaraanController.selectedJenisKendaraan.value,
                items: [
                  jenisKendaraan
                ], // Hanya menampilkan nilai dari initState
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    fetchKendaraanController
                        .setSelectedJenisKendaraan(newValue);
                  }
                },
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: InputDecoration(
                hintText: jumlahKendaraan.toString(),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plot Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Plot Kendaraan',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('No Polisi'),
            Obx(() {
              return DropDownWidget(
                value: fetchKendaraanController.selectedKendaraan.value.isEmpty
                    ? null
                    : fetchKendaraanController.selectedKendaraan.value,
                items: fetchKendaraanController.filteredKendaraanModel
                    .map((kendaraan) => kendaraan.noPolisi)
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    fetchKendaraanController.selectedKendaraan.value = newValue;
                  }
                },
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Sopir'),
            Obx(
              () => DropDownWidget(
                value: sopirController.sopirModel.isNotEmpty
                    ? '${sopirController.sopirModel.first.nama} - (${sopirController.sopirModel.first.namaPanggilan})'
                    : null,
                items: sopirController.sopirModel
                    .map((sopir) => '${sopir.nama} - (${sopir.namaPanggilan})')
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    sopirController.selectedSopir.value = value;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
