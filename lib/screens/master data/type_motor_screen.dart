import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/master data/type_motor_controller.dart';
import '../../helpers/helper_function.dart';
import '../../models/master data/type_motor_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/master data/type_motor_source.dart';
import '../../widgets/dropdown.dart';

class TypeMotorScreen extends GetView<TypeMotorController> {
  const TypeMotorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': double.nan,
      'Merk': double.nan,
      'Type Motor': double.nan,
      'HLM': double.nan,
      'AC': double.nan,
      'KS': double.nan,
      'TS': double.nan,
      'BP': double.nan,
      'BS': double.nan,
      'PLT': double.nan,
      'Stay L/R': double.nan,
      'Ac Besar': double.nan,
      'Plastik': double.nan,
      'Action': double.nan,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Type Motor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (!controller.isConnected.value) {
          return const CustomAnimationLoaderWidget(
              text:
                  'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
              animation: 'assets/animations/404.json');
        } else if (controller.isLoadingTypeMotor.value &&
            controller.typeMotorModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.typeMotorModel.isEmpty) {
          return GestureDetector(
            onTap: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: const Text('Tambah Type Motor'),
                  contentWidget: AddTypeMotor(
                    controller: controller,
                  ),
                  onConfirm: controller.addTypeMotorData,
                  onCancel: () {
                    Get.back();

                    controller.merkValue.value = 'Honda';
                    controller.typeMotorController.clear();
                    controller.hlm.value = null;
                    controller.ac.value = null;
                    controller.ks.value = null;
                    controller.ts.value = null;
                    controller.bp.value = null;
                    controller.bs.value = null;
                    controller.plt.value = null;
                    controller.stay.value = null;
                    controller.acBesar.value = null;
                    controller.plastik.value = null;
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
          final dataSource = TypeMotorSource(
            typeMotorModel: controller.displayedData,
            onEdit: (TypeMotorModel model) {
              showDialog(
                context: context,
                builder: (context) {
                  return EditTypeMotor(controller: controller, model: model);
                },
              );
              print('..TRIGGER BTN EDIT DI MASTER TYPE MOTOR...');
            },
            onHapus: (TypeMotorModel model) {
              controller.hapusTypeMotorData(model.idType);
              print('..TRIGGER BTN HAPUS DI MASTER TYPE MOTOR...');
            },
          );
          return SfDataGrid(
            source: dataSource,
            columnWidthMode: ColumnWidthMode.auto,
            frozenColumnsCount: 2,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            verticalScrollController: controller.scrollController,
            rowHeight: 150,
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
                      ))),
              GridColumn(
                  width: columnWidths['Type Motor']!,
                  columnName: 'Type Motor',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Type Motor',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['Merk']!,
                  columnName: 'Merk',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'Merk',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['HLM']!,
                  columnName: 'HLM',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'HLM',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['AC']!,
                  columnName: 'AC',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.lightBlue.shade100,
                      ),
                      child: Text(
                        'AC',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  width: columnWidths['KS']!,
                  columnName: 'KS',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'KS',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )),
              GridColumn(
                  width: columnWidths['TS']!,
                  columnName: 'TS',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'TS',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )),
              GridColumn(
                  width: columnWidths['BP']!,
                  columnName: 'BP',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'BP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )),
              GridColumn(
                width: columnWidths['BS']!,
                columnName: 'BS',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'BS',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                width: columnWidths['PLT']!,
                columnName: 'PLT',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'PLT',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                width: columnWidths['Stay L/R']!,
                columnName: 'Stay L/R',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Stay L/R',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                width: columnWidths['Ac Besar']!,
                columnName: 'Ac Besar',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Ac Besar',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                width: columnWidths['Plastik']!,
                columnName: 'Plastik',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Plastik',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                width: columnWidths['Action']!,
                columnName: 'Action',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Action',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: Obx(() {
        if (controller.typeMotorModel.isNotEmpty) {
          return FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              CustomDialogs.defaultDialog(
                  context: context,
                  titleWidget: const Text('Input Type Motor'),
                  contentWidget: AddTypeMotor(
                    controller: controller,
                  ),
                  onConfirm: controller.addTypeMotorData,
                  onCancel: () {
                    Get.back();

                    controller.merkValue.value = 'Honda';
                    controller.typeMotorController.clear();
                    controller.hlm.value = null;
                    controller.ac.value = null;
                    controller.ks.value = null;
                    controller.ts.value = null;
                    controller.bp.value = null;
                    controller.bs.value = null;
                    controller.plt.value = null;
                    controller.stay.value = null;
                    controller.acBesar.value = null;
                    controller.plastik.value = null;
                  },
                  cancelText: 'Close',
                  confirmText: 'Tambahkan');
            },
            icon: const Icon(Iconsax.add),
            label: Text('Type Motor',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.apply(color: AppColors.white)),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}

class AddTypeMotor extends StatelessWidget {
  const AddTypeMotor({super.key, required this.controller});

  final TypeMotorController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.addTypeMotor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Merk'),
              Obx(
                () => DropDownWidget(
                  value: controller.merkValue.value,
                  items: controller.typeMotorList,
                  onChanged: (String? value) {
                    controller.merkValue.value = value!;
                    print(
                        'ini jenisKen yang telah di pilih : ${controller.merkValue.value}');
                  },
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('Type Motor'),
              TextFormField(
                controller: controller.typeMotorController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Type Motor harus di isi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const Text('HLM'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.hlm.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.hlm.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.hlm.value = value,
                          ),
                        ),
                        const Text(
                            'Yes'), // Teks yang ingin Anda perbesar area kliknya
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () =>
                        controller.hlm.value = 0, // Mengubah nilai menjadi 0
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.hlm.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.hlm.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const Text('AC'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.ac.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.ac.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ac.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () =>
                        controller.ac.value = 0, // Mengubah nilai menjadi 0
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.ac.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ac.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const Text('KS'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.ks.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.ks.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ks.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () =>
                        controller.ks.value = 0, // Mengubah nilai menjadi 0
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.ks.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ks.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const Text('TS'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.ts.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.ts.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ts.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () =>
                        controller.ts.value = 0, // Mengubah nilai menjadi 0
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.ts.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.ts.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const Text('BP'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.bp.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.bp.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.bp.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.bp.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.bp.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.bp.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const Text('BS'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.bs.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.bs.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.bs.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.bs.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.bs.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.bs.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Text('PLT'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.plt.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.plt.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.plt.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.plt.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.plt.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.plt.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Text('STAY L/R'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.stay.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.stay.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.stay.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.stay.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.stay.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) => controller.stay.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Text('AC Besar'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.acBesar.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.acBesar.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                controller.acBesar.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.acBesar.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.acBesar.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                controller.acBesar.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Text('Plastik'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.plastik.value = 1,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 1,
                            groupValue: controller.plastik.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                controller.plastik.value = value,
                          ),
                        ),
                        const Text('Yes'),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  GestureDetector(
                    onTap: () => controller.plastik.value = 0,
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<int?>(
                            value: 0,
                            groupValue: controller.plastik.value,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                controller.plastik.value = value,
                          ),
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ));
  }
}

// edit type motor
class EditTypeMotor extends StatefulWidget {
  const EditTypeMotor(
      {super.key, required this.controller, required this.model});

  final TypeMotorController controller;
  final TypeMotorModel model;

  @override
  State<EditTypeMotor> createState() => _EditTypeMotorState();
}

class _EditTypeMotorState extends State<EditTypeMotor> {
  late int idType;
  late String merk;
  late TextEditingController typeMotor;
  late int hlm;
  late int ac;
  late int ks;
  late int ts;
  late int bp;
  late int bs;
  late int plt;
  late int stay;
  late int acBesar;
  late int plastik;

  @override
  void initState() {
    super.initState();
    idType = widget.model.idType;
    merk = CustomHelperFunctions.toTitleCase(widget.model.merk);
    typeMotor = TextEditingController(text: widget.model.typeMotor);
    hlm = widget.model.hlm;
    ac = widget.model.ac;
    ks = widget.model.ks;
    ts = widget.model.ts;
    bp = widget.model.bp;
    bs = widget.model.bs;
    plt = widget.model.plt;
    stay = widget.model.stay;
    acBesar = widget.model.acBesar;
    plastik = widget.model.plastik;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Type Motor',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: Form(
          key: widget.controller.addTypeMotor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Merk'),
                DropDownWidget(
                  value: merk,
                  items: widget.controller.typeMotorList,
                  onChanged: (String? value) {
                    setState(() {
                      merk = value!;
                      print(
                          'ini jenisKen yang telah di pilih : ${widget.controller.merkValue.value}');
                    });
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                const Text('Type Motor'),
                TextFormField(
                  controller: typeMotor,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Type Motor harus di isi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                const Text('HLM'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          hlm = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: hlm,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  hlm = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          hlm = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: hlm,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  hlm = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('AC'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          ac = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: ac,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ac = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          ac = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: ac,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ac = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('KS'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          ks = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: ks,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ks = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          ks = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: ks,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ks = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('TS'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          ts = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: ts,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ts = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          ts = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: ts,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  ts = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('BP'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          bp = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: bp,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  bp = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          bp = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: bp,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  bp = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('BS'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          bs = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: bs,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  bs = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          bs = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: bs,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  bs = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('PLT'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          plt = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: plt,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  plt = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          plt = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: plt,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  plt = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('STAY L/R'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          stay = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: stay,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  stay = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          stay = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: stay,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  stay = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('AC Besar'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          acBesar = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: acBesar,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  acBesar = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          acBesar = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: acBesar,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  acBesar = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Text('Plastik'),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          plastik = 1;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 1,
                              groupValue: plastik,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  plastik = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          plastik = 0;
                        }),
                        child: Row(
                          children: [
                            Radio<int?>(
                              value: 0, // Value untuk No adalah 0
                              groupValue: plastik,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  plastik = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            merk = CustomHelperFunctions.toTitleCase(widget.model.merk);
            typeMotor = TextEditingController(text: widget.model.typeMotor);
            hlm = widget.model.hlm;
            ac = widget.model.ac;
            ks = widget.model.ks;
            ts = widget.model.ts;
            bp = widget.model.bp;
            bs = widget.model.bs;
            plt = widget.model.plt;
            stay = widget.model.stay;
            acBesar = widget.model.acBesar;
            plastik = widget.model.plastik;
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () => widget.controller.editTypeMotor(
              idType,
              merk,
              typeMotor.text,
              hlm,
              ac,
              ks,
              ts,
              bp,
              bs,
              plt,
              stay,
              acBesar,
              plastik),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
