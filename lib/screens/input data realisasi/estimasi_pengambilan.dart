import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/estimasi_pengambilan_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/estimasi_pengambilan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/input data realisasi/estimasi_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class EstimasiPM extends GetView<EstimasiPengambilanController> {
  const EstimasiPM({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDataEstimasiPengambilan();
    });

    const int rowsPerPage = 10;
    int currentPage = 0;

    late Map<String, double> columnEstimasi = {
      'No': 40,
      'Tgl': 70,
      'Plant': 60,
      'Tujuan': 100,
      'Type': 50,
      'Jenis': 100,
      'Jml': 50,
      'User': 70,
      'Edit': 70,
      'Hapus': 70,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Estimasi PM',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        print(
            'Jumlah data estimasi: ${controller.estimasiPengambilanModel.length}'); // Tambahkan ini

        if (controller.isLoadingEstimasi.value &&
            controller.estimasiPengambilanModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.estimasiPengambilanModel.isEmpty) {
          return GestureDetector(
            onTap: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget:
                      const Center(child: Text('Tambah Data Estimasi PM')),
                  contentWidget: AddEstimasiPm(
                    controller: controller,
                  ),
                  onConfirm: () => controller.addEstimasiPengambilanMotor(),
                  cancelText: 'Close',
                  confirmText: 'Tambahkan');
            },
            child: CustomAnimationLoaderWidget(
              text: 'Tambahkan Data Baru',
              animation: 'assets/animations/add-data-animation.json',
              height: CustomHelperFunctions.screenHeight() * 0.4,
              width: CustomHelperFunctions.screenHeight(),
            ),
          );
        } else {
          final dataSource = EstimasiPmSource(
              estimasiPmModel: controller.estimasiPengambilanModel,
              startIndex: currentPage * rowsPerPage,
              onEdited: (EstimasiPengambilanModel model) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditEstimasiPm(
                      controller: controller,
                      model: model,
                    );
                  },
                );
              },
              onDeleted: (EstimasiPengambilanModel model) =>
                  controller.hapusEstimasiPengambilan(model.idPlot));

          print('Jumlah data di source: ${dataSource.estimasiPmModel.length}');

          return RefreshIndicator(
            onRefresh: () async {
              controller.loadDataEstimasiPengambilan();
            },
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    CustomDialogs.defaultDialog(
                        context: context,
                        titleWidget: const Center(
                            child: Text('Tambah Data Estimasi PM')),
                        contentWidget: AddEstimasiPm(
                          controller: controller,
                        ),
                        onConfirm: () =>
                            controller.addEstimasiPengambilanMotor(),
                        cancelText: 'Close',
                        confirmText: 'Tambahkan');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const IconButton(
                          onPressed: null, icon: Icon(Iconsax.add_circle)),
                      Padding(
                        padding: const EdgeInsets.only(right: CustomSize.sm),
                        child: Text(
                          'Tambah data',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SfDataGrid(
                    source: dataSource,
                    frozenColumnsCount: 2,
                    columnWidthMode: ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    rowHeight: 65,
                    columns: [
                      GridColumn(
                          width: columnEstimasi['No']!,
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
                              ))),
                      GridColumn(
                          width: columnEstimasi['Tgl']!,
                          columnName: 'Tgl',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Tgl',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnEstimasi['Plant']!,
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
                              ))),
                      GridColumn(
                          width: columnEstimasi['Tujuan']!,
                          columnName: 'Tujuan',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Tujuan',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnEstimasi['Type']!,
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
                              ))),
                      GridColumn(
                          width: columnEstimasi['Jenis']!,
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
                              ))),
                      GridColumn(
                          width: columnEstimasi['Jml']!,
                          columnName: 'Jml',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Jml',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnEstimasi['User']!,
                          columnName: 'User',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'User',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnEstimasi['Edit']!,
                          columnName: 'Edit',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Edit',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnEstimasi['Hapus']!,
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
                ),
                SfDataPager(
                  delegate: dataSource,
                  pageCount: controller.estimasiPengambilanModel.isEmpty
                      ? 1
                      : (controller.estimasiPengambilanModel.length /
                              rowsPerPage)
                          .ceilToDouble(),
                  direction: Axis.horizontal,
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class AddEstimasiPm extends StatelessWidget {
  const AddEstimasiPm({super.key, required this.controller});

  final EstimasiPengambilanController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.addEstimasiPmKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tanggal'),
              TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.truck_fast),
                    hintText:
                        CustomHelperFunctions.getFormattedDate(DateTime.now()),
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Plant'),
              Obx(
                () => DropDownWidget(
                  value: controller.plant.value,
                  items: controller.tujuanMap.keys.toList(),
                  onChanged: (String? value) {
                    print('Selected plant: $value');
                    controller.plant.value = value!;
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
                      hintText: controller.tujuanDisplayValue,
                      filled: true,
                      fillColor: AppColors.buttonDisabled),
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Type DO'),
              Obx(
                () => DropDownWidget(
                  value:
                      controller.typeDO.value, // Menampilkan label yang dipilih
                  items: controller.typeDOMap.keys
                      .toList(), // Menggunakan key dari map sebagai item dropdown
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.typeDO.value = value; // Update label
                      controller.typeDOValue.value =
                          controller.typeDOMap[value] ??
                              0; // Update nilai integer yang sesuai
                      print(
                          'Selected type DO: $value dengan nilai ${controller.typeDOValue.value}');
                    }
                  },
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Jenis'),
              Obx(
                () => DropDownWidget(
                  value: controller.jenisKendaraan.value,
                  items: controller.jenisKendaraanList,
                  onChanged: (String? value) {
                    print('Selected plant: $value');
                    controller.jenisKendaraan.value = value!;
                  },
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Jumlah'),
              TextFormField(
                controller: controller.jumlahController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus di isi';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.truck),
                  hintText: 'Jumlah',
                ),
              ),
            ],
          ),
        ));
  }
}

