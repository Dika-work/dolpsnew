import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/theme/app_colors.dart';

class BatalJalan extends StatefulWidget {
  const BatalJalan({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<BatalJalan> createState() => _BatalJalanState();
}

class _BatalJalanState extends State<BatalJalan> {
  late int id;
  late String tujuan;
  late String plant;
  late int type;
  late String noPolisi;
  late String supir;
  late TextEditingController alasan;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text('Pembatalan Realisasi DO',
              style: Theme.of(context).textTheme.headlineMedium)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: tujuan,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: type == 0 ? 'REGULER' : 'MUTASI',
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('No Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: noPolisi,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Supir'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: supir,
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Alasan Pembatalan'),
            TextFormField(
              controller: alasan,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap mengisi Alasan Pembatalan!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () => print('..INI EVENT PEMBATALAN REALISASI DO'),
          // onPressed: () => controller.tambahJumlahUnit(
          //     id, controller.namaUser, int.parse(jumlahUnit.text)),
          child: const Text('Simpan Data'),
        ),
      ],
    );
  }
}
