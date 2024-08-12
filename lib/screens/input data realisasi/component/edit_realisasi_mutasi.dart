import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/input data realisasi/do_mutasi_controller.dart';
import '../../../controllers/input data realisasi/fetch_kendaraan_controller.dart';
import '../../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../../models/input data realisasi/do_realisasi_model.dart';
import '../../../models/input data realisasi/kendaraan_model.dart';
import '../../../models/input data realisasi/sopir_model.dart';
import '../../../utils/constant/custom_size.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/dropdown.dart';

class EditRealisasiMutasi extends StatefulWidget {
  const EditRealisasiMutasi(
      {super.key, required this.model, required this.controller});

  final DoRealisasiModel model;
  final DoMutasiController controller;

  @override
  State<EditRealisasiMutasi> createState() => _EditRealisasiMutasiState();
}

class _EditRealisasiMutasiState extends State<EditRealisasiMutasi> {
  late int idReq;
  late int id;
  late String tujuan;
  late String plant;
  late String type;
  late String noPolisi;
  late String supir;
  late TextEditingController jumlahUnit;
  final FocusNode _focusNode = FocusNode();

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

  final Map<String, int> typeDOMap = {
    'REGULER': 0,
    'MUTASI': 1,
  };

  String get tujuanDisplayValue => tujuanMap[plant] ?? '';

  @override
  void initState() {
    super.initState();
    idReq = widget.model.idReq;
    id = widget.model.id;
    tujuan = widget.model.tujuan;
    plant = widget.model.plant;
    type = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
    noPolisi = widget.model.noPolisi;
    supir = widget.model.supir;
    jumlahUnit =
        TextEditingController(text: widget.model.jumlahUnit.toString());

    final fetchKendaraanController = Get.put(FetchKendaraanController());
    final sopirController = Get.put(FetchSopirController());

    fetchKendaraanController.selectedKendaraan.value = noPolisi;
    sopirController.selectedSopirDisplay.value = supir;

    if (widget.model.status != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    jumlahUnit.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchKendaraanController = Get.find<FetchKendaraanController>();
    final sopirController = Get.find<FetchSopirController>();

    int typeValue = typeDOMap[type] ?? 0;

    return AlertDialog(
      title: const Text('Edit DO Realisasi'),
      content: SingleChildScrollView(
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
                fillColor: AppColors.buttonDisabled,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type'),
            DropDownWidget(
              value: type,
              items: typeDOMap.keys.toList(),
              onChanged: (String? value) {
                setState(() {
                  type = value!;
                });
              },
            ),
            typeValue == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: CustomSize.spaceBtwItems),
                      const Text('Plant2'),
                      TextFormField(
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.truck_fast),
                            hintText: '1300',
                            filled: true,
                            fillColor: AppColors.buttonDisabled),
                      ),
                      const SizedBox(height: CustomSize.spaceBtwItems),
                      const Text('Tujuan2'),
                      TextFormField(
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.truck_fast),
                            hintText: 'Cibitung',
                            filled: true,
                            fillColor: AppColors.buttonDisabled),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('No Polisi'),
            Obx(() {
              return DropdownSearch<KendaraanModel>(
                items: fetchKendaraanController.filteredKendaraanModel,
                itemAsString: (KendaraanModel kendaraan) => kendaraan.noPolisi,
                selectedItem: fetchKendaraanController.filteredKendaraanModel
                    .firstWhereOrNull((kendaraan) =>
                        kendaraan.noPolisi ==
                        fetchKendaraanController.selectedKendaraan.value),
                dropdownBuilder: (context, KendaraanModel? selectedItem) {
                  return Text(
                    selectedItem != null
                        ? selectedItem.noPolisi
                        : 'Pilih No Polisi',
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
                    setState(() {
                      supir = sopir.nama;
                    });
                    print('Supir yang dipilih: $supir');
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
              focusNode: _focusNode,
              controller: jumlahUnit,
              keyboardType: TextInputType.number,
              readOnly: widget.model.status == 0,
              decoration: widget.model.status == 0
                  ? InputDecoration(
                      hintText: jumlahUnit.text,
                      filled: true,
                      fillColor: AppColors.buttonDisabled,
                    )
                  : null,
              onChanged: (value) {
                setState(() {
                  jumlahUnit.text = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            print('..EDIT REALISASI REGULER..');
            print('id: $id');
            print('plant: $plant');
            print('tujuan: $tujuan');
            print('type: $type');
            print(
                'id kendaraan: ${fetchKendaraanController.selectedKendaraanId.value}');
            print('supir: $supir');
            print('jumlah unit: ${jumlahUnit.text}');
            print('...EDIT REALISASI REGULER SELESAI...');
            // Konversi type dari String ke int menggunakan typeDOMap
            typeValue == 0
                ? widget.controller.editRealisasiReguler(
                    id,
                    plant,
                    tujuan,
                    typeValue,
                    '',
                    '',
                    fetchKendaraanController.selectedKendaraanId.value
                        .toString(),
                    supir,
                    int.parse(jumlahUnit.text))
                : widget.controller.editRealisasiReguler(
                    id,
                    plant,
                    tujuan,
                    typeValue,
                    '1300',
                    'Cibitung',
                    fetchKendaraanController.selectedKendaraanId.value
                        .toString(),
                    supir,
                    int.parse(jumlahUnit.text));
          },
          child: const Text('Simpan Data'),
        ),
      ],
    );
  }
}
