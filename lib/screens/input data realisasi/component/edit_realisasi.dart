import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/input data realisasi/fetch_kendaraan_controller.dart';
import '../../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../models/input data realisasi/kendaraan_model.dart';
import '../../../models/input data realisasi/sopir_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dropdown.dart';

class EditRealisasi extends StatefulWidget {
  const EditRealisasi({super.key, required this.model});

  final DoRealisasiModel model;

  @override
  State<EditRealisasi> createState() => _EditRealisasiState();
}

class _EditRealisasiState extends State<EditRealisasi> {
  late int idReq;
  late String tujuan;
  late String plant;
  late String type;
  // late String jenisKen;
  late String noPolisi;
  late String supir;
  late int jumlahUnit;

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter',
    '1200': 'Pegangsaan',
    '1300': 'Cibitung',
    '1350': 'Cibitung',
    '1700': 'Dawuan',
    '1800': 'Dawuan',
    'DC (Pondok Ungu)': 'Bekasi',
    'TB (Tambun Bekasi)': 'Bekasi',
    '1900': 'Bekasi',
  };

  // final List<String> jenisKendaraanList = [
  //   'MOBIL MOTOR 16',
  //   'MOBIL MOTOR 40',
  //   'MOBIL MOTOR 64',
  //   'MOBIL MOTOR 86',
  // ];

  final Map<String, int> typeDOMap = {
    'REGULER': 0,
    'MUTASI': 1,
  };

  String get tujuanDisplayValue => tujuanMap[plant] ?? '';

  @override
  void initState() {
    super.initState();
    idReq = widget.model.idReq;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
    // jenisKen = widget.model.jenisKen;
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    jumlahUnit = widget.model.jumlahUnit;

    final fetchKendaraanController = Get.put(FetchKendaraanController());
    final sopirController = Get.put(FetchSopirController());

    fetchKendaraanController.selectedKendaraan.value = noPolisi;
    sopirController.selectedSopirDisplay.value = supir;
    print(
        'ini value awal dari supir : ${sopirController.selectedSopirDisplay.value}');
  }

  @override
  Widget build(BuildContext context) {
    final fetchKendaraanController = Get.find<FetchKendaraanController>();
    final sopirController = Get.find<FetchSopirController>();

    final TextEditingController jumlahController =
        TextEditingController(text: widget.model.status.toString());

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plant'),
          DropDownWidget(
            value: plant,
            items: tujuanMap.keys.toList(),
            onChanged: (String? value) {
              setState(() {
                plant = value!;
                tujuan = tujuanMap[value]!;
                print('ini plant yang telah di pilih : $plant');
              });
            },
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
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
          const Text('Type'),
          DropDownWidget(
            value: type,
            items: typeDOMap.keys.toList(),
            onChanged: (String? value) {
              setState(() {
                type = value!;
                print('ini type yang telah di pilih : $type');
              });
            },
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('No Polisi'),
          Obx(() {
            return DropdownSearch<KendaraanModel>(
              items: fetchKendaraanController.filteredKendaraanModel,
              itemAsString: (KendaraanModel kendaraan) => kendaraan.noPolisi,
              selectedItem: fetchKendaraanController.filteredKendaraanModel
                  .firstWhere(
                      (kendaraan) =>
                          kendaraan.noPolisi ==
                          fetchKendaraanController.selectedKendaraan.value,
                      orElse: () => KendaraanModel(
                            idKendaraan: 0,
                            noPolisi: '',
                            jenisKendaraan: '',
                            kapasitas: '',
                            merek: '',
                            type: '',
                            type2: '',
                            batangan: '',
                            wilayah: '',
                            karoseri: '',
                            hidrolik: '',
                            gps: '',
                            tahunRakit: '',
                            tahunBeli: '',
                            status: '',
                            kapasitasB: '',
                            kapasitasC: '',
                            plat: '',
                          )),
              dropdownBuilder: (context, KendaraanModel? selectedItem) {
                return Text(
                  selectedItem != null ? selectedItem.noPolisi : noPolisi,
                  style: TextStyle(
                    color: selectedItem == null ? Colors.grey : Colors.black,
                  ),
                );
              },
              onChanged: (KendaraanModel? kendaraan) {
                if (kendaraan != null) {
                  fetchKendaraanController.selectedKendaraan.value =
                      kendaraan.noPolisi;
                  fetchKendaraanController.selectedKendaraanId.value =
                      kendaraan.idKendaraan;
                  print(
                      'ini no polisi yang di pilih: ${fetchKendaraanController.selectedKendaraan.value}');
                } else {
                  fetchKendaraanController.resetSelectedKendaraan();
                }
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search Kendaraan...',
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Supir'),
          Obx(() {
            return DropdownSearch<SopirModel>(
              items: sopirController.filteredSopir,
              itemAsString: (SopirModel sopir) => sopir.nama,
              selectedItem: sopirController.sopirModel.firstWhereOrNull(
                (sopir) =>
                    sopir.nama == sopirController.selectedSopirDisplay.value,
              ),
              dropdownBuilder: (context, SopirModel? selectedItem) {
                return Text(
                  selectedItem != null ? selectedItem.nama : supir,
                  style: TextStyle(
                    color: selectedItem == null ? Colors.grey : Colors.black,
                  ),
                );
              },
              onChanged: (SopirModel? sopir) {
                if (sopir != null) {
                  sopirController.updateSelectedSopir(sopir.nama);
                  print('ini sopir nama yg di pilih: ${sopir.nama}');
                }
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search Sopir...',
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: CustomSize.spaceBtwItems),
          const Text('Jumlah Unit'),
          TextFormField(
            controller: widget.model.status == 0 ? null : jumlahController,
            keyboardType: widget.model.status == 0
                ? TextInputType.none
                : TextInputType.number,
            readOnly: widget.model.status == 0 ? true : false,
            decoration: widget.model.status == 0
                ? InputDecoration(
                    hintText: jumlahUnit.toString(),
                    filled: true,
                    fillColor: AppColors.buttonDisabled)
                : null,
          ),
        ],
      ),
    );
  }
}
