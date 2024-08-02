import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/master data/type_motor_controller.dart';
import '../models/input data realisasi/tambah_type_motor_model.dart';
import '../models/master data/type_motor_model.dart';

class DynamicFormFieldHonda extends StatelessWidget {
  final int index;
  final FormFieldData data;
  final Function(String?) onDropdownChanged;
  final Function(String?) onTextFieldChanged;
  final VoidCallback onRemove;

  const DynamicFormFieldHonda({
    super.key,
    required this.index,
    required this.data,
    required this.onDropdownChanged,
    required this.onTextFieldChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final typeMotorHondaController = Get.put(TypeMotorHondaController());
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            return DropdownSearch<TypeMotorHondaModel>(
              items: typeMotorHondaController.typeMotorHondaModel,
              itemAsString: (TypeMotorHondaModel kendaraan) =>
                  kendaraan.typeMotor,
              selectedItem:
                  typeMotorHondaController.selectedTypeMotor.value.isNotEmpty
                      ? typeMotorHondaController.typeMotorHondaModel.firstWhere(
                          (kendaraan) =>
                              kendaraan.typeMotor ==
                              typeMotorHondaController.selectedTypeMotor.value,
                          orElse: () => TypeMotorHondaModel(
                            idType: 0,
                            merk: '',
                            typeMotor: '',
                            hlm: 0,
                            ac: 0,
                            ks: 0,
                            ts: 0,
                            bp: 0,
                            bs: 0,
                            plt: 0,
                            stay: 0,
                            acBesar: 0,
                            plastik: 0,
                          ),
                        )
                      : null,
              dropdownBuilder: (context, TypeMotorHondaModel? selectedItem) {
                return Text(
                  selectedItem != null
                      ? selectedItem.typeMotor
                      : 'Pilih Type Motor',
                  style: TextStyle(
                    color: selectedItem == null ? Colors.grey : Colors.black,
                  ),
                );
              },
              onChanged: (TypeMotorHondaModel? kendaraan) {
                if (kendaraan != null) {
                  typeMotorHondaController
                      .setSelectedTypeMotor(kendaraan.typeMotor);
                  onDropdownChanged(kendaraan.typeMotor);
                } else {
                  typeMotorHondaController.resetSelectedTypeMotor();
                  onDropdownChanged(null);
                }
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search Type Motor...',
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            initialValue: data.textFieldValue,
            onChanged: onTextFieldChanged,
            decoration: InputDecoration(
              labelText: 'JML ${index + 1}',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Iconsax.trash,color: AppColors.error,),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
