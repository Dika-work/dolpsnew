import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/fetch_kendaraan_controller.dart';
import '../../controllers/input data realisasi/fetch_sopir_controller.dart';
import '../../controllers/input data realisasi/kirim_kendaraan_controller.dart';
import '../../controllers/input data realisasi/plot_kendaraan_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/kendaraan_model.dart';
import '../../models/input data realisasi/kirim_kendaraan_model.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../models/input data realisasi/sopir_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data realisasi/kirim_kendaraan_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class KirimKendaraanScreen extends StatelessWidget {
  final RequestKendaraanModel model;
  final int selectedIndex;

  const KirimKendaraanScreen(
      {super.key, required this.model, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KirimKendaraanController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDataKirimKendaraan(
        model.type,
        model.plant,
        model.idReq,
      );
    });

    late Map<String, double> columnWidths = {
      'No': 50,
      'No Polisi': 110,
      'Status': 70,
      'Supir': 100,
      'Hapus': 55,
    };

    const double rowHeight = 70.0;
    const double headerHeight = 85.0;
    const int numberOfRows = 10;

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
            final dataSource = KirimKendaraanSource(
              onDelete: (KirimKendaraanModel model) {
                print('..INI HAPUS KIRIM KENDARAAN..');
                controller.hapusKirimKendaraan(
                  model.idReq,
                  model.tgl,
                  model.type,
                  model.plant,
                  model.id,
                );
              },
              kirimKendaraanModel: controller.kirimKendaraanModel,
            );

            final rowCount = controller.kirimKendaraanModel.length;
            final int rowsPerPage =
                rowCount < numberOfRows ? rowCount : numberOfRows;
            final double tableHeight =
                rowCount > 0 ? rowsPerPage * rowHeight + headerHeight : 130;

            return LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: tableHeight,
                        child: SfDataGrid(
                          source: dataSource,
                          verticalScrollPhysics:
                              const NeverScrollableScrollPhysics(),
                          columnWidthMode: ColumnWidthMode.auto,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          rowHeight: rowHeight,
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
                              width: columnWidths['No Polisi']!,
                              columnName: 'No Polisi',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'No Polisi',
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    rowCount > 0
                        ? Center(
                            child: SfDataPager(
                              delegate: dataSource,
                              pageCount:
                                  (rowCount / numberOfRows).ceilToDouble(),
                              direction: Axis.horizontal,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Divider(height: CustomSize.dividerHeight),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: CustomSize.md, vertical: CustomSize.lg),
                      child: AddKirimKendaraan(model: model),
                    ),
                  ],
                );
              },
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
    final plotController = Get.put(PlotKendaraanController());
    plotController.fetchPlot(idReq, tgl, typeDO, plant, jumlahKendaraan);
  }

  @override
  Widget build(BuildContext context) {
    final fetchKendaraanController = Get.put(FetchKendaraanController());
    final sopirController = Get.put(FetchSopirController());
    final controller = Get.put(KirimKendaraanController());
    final plotController = Get.put(PlotKendaraanController());

    return Form(
      key: controller.kirimKendaraanKey,
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
            const Text('Type DO'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: typeDO == 0 ? 'REGULER' : 'MUTASI',
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tanggal Request'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: CustomHelperFunctions.getFormattedDate(parsedDate),
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            typeDO == 1
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
            const Text('Jumlah Kendaraan'),
            TextFormField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: jumlahKendaraan.toString(),
                  filled: true,
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plot Kendaraan'),
            Obx(() {
              return TextFormField(
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: plotController.plotModel.isNotEmpty
                        ? plotController.plotModel.first.jumlahPlot.toString()
                        : 'Loading...',
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              );
            }),
            Obx(() => plotController.isJumlahKendaraanSama.value
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: CustomSize.spaceBtwItems),
                      const Text('Jenis Kendaraan'),
                      Obx(() {
                        return DropDownWidget(
                          value: fetchKendaraanController
                              .selectedJenisKendaraan.value,
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
                      const Text('No Polisi'),
                      Obx(() {
                        return DropdownSearch<KendaraanModel>(
                          items:
                              fetchKendaraanController.filteredKendaraanModel,
                          itemAsString: (KendaraanModel kendaraan) =>
                              kendaraan.noPolisi,
                          selectedItem: fetchKendaraanController
                                  .selectedKendaraan.value.isNotEmpty
                              ? fetchKendaraanController.filteredKendaraanModel
                                  .firstWhere(
                                  (kendaraan) =>
                                      kendaraan.noPolisi ==
                                      fetchKendaraanController
                                          .selectedKendaraan.value,
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
                                  ),
                                )
                              : null,
                          dropdownBuilder:
                              (context, KendaraanModel? selectedItem) {
                            return Text(
                              selectedItem != null
                                  ? selectedItem.noPolisi
                                  : 'Pilih No Polisi',
                              style: TextStyle(
                                color: selectedItem == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            );
                          },
                          onChanged: (KendaraanModel? kendaraan) {
                            if (kendaraan != null) {
                              fetchKendaraanController.selectedKendaraan.value =
                                  kendaraan.noPolisi;
                              fetchKendaraanController.selectedKendaraanId
                                  .value = kendaraan.idKendaraan;
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
                      const Text('Sopir'),
                      Obx(
                        () => DropdownSearch<SopirModel>(
                          items: sopirController.filteredSopir,
                          itemAsString: (SopirModel sopir) =>
                              '${sopir.nama} - (${sopir.namaPanggilan})',
                          selectedItem: sopirController
                                  .selectedSopirDisplay.value.isNotEmpty
                              ? sopirController.sopirModel.firstWhere(
                                  (sopir) =>
                                      '${sopir.nama} - (${sopir.namaPanggilan})' ==
                                      sopirController
                                          .selectedSopirDisplay.value,
                                  orElse: () => SopirModel(
                                      id: 0,
                                      nama: '',
                                      namaPanggilan: '',
                                      namaDivisi: ''),
                                )
                              : null,
                          dropdownBuilder: (context, SopirModel? selectedItem) {
                            return Text(
                              selectedItem != null && selectedItem.id != 0
                                  ? '${selectedItem.nama} - (${selectedItem.namaPanggilan})'
                                  : 'Pilih Sopir',
                              style: TextStyle(
                                color:
                                    selectedItem == null || selectedItem.id == 0
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                            );
                          },
                          onChanged: (SopirModel? sopir) {
                            if (sopir != null && sopir.id != 0) {
                              sopirController.updateSelectedSopir(
                                  '${sopir.nama} - (${sopir.namaPanggilan})');
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
                        ),
                      ),
                    ],
                  )),
            const SizedBox(height: CustomSize.spaceBtwSections),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int kendaraan =
                        fetchKendaraanController.selectedKendaraanId.value;
                    String supir = sopirController.selectedSopirNama.value;

                    if (plotController.isJumlahKendaraanSama.value) {
                      // Jika jumlah kendaraan dan plot sudah sama, kembali
                      controller.selesaiKirimKendaraan(idReq);
                      // Get.back();
                    } else if (kendaraan == 0 || supir == '') {
                      // Jika kendaraan atau sopir belum dipilih
                      SnackbarLoader.errorSnackBar(
                        title: 'Gagal😪',
                        message:
                            'Pastikan nomor polisi dan supir telah di pilih',
                      );
                    } else {
                      // Jika typeDO adalah 0, kirim data tanpa plant2 dan tujuan2
                      if (typeDO == 0) {
                        controller.addKirimKendaraanContent(
                          idReq,
                          jumlahKendaraan,
                          plant,
                          tujuan,
                          '', // plant2 kosong
                          '', // tujuan2 kosong
                          typeDO,
                          kendaraan,
                          supir,
                          CustomHelperFunctions.formattedTime,
                          tgl,
                          bulan,
                          tahun,
                          user,
                        );
                      } else {
                        // Jika typeDO adalah 1, kirim data dengan plant2 dan tujuan2
                        controller.addKirimKendaraanContent(
                          idReq,
                          jumlahKendaraan,
                          plant,
                          tujuan,
                          controller.selectedPlant.value,
                          controller.selectedTujuan.value,
                          typeDO,
                          kendaraan,
                          supir,
                          CustomHelperFunctions.formattedTime,
                          tgl,
                          bulan,
                          tahun,
                          user,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plotController.isJumlahKendaraanSama.value
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                  child: Text(
                    plotController.isJumlahKendaraanSama.value
                        ? 'Selesai'
                        : 'Tambah Data',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
