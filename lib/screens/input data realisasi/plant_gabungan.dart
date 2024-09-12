import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../controllers/input data realisasi/do_reguler_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/do_realisasi_model.dart';
import '../../models/user_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class PlantGabungan extends StatefulWidget {
  const PlantGabungan({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<PlantGabungan> createState() => _PlantGabunganState();
}

class _PlantGabunganState extends State<PlantGabungan> {
  final storageUtil = StorageUtil();
  final controller = Get.put(DoRegulerController());

  late int idReq;
  late DateTime parsedDate;
  late String tgl;
  late int bulan;
  late int tahun;
  late String plant;
  late String tujuan;
  late int type;
  late String jenisKendaraan;
  late String noKendaraaan;
  late String supir;

  String roleUser = '';

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  // Logika untuk mengganti nilai plant secara otomatis
  String adjustPlant(String plant) {
    if (plant == '1300') {
      return '1350';
    } else if (plant == '1350') {
      return '1300';
    } else if (plant == '1700') {
      return '1800';
    } else if (plant == '1800') {
      return '1700';
    } else {
      return plant;
    }
  }

  @override
  void initState() {
    super.initState();
    UserModel? user = storageUtil.getUserDetails();

    if (user != null) {
      roleUser = user.tipe;
    }

    plant = adjustPlant(widget.model.plant);
    tujuan = widget.model.tujuan;
    idReq = widget.model.idReq;
    parsedDate = DateFormat('yyyy-MM-dd').parse(widget.model.tgl);
    tgl = CustomHelperFunctions.getFormattedDateDatabase(parsedDate);
    bulan = parsedDate.month;
    tahun = parsedDate.year;
    type = widget.model.type;
    jenisKendaraan = widget.model.jenisKen;
    noKendaraaan = widget.model.kendaraan;
    supir = widget.model.supir;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Gabungan',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: CustomSize.md,
            right: CustomSize.md,
            top: CustomSize.sm,
            bottom: CustomSize.lg),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Plant'),
                  roleUser == 'admin'
                      ? DropDownWidget(
                          value: plant,
                          items: tujuanMap.keys.toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                plant = value;
                                tujuan = tujuanMap[value]!;
                              });
                            }
                          },
                        )
                      : TextFormField(
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.truck_fast),
                              hintText:
                                  plant, // Gunakan plant yang telah disesuaikan
                              filled: true,
                              fillColor: AppColors.buttonDisabled),
                        ),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  const Text('Tujuan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.truck_fast),
                        hintText: tujuan, // Tampilkan tujuan yang sudah di-set
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
                  const Text('Jenis Kendaraan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.truck_fast),
                        hintText: jenisKendaraan,
                        filled: true,
                        fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  const Text('No Kendaraan'),
                  TextFormField(
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.truck_fast),
                        hintText: noKendaraaan,
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
                ],
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwSections),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(CustomSize.md),
                        backgroundColor: AppColors.yellow),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(color: AppColors.black),
                    )),
                ElevatedButton(
                    onPressed: () {
                      controller.plantGabungan(
                          idReq,
                          plant,
                          tujuan,
                          '',
                          '',
                          type,
                          int.parse(noKendaraaan),
                          supir,
                          CustomHelperFunctions.formattedTime,
                          tgl,
                          bulan,
                          tahun,
                          roleUser);
                      // print('--PLANT GABUNGAN--');
                      // print('id: $idReq');
                      // print('plant: $plant');
                      // print('tujuan: $tujuan');
                      // print('tipe: $type');
                      // print('No polisi: ${int.parse(noKendaraaan)}');
                      // print('Supir: $supir');
                      // print('jam: ${CustomHelperFunctions.formattedTime}');
                      // print('tgl: $tgl');
                      // print('bulan: $bulan');
                      // print('tahun: $tahun');
                      // print('user yang input: $roleUser');
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(CustomSize.md)),
                    child: const Text('Simpan Data')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
