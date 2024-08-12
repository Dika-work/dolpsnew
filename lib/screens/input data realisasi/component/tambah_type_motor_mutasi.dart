import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/theme/app_colors.dart';

class TambahTypeMotorMutasi extends StatelessWidget {
  const TambahTypeMotorMutasi({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  Widget build(BuildContext context) {
    final plotRealisasiController = Get.find<PlotRealisasiController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Type Kendaraan',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: CustomSize.md, vertical: CustomSize.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Plant'),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(text: model.plant),
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CustomSize.spaceBtwItems),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tujuan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    controller: TextEditingController(text: model.tujuan),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Type'),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(
                          text: model.type == 0 ? 'REGULER' : 'MUTASI'),
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CustomSize.spaceBtwItems),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No Kendaraan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    controller: TextEditingController(text: model.noPolisi),
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jenis'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: model.jenisKen),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: model.supir),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Unit Motor'),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      controller: TextEditingController(
                          text: model.jumlahUnit.toString()),
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.buttonDisabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CustomSize.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Plot'),
                    Obx(
                      () => TextFormField(
                        controller: TextEditingController(
                            text: plotRealisasiController
                                    .plotModelRealisasi.isNotEmpty
                                ? plotRealisasiController
                                    .plotModelRealisasi.first.jumlahPlot
                                    .toString()
                                : ''),
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: const InputDecoration(
                            filled: true, fillColor: AppColors.buttonDisabled),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
          // table mutasi nya
          // Obx()
        ],
      ),
    );
  }
}
