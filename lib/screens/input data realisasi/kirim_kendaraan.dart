import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/models/input%20data%20realisasi/kirim_kendaraan_model.dart';
import 'package:doplsnew/utils/loader/circular_loader.dart';
import 'package:doplsnew/utils/source/input%20data%20realisasi/kirim_kendaraan_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/fetch_kendaraan_controller.dart';
import '../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../controllers/input data realisasi/kirim_kendaraan_controller.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/popups/snackbar.dart';
import '../../widgets/dropdown.dart';

class KirimKendaraanScreen extends StatelessWidget {
  final RequestKendaraanModel model;

  const KirimKendaraanScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KirimKendaraanController());
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Plant': double.nan,
      'Type': 130,
      'Kendaraan': 150,
      'Jenis': double.nan,
      'Status': double.nan,
      'LV Kerusakan': double.nan,
      'Supir': double.nan,
      'Hapus': 50,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah data plant kendaraan honda',
          maxLines: 2,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoadingKendaraan.value &&
              controller.kirimKendaraanModel.isEmpty) {
            return const CustomCircularLoader();
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SfDataGrid(
                    source: KirimKendaraanSource(
                      onDelete: (KirimKendaraanModel model) {
                        print('..INI HAPUS KIRIM KENDARAAN..');
                      },
                      kirimKendaraanModel: controller.kirimKendaraanModel,
                    ),
                    columnWidthMode: ColumnWidthMode.auto,
                    allowPullToRefresh: true,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    allowColumnsResizing: true,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                      columnWidths[details.column.columnName] = details.width;
                      return true;
                    },
                    columns: [
                      GridColumn(
                        width: columnWidths['No']!,
                        columnName: 'No',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'No',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Plant']!,
                        columnName: 'Plant',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Plant',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Type']!,
                        columnName: 'Type',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Type',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Kendaraan']!,
                        columnName: 'Kendaraan',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Kendaraan',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Jenis']!,
                        columnName: 'Jenis',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Jenis',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Status']!,
                        columnName: 'Status',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Status',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['LV Kerusakan']!,
                        columnName: 'LV Kerusakan',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'LV Kerusakan',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        width: columnWidths['Supir']!,
                        columnName: 'Supir',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Supir',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                          width: columnWidths['Hapus']!,
                          columnName: 'Hapus',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Hapus',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomSize.md, vertical: CustomSize.lg),
                    child: AddKirimKendaraan(model: model),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
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

  late int idReq;
  late DateTime parsedDate;
  late String tgl;
  late int bulan;
  late int tahun;
  late String plant;
  late String tujuan;
  late int typeDO;
  late String jenisKendaraan;
  late int jumlahKendaraan;
  late String user;

  @override
  void initState() {
    super.initState();
    idReq = widget.model.idReq;
    parsedDate = DateFormat('yyyy-MM-dd').parse(widget.model.tgl);
    tgl = CustomHelperFunctions.getFormattedDateDatabase(parsedDate);
    bulan = parsedDate.month;
    tahun = parsedDate.year;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    typeDO = widget.model.type;
    jenisKendaraan = widget.model.jenis;
    jumlahKendaraan = widget.model.jumlah;
    user = widget.model.pengurus;

    // Set default value for jenisKendaraan di controller
    final fetchKendaraanController = Get.put(FetchKendaraanController());
    fetchKendaraanController.setSelectedJenisKendaraan(jenisKendaraan);
  }

  @override
  Widget build(BuildContext context) {
    final fetchKendaraanController = Get.put(FetchKendaraanController());
    final sopirController = Get.put(FetchSopirController());
    final controller = Get.put(KirimKendaraanController());

    return Form(
      key: kirimKendaraanKey,
      child: SingleChildScrollView(
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
                hintText: CustomHelperFunctions.getFormattedDate(parsedDate),
              ),
            ),
            widget.model.type == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: CustomSize.spaceBtwItems),
                      const Text('Plant'),
                      Obx(
                        () => DropDownWidget(
                          value: controller.selectedPlant.value,
                          items: controller.tujuanMap.keys.toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.updateSelectedPlant(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: CustomSize.spaceBtwItems),
                      const Text('Tujuan'),
                      Obx(
                        () => TextFormField(
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.truck_fast),
                            hintText: controller.selectedTujuan.value,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
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
            const Text('Jumlah Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: InputDecoration(
                hintText: jumlahKendaraan.toString(),
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
                    // Cari ID kendaraan dari nomor polisi yang dipilih
                    final selectedKendaraan = fetchKendaraanController
                        .filteredKendaraanModel
                        .firstWhere(
                            (kendaraan) => kendaraan.noPolisi == newValue);
                    fetchKendaraanController.selectedKendaraanId.value =
                        selectedKendaraan.idKendaraan;
                  }
                },
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Sopir'),
            Obx(
              () => DropDownWidget(
                value: sopirController.selectedSopirDisplay.value.isEmpty
                    ? null
                    : sopirController.selectedSopirDisplay.value,
                items: sopirController.sopirModel
                    .map((sopir) => '${sopir.nama} - (${sopir.namaPanggilan})')
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    sopirController.updateSelectedSopir(value);
                  }
                },
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    int kendaraan =
                        fetchKendaraanController.selectedKendaraanId.value;
                    String supir = sopirController.selectedSopirNama.value;
                    print(
                        '...INI BAGIAN TAMBAH DATA PADA DATA DO REALISASI HONDA...');
                    print('idReq: $idReq');
                    print('plant: $plant');
                    print('tujuan: $tujuan');
                    print('plant2 : ${controller.selectedPlant.value}');
                    print('tujuan2: ${controller.selectedTujuan.value}');
                    print('type: $typeDO');
                    print('kendaraan: $kendaraan');
                    print('supir: $supir');
                    print('jam: ${CustomHelperFunctions.formattedTime}');
                    print('tgl: $tgl');
                    print('bulan: $bulan');
                    print('tahun: $tahun');
                    print('user: $user');
                    print('Jumlah kendaraan :$jumlahKendaraan');
                    print('...SELESAI...');
                    // if (kendaraan.isEmpty) {
                    //    SnackbarLoader.errorSnackBar(
                    //     title: 'Gagal😪',
                    //     message: 'Pastikan nomor polisi telah di isi 😁',
                    //   );
                    // } else {
                    //   controller.addKirimKendaraanContent(
                    //       idReq,
                    //       jumlahKendaraan,
                    //       plant,
                    //       tujuan,
                    //       controller.selectedPlant.value,
                    //       controller.selectedTujuan.value,
                    //       typeDO,
                    //       kendaraan,
                    //       supir,
                    //       CustomHelperFunctions.formattedTime,
                    //       tgl,
                    //       bulan,
                    //       tahun,
                    //       user);
                    // }
                  },
                  child: const Text('Tambah Data')),
            )
          ],
        ),
      ),
    );
  }
}
