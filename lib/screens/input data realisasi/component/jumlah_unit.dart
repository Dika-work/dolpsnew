import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/theme/app_colors.dart';

class JumlahUnit extends StatefulWidget {
  const JumlahUnit({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<JumlahUnit> createState() => _JumlahUnitState();
}

class _JumlahUnitState extends State<JumlahUnit> {
  late int idReq;
  late String tujuan;
  late String plant;
  late int type;
  late String jenisKen;
  late String noPolisi;
  late String supir;
  late TextEditingController jumlahUnit;

  @override
  void initState() {
    super.initState();
    idReq = widget.model.idReq;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type;
    jenisKen = widget.model.jenisKen;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    jumlahUnit =
        TextEditingController(text: widget.model.jumlahUnit.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ini idReq nya : $idReq'),
          const Text('Tujuan'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: tujuan,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Plant'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: plant,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Type'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: type == 0 ? 'REGULER' : 'MUTASI',
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jenis'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: jenisKen,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('No Polisi'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.truck_fast),
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
                prefixIcon: const Icon(Iconsax.truck_fast),
                hintText: supir,
                filled: true,
                fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          TextFormField(
            controller: jumlahUnit,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah motor tidak boleh kosong';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Jumlah Unit',
            ),
          ),
        ],
      ),
    );
  }
}
