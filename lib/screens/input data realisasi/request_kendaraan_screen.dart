import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/input data realisasi/request_kendaraan_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/input data realisasi/request_kendaraan_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/input data realisasi/request_mobil_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';
import 'kirim_kendaraan.dart';
import 'lihat_kendaraan.dart';

class RequestKendaraanScreen extends GetView<RequestKendaraanController> {
  const RequestKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': 50,
      'Tgl': 70,
      'Plant': 60,
      'Type': 50,
      'Jenis': 60,
      'Jml': 50,
      if (controller.rolesLihat == 1) 'Lihat': 80,
      if (controller.rolesKirim == 1) 'Kirim': 80,
      if (controller.rolesEdit == 1) 'Edit': 80,
    };
    const int rowsPerPage = 10;
    int currentPage = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Kendaraan Honda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.isRequestLoading.value &&
              controller.requestKendaraanModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.requestKendaraanModel.isEmpty) {
            return GestureDetector(
              onTap: () {
                print(
                    'ini nilai internet connection di request : ${controller.isConnected.value}');
                CustomDialogs.defaultDialog(
                    context: context,
                    titleWidget: const Text('Tambah Request Kendaraan'),
                    contentWidget: AddRequestKendaraan(
                      controller: controller,
                    ),
                    onConfirm: () {
                      if (controller.tgl.value.isEmpty) {
                        SnackbarLoader.errorSnackBar(
                          title: 'Gagal😪',
                          message: 'Pastikan tanggal telah di isi 😁',
                        );
                      } else {
                        controller.addRequestKendaraan();
                      }
                    },
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
            final dataSource = RequestMobilSource(
              onLihat: (RequestKendaraanModel model) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return LihatKendaraanScreen(
                      model: model,
                    );
                  },
                );
              },
              onKirim: (RequestKendaraanModel model) =>
                  Get.to(() => KirimKendaraanScreen(
                        model: model,
                        selectedIndex: model.idReq,
                      )),
              onEdit: (RequestKendaraanModel model) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return EditRequestKendaraan(
                      controller: controller,
                      model: model,
                    );
                  },
                );
              },
              requestKendaraanModel: controller.requestKendaraanModel,
              startIndex: currentPage * rowsPerPage,
            );

            List<GridColumn> column = [
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
                      ))),
              GridColumn(
                  width: columnWidths['Tgl']!,
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
                      ))),
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
                      ))),
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
                      ))),
              GridColumn(
                  width: columnWidths['Jml']!,
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
            ];

            // Tambahkan kolom dinamis berdasarkan peran
            if (controller.rolesLihat == 1) {
              column.add(GridColumn(
                width: columnWidths['Lihat']!,
                columnName: 'Lihat',
                label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Lihat',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
              ));
            }

            if (controller.rolesKirim == 1) {
              column.add(GridColumn(
                width: columnWidths['Kirim']!,
                columnName: 'Kirim',
                label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Kirim',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
              ));
            }

            if (controller.rolesEdit == 1) {
              column.add(GridColumn(
                width: columnWidths['Edit']!,
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
                    )),
              ));
            }

            // Print jumlah kolom
            print('Columns kendaraan: ${column.length}');

            return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchRequestKendaraan();
              },
              child: Column(
                children: [
                  controller.roleUser == 'admin' ||
                          controller.roleUser == 'Pengurus Pabrik'
                      ? GestureDetector(
                          onTap: () {
                            CustomDialogs.defaultDialog(
                                context: context,
                                titleWidget:
                                    const Text('Tambah Request Kendaraan'),
                                contentWidget: AddRequestKendaraan(
                                  controller: controller,
                                ),
                                onConfirm: () {
                                  if (controller.tgl.value.isEmpty) {
                                    SnackbarLoader.errorSnackBar(
                                      title: 'Gagal😪',
                                      message:
                                          'Pastikan tanggal telah di isi 😁',
                                    );
                                  } else if (controller.plant.value ==
                                      'Pilih plant..') {
                                    SnackbarLoader.errorSnackBar(
                                      title: 'Gagal😪',
                                      message:
                                          'Pastikan plant telah di pilih 😁',
                                    );
                                  } else {
                                    controller.addRequestKendaraan();
                                  }
                                },
                                cancelText: 'Close',
                                confirmText: 'Tambahkan');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const IconButton(
                                  onPressed: null,
                                  icon: Icon(Iconsax.add_circle)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: CustomSize.sm),
                                child: Text(
                                  'Tambah data',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      child: SfDataGrid(
                    source: dataSource,
                    frozenColumnsCount: 4,
                    rowHeight: 65,
                    columnWidthMode: ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columns: column,
                  )),
                  SfDataPager(
                    delegate: dataSource,
                    pageCount: controller.requestKendaraanModel.isEmpty
                        ? 1
                        : (controller.requestKendaraanModel.length /
                                rowsPerPage)
                            .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class AddRequestKendaraan extends StatelessWidget {
  const AddRequestKendaraan({super.key, required this.controller});

  final RequestKendaraanController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.requestKendaraanKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      DateTime? selectedDate =
                          DateTime.tryParse(controller.tgl.value);
                      showDatePicker(
                        context: context,
                        locale: const Locale("id", "ID"),
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1850),
                        lastDate: DateTime(2040),
                      ).then((newSelectedDate) {
                        if (newSelectedDate != null) {
                          controller.tgl.value =
                              CustomHelperFunctions.getFormattedDateDatabase(
                                  newSelectedDate);
                          print(
                              'Ini tanggal yang dipilih : ${controller.tgl.value}');
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                  hintText: controller.tgl.value.isNotEmpty
                      ? DateFormat.yMMMMd('id_ID').format(
                          DateTime.tryParse(
                                  '${controller.tgl.value} 00:00:00') ??
                              DateTime.now(),
                        )
                      : 'Tanggal',
                ),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Plant'),
            Obx(
              () => DropDownWidget(
                value: controller.plant.value == '0' && controller.isAdmin
                    ? 'Pilih plant..' // Admin default ke "Pilih plant.."
                    : controller
                        .plant.value, // Untuk non-admin, plant sudah ditentukan

                items: controller.isAdmin
                    ? ['Pilih plant..'] +
                        controller.regulerPlants // Admin melihat semua plant
                    : controller.plant.value == '1300' ||
                            controller.plant.value == '1350'
                        ? [
                            '1300',
                            '1350'
                          ] // Jika plant-nya 1300 atau 1350, tampilkan kedua plant tersebut
                        : [
                            controller.plant.value
                          ], // Selain itu, hanya tampilkan plant yang dipilih

                onChanged: (String? newValue) {
                  if (newValue != null && newValue != 'Pilih plant..') {
                    controller.plant.value =
                        newValue; // Set plant sesuai pilihan baru
                    print('Nilai plant dipilih: ${controller.plant.value}');
                  } else if (newValue == 'Pilih plant..') {
                    controller.plant.value =
                        '0'; // Reset ke 0 jika memilih "Pilih plant.."
                    print('Plant reset ke default admin: 0');
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
                    hintText: controller.tujuanDisplayValue,
                    filled: true,
                    fillColor: AppColors.buttonDisabled),
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah DO Harian'),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.truck_fast),
                    hintText: controller.jumlahHarian.toString(),
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
            const SizedBox(height: CustomSize.spaceBtwItems),
            TextFormField(
              controller: controller.jumlahKendaraanController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah kendaraan harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.truck),
                hintText: 'Jumlah Kendaraan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditRequestKendaraan extends StatefulWidget {
  const EditRequestKendaraan({
    super.key,
    required this.controller,
    required this.model,
  });

  final RequestKendaraanController controller;
  final RequestKendaraanModel model;

  @override
  State<EditRequestKendaraan> createState() => _EditRequestKendaraanState();
}

class _EditRequestKendaraanState extends State<EditRequestKendaraan> {
  late int id;
  late String tgl;
  late String plant;
  late String tujuan;
  late String type;
  late String jenisReq;
  late TextEditingController jumlahReq;

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

  final List<String> jenisKendaraanList = [
    'MOBIL MOTOR 16',
    'MOBIL MOTOR 40',
    'MOBIL MOTOR 64',
    'MOBIL MOTOR 86',
  ];

  @override
  void initState() {
    super.initState();
    id = widget.model.idReq;
    tgl = widget.model.tgl;
    plant = widget.model.plant;
    tujuan = widget.model.tujuan;
    type = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
    jenisReq = widget.model.jenis;
    jumlahReq = TextEditingController(text: widget.model.jumlah.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Request Kendaraan',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Req'),
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
                        // Menggunakan setState untuk memperbarui nilai dan UI
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
              items: widget.controller.isAdmin
                  ? widget.controller.idPlantMap.keys.toList()
                  : [plant],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    plant = newValue;
                    print('ini value dari plant $plant');
                  });
                }
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tujuan'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                hintText: tujuanMap[plant] ?? '',
                filled: true,
                fillColor: AppColors.buttonDisabled,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Type DO'),
            DropDownWidget(
              value: type,
              items: typeDOMap.keys.toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    type = value;
                    print('Selected type DO: $value');
                  });
                }
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jenis Kendaraan'),
            DropDownWidget(
              value: jenisReq,
              items: jenisKendaraanList,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    jenisReq = value;
                    print('Jenis Kendaraan selected: $jenisReq');
                  });
                }
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah Kendaraan'),
            TextFormField(
              controller: jumlahReq,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah kendaraan harus di isi';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.truck),
                hintText: 'Jumlah Kendaraan',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              tgl = widget.model.tgl;
              plant = widget.model.plant;
              type = widget.model.type == 0 ? 'REGULER' : 'MUTASI';
              jenisReq = widget.model.jenis;
              jumlahReq.text = widget.model.jumlah.toString();
            });
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            widget.controller.editReqKendaraan(
              id,
              tgl,
              plant,
              tujuanMap[plant] ?? '',
              typeDOMap[type]!,
              jenisReq,
              int.parse(jumlahReq.text),
            );
            print('ini id nya: $id');
            print('ini tgl nya: $tgl');
            print('ini plant nya: $plant');
            print('ini tujuan nya: ${tujuanMap[plant] ?? ''}');
            print('ini type nya: ${typeDOMap[type]!}');
            print('ini jenis kendaraan nya: $jenisReq');
            print('ini jumlah nya: ${jumlahReq.text.trim()}');
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
