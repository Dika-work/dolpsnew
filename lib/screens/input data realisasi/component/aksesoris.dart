import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/input data realisasi/aksesoris_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../utils/theme/app_colors.dart';

class Aksesoris extends StatefulWidget {
  const Aksesoris({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<Aksesoris> createState() => _AksesorisState();
}

class _AksesorisState extends State<Aksesoris> {
  late int id;
  late String tujuan;
  late String plant;
  late int type;
  late String jenis;
  late String noPolisi;
  late String supir;
  late int jumlahUnit;

  @override
  void initState() {
    super.initState();
    id = widget.model.id;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type;
    jenis = widget.model.jenisKen;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    jumlahUnit = widget.model.jumlahUnit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AksesorisController>().fetchAksesoris(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AksesorisController());

    return AlertDialog(
      title: Center(
          child: Text('Tambah Aksesoris',
              style: Theme.of(context).textTheme.headlineMedium)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlignedText('Tujuan', tujuan),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('Plant', plant),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('Type', type == 0 ? 'REGULER' : 'MUTASI'),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('Jenis', jenis),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('No Polisi', noPolisi),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('Supir', supir),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildAlignedText('Jumlah Unit', jumlahUnit.toString()),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('KELENGKAPAN ALAT-ALAT',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.success)),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Obx(() {
              if (controller.isLoadingAksesoris.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.aksesorisModel.isEmpty) {
                return const Text('Data tidak tersedia');
              }
              final aksesoris = controller.aksesorisModel.first;

              // Initialize checkValues list if not already initialized
              if (controller.checkboxStatus.isEmpty) {
                controller.checkboxStatus = RxList.filled(10, false);
              }

              return Column(
                children: [
                  _buildKelengkapanAlaT('HLM', aksesoris.accHLM, 0),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('AC', aksesoris.accAC, 1),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('KS', aksesoris.accKS, 2),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('TS', aksesoris.accTS, 3),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('BP', aksesoris.accBP, 4),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('BS', aksesoris.accBS, 5),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('PLT', aksesoris.accPLT, 6),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('Stay L/R', aksesoris.accSTAY, 7),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('AC Besar', aksesoris.accAcBesar, 8),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  _buildKelengkapanAlaT('Plastik', aksesoris.accPlastik, 9),
                ],
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('HUTANG PABRIK',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('HLM', 'BP', 0, 0),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('AC', 'BS', 0, 0),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('KS', 'PLT', 0, 0),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('TS', 'Stay\nL/R', 0, 0),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('AC\nBesar', 'Plastik', 0, 0),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // Kembali ke layar sebelumnya
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 25.0),
                backgroundColor: AppColors.yellow,
              ),
              child: Text(
                'Kembali',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.apply(color: AppColors.black),
              ),
            ),
            Obx(() {
              return controller.areAllCheckboxesChecked
                  ? ElevatedButton(
                      onPressed: () {
                        print(
                            '...INI BAKALAN KE CLASS NAME SELESAI AKSESORIS...');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 25.0),
                      ),
                      child: Text(
                        'Simpan Data',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.apply(color: AppColors.white),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        )
      ],
    );
  }

  _buildAlignedText(String label, String valueTextForm) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            )),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: valueTextForm),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
        ),
      ],
    );
  }

  _buildKelengkapanAlaT(String label, int valueTextForm, int index) {
    final controller = Get.find<AksesorisController>();

    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            )),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.number,
            readOnly: !controller.checkboxStatus[index],
            controller: TextEditingController(text: valueTextForm.toString()),
            decoration: controller.checkboxStatus[index]
                ? null
                : const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
          ),
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() {
            return Checkbox(
              value: controller.checkboxStatus[index],
              onChanged: (value) {
                controller.checkboxStatus[index] = value!;
              },
            );
          }),
        ),
      ],
    );
  }

  _buildHutangPabrik(
      String label1, String label2, int valueTextForm1, int valueTextForm2) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              label1,
              style: Theme.of(context).textTheme.labelMedium,
            )),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: valueTextForm1.toString()),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
        ),
        const SizedBox(width: CustomSize.sm),
        Expanded(
            flex: 1,
            child: Text(
              label2,
              style: Theme.of(context).textTheme.labelMedium,
            )),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.none,
            readOnly: true,
            controller: TextEditingController(text: valueTextForm2.toString()),
            decoration: const InputDecoration(
                filled: true, fillColor: AppColors.buttonDisabled),
          ),
        ),
      ],
    );
  }
}