class EditEstimasiPm extends StatefulWidget {
  const EditEstimasiPm(
      {super.key, required this.model, required this.controller});

  final EstimasiPengambilanModel model;
  final EstimasiPengambilanController controller;

  @override
  State<EditEstimasiPm> createState() => _EditEstimasiPmState();
}

class _EditEstimasiPmState extends State<EditEstimasiPm> {
  late int idPlot;
  late int idPlant;
  late String plant;
  late String tujuan;
  late String type;
  late String jenisKen;
  late TextEditingController jumlah;
  late String user;
  late String tgl;

  final Map<String, String> tujuanMap = {
    '1100': 'Sunter', //1
    '1200': 'Pegangsaan', //2
    '1300': 'Cibitung', //3
    '1350': 'Cibitung', //4
    '1700': 'Dawuan', //5
    '1800': 'Dawuan', //6
    '1900': 'Bekasi', //9
  };

  final Map<String, String> idPlantMap = {
    '1100': '1', //1
    '1200': '2', //2
    '1300': '3', //3
    '1350': '4', //4
    '1700': '5', //5
    '1800': '6', //6
    '1900': '9', //9
  };

  final Map<String, int> typeDOMap = {
    'REGULER': 0,
    'MUTASI': 1,
  };

  final List<String> jenisKendaraanList = [
    'MOBIL MOTOR 16',
    'MOBIL MOTOR 40',
    'MOBIL MOTOR 64',
    'MOBIL MOTOR 86',
  ];

  @override
  void initState() {
    super.initState();
    idPlot = widget.model.idPlot;
    idPlant = widget.model.idPlant;
    plant = widget.model.plant1;
    tujuan = widget.model.tujuan;
    type = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
    jenisKen = widget.model.jenisKen;
    jumlah = TextEditingController(text: widget.model.jumlah.toString());
    user = widget.model.user;
    tgl = widget.model.tgl;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text('Edit Estimasi Pengambilan Motor',
              style: Theme.of(context).textTheme.headlineMedium)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate = DateTime.tryParse(tgl);

                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        // Hanya ubah nilai tanggal, biarkan waktu tetap default
                        setState(() {
                          tgl = CustomHelperFunctions.getFormattedDateDatabase(
                              newSelectedDate);
                          print('Ini tanggal yang dipilih : $tgl');
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                hintText: tgl.isNotEmpty
                    ? DateFormat.yMMMMd('id_ID').format(
                        DateTime.tryParse('$tgl 00:00:00') ?? DateTime.now(),
                      )
                    : 'Tanggal',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            DropDownWidget(
              value: plant,
              items: tujuanMap.keys.toList(),
              onChanged: (String? value) {
                setState(() {
                  print('Selected plant: $value');
                  plant = value!;
                  idPlant = int.parse(idPlantMap[value]!);
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
                  fillColor: AppColors.buttonDisabled),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type DO'),
            DropDownWidget(
              value: type,
              items: typeDOMap.keys.toList(),
              onChanged: (String? value) {
                setState(() {
                  type = value!;
                });
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis'),
            DropDownWidget(
              value: jenisKen,
              items: jenisKendaraanList,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    jenisKen = value;
                    print('Jenis Kendaraan selected: $jenisKen');
                  });
                }
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah'),
            TextFormField(
              controller: jumlah, // Ambil jumlah dari model
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.truck),
                hintText: 'Jumlah',
              ),
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
          onPressed: () => widget.controller.editEstimasiPengambilanMotor(
              idPlot,
              idPlant,
              tujuan,
              typeDOMap[type]!,
              jenisKen,
              int.parse(jumlah.text),
              user,
              CustomHelperFunctions.formattedTime,
              tgl),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
