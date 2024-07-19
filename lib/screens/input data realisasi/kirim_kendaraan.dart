import 'package:doplsnew/controllers/input%20data%20realisasi/fetch_kendaraan_controller.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../widgets/dropdown.dart';

class KirimKendaraanScreen extends StatelessWidget {
  const KirimKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
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

    // Set default value for jenisKendaraan in the controller
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
