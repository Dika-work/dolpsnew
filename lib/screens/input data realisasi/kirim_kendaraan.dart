import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../widgets/dropdown.dart';

class KirimKendaraanScreen extends StatefulWidget {
  const KirimKendaraanScreen(
      {super.key, required this.controller, required this.model});

  final RequestKendaraanController controller;
  final RequestKendaraanModel model;

  @override
  State<KirimKendaraanScreen> createState() => _KirimKendaraanScreenState();
}

class _KirimKendaraanScreenState extends State<KirimKendaraanScreen> {
  late int idReq;
  late String pengurus;
  late String tgl;
  late String jam;
  late String plant;
  late String tujuan;
  late int type;
  late String jenis;
  late int jumlah;
  late int statusReq;
  late String inisialDepan;
  late String inisialBelakang;

  @override
  void initState() {
    super.initState();
    idReq = widget.model.idReq;
    pengurus = widget.model.pengurus;
    tgl = widget.model.tgl;
    jam = widget.model.jam;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    type = widget.model.type;
    jenis = widget.model.jenis;
    jumlah = widget.model.jumlah;
    statusReq = widget.model.statusReq;
    inisialDepan = widget.model.inisialDepan;
    inisialBelakang = widget.model.inisitalBelakang;
  }

  @override
  Widget build(BuildContext context) {
    final sopirController = Get.put(FetchSopirController());
    return Form(
      key: widget.controller.kirimKendaraanKey,
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
                hintText: widget.controller.plant.value,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.controller.tujuanDisplayValue,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type DO'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.controller.typeDO.toString(),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tanggal Request'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.controller.tgl.value,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Jenis Kendaraan',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Jumlah Kendaraan',
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
            const Text('Jenis Kendaraan'),
            Obx(
              () => DropDownWidget(
                value: widget.controller.jenisKendaraan.value,
                items: widget.controller.jenisKendaraanList,
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  widget.controller.jenisKendaraan.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('No Polisi'),
            Obx(
              () => DropDownWidget(
                value: widget.controller.jenisKendaraan.value,
                items: widget.controller.jenisKendaraanList,
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  widget.controller.jenisKendaraan.value = value!;
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Sopir'),
            Obx(
              () => DropDownWidget(
                value: sopirController.sopirModel.isNotEmpty
                    ? '${sopirController.sopirModel.first.nama} - (${sopirController.sopirModel.first.namaPanggilan})'
                    : null,
                items: widget.controller.jenisKendaraanList,
                onChanged: (String? value) {
                  print('Selected plant: $value');
                  sopirController.selectedSopir.value = value!;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
