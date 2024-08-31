import 'package:doplsnew/helpers/helper_function.dart';
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

  late int kelengkapanHLM;
  late int kelengkapanAC;
  late int kelengkapanKS;
  late int kelengkapanTS;
  late int kelengkapanBP;
  late int kelengkapanBS;
  late int kelengkapanPLT;
  late int kelengkapanSTAY;
  late int kelengkapanAcBesar;
  late int kelengkapanPlastik;

  final controller = Get.put(AksesorisController());

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

    if (controller.aksesorisModel.isNotEmpty) {
      kelengkapanHLM = controller.aksesorisModel.first.accHLM;
      kelengkapanAC = controller.aksesorisModel.first.accAC;
      kelengkapanKS = controller.aksesorisModel.first.accKS;
      kelengkapanTS = controller.aksesorisModel.first.accTS;
      kelengkapanBP = controller.aksesorisModel.first.accBP;
      kelengkapanBS = controller.aksesorisModel.first.accBS;
      kelengkapanPLT = controller.aksesorisModel.first.accPLT;
      kelengkapanSTAY = controller.aksesorisModel.first.accSTAY;
      kelengkapanAcBesar = controller.aksesorisModel.first.accAcBesar;
      kelengkapanPlastik = controller.aksesorisModel.first.accPlastik;
    } else {
      // Handle the case when aksesorisModel is empty, e.g., set default values or show a message
      kelengkapanHLM = 0; // Or any default value you prefer
      kelengkapanAC = 0;
      kelengkapanKS = 0;
      kelengkapanTS = 0;
      kelengkapanBP = 0;
      kelengkapanBS = 0;
      kelengkapanPLT = 0;
      kelengkapanSTAY = 0;
      kelengkapanAcBesar = 0;
      kelengkapanPlastik = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAksesoris(id);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            _buildKelengkapanAlaT('HLM', kelengkapanHLM, 0),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('AC', kelengkapanAC, 1),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('KS', kelengkapanKS, 2),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('TS', kelengkapanTS, 3),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('BP', kelengkapanBP, 4),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('BS', kelengkapanBS, 5),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('PLT', kelengkapanPLT, 6),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('Stay L/R', kelengkapanSTAY, 7),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('AC Besar', kelengkapanAcBesar, 8),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildKelengkapanAlaT('Plastik', kelengkapanPlastik, 9),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('HUTANG PABRIK',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('HLM', 'BP', 0, 4),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('AC', 'BS', 1, 5),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('KS', 'PLT', 2, 6),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('TS', 'Stay\nL/R', 3, 7),
            const SizedBox(height: CustomSize.spaceBtwItems),
            _buildHutangPabrik('AC\nBesar', 'Plastik', 8, 9),
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
                        print('..INI MERUBAH STATUS JADI 4 TYPE MOTOR...');
                        print('id: $id');
                        print('user: ${controller.aksesorisModel.first.user}');
                        print('jam: ${controller.aksesorisModel.first.jam}');
                        print(
                            'tanggal: ${CustomHelperFunctions.getFormattedDateDatabase(DateTime.now())}');
                        print('ini hlm acc: ${controller.newValues[0]}');
                        print('ini ac acc: ${controller.newValues[1]}');
                        print('ini ks acc: ${controller.newValues[2]}');
                        print('ini ts acc: ${controller.newValues[3]}');
                        print('ini bp acc: ${controller.newValues[4]}');
                        print('ini bs acc: ${controller.newValues[5]}');
                        print('ini plt acc: ${controller.newValues[6]}');
                        print('ini stay acc: ${controller.newValues[7]}');
                        print('ini acBesar acc: ${controller.newValues[8]}');
                        print('ini plastik acc: ${controller.newValues[9]}');
                        print('..INI BAGIAN HUTANG PABRIK..');
                        print('ini hutangHlm: ${controller.hutangValues[0]}');
                        print('ini hutangAc: ${controller.hutangValues[1]}');
                        print('ini hutangKs: ${controller.hutangValues[2]}');
                        print('ini hutangTs: ${controller.hutangValues[3]}');
                        print('ini hutangBp: ${controller.hutangValues[4]}');
                        print('ini hutangBs: ${controller.hutangValues[5]}');
                        print('ini hutangPlt: ${controller.hutangValues[6]}');
                        print('ini hutangStay: ${controller.hutangValues[7]}');
                        print(
                            'ini hutangAcBesar: ${controller.hutangValues[8]}');
                        print(
                            'ini hutangPlastik: ${controller.hutangValues[9]}');
                        print('..SELESAII..');
                        controller.accSelesai(
                          id,
                          controller.aksesorisModel.first.user,
                          CustomHelperFunctions.formattedTime,
                          CustomHelperFunctions.getFormattedDateDatabase(
                              DateTime.now()),
                          controller.newValues[0],
                          controller.newValues[1],
                          controller.newValues[2],
                          controller.newValues[3],
                          controller.newValues[4],
                          controller.newValues[5],
                          controller.newValues[6],
                          controller.newValues[7],
                          controller.newValues[8],
                          controller.newValues[9],
                          controller.hutangValues[0],
                          controller.hutangValues[1],
                          controller.hutangValues[2],
                          controller.hutangValues[3],
                          controller.hutangValues[4],
                          controller.hutangValues[5],
                          controller.hutangValues[6],
                          controller.hutangValues[7],
                          controller.hutangValues[8],
                          controller.hutangValues[9],
                        );
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
          child: Obx(() {
            return TextFormField(
              keyboardType: TextInputType.number,
              readOnly: !controller.checkboxStatus[index],
              controller: controller.controllers[index],
              decoration: controller.checkboxStatus[index]
                  ? null
                  : const InputDecoration(
                      filled: true, fillColor: AppColors.buttonDisabled),
            );
          }),
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() {
            return Checkbox(
              value: controller.checkboxStatus[index],
              onChanged: (value) {
                controller.checkboxStatus[index] = value!;
                if (!value) {
                  controller.newValues[index] = valueTextForm;
                  controller.updateHutangValues();
                } else {
                  controller.controllers[index].text =
                      controller.newValues[index].toString();
                }
              },
            );
          }),
        ),
      ],
    );
  }

  _buildHutangPabrik(String label1, String label2, int index1, int index2) {
    final controller = Get.find<AksesorisController>();

    return Obx(() {
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
              controller: TextEditingController(
                  text: controller.hutangValues[index1].toString()),
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
              controller: TextEditingController(
                  text: controller.hutangValues[index2].toString()),
              decoration: const InputDecoration(
                  filled: true, fillColor: AppColors.buttonDisabled),
            ),
          ),
        ],
      );
    });
  }
}
