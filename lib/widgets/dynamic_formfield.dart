import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/input data realisasi/tambah_type_motor_controller.dart';
import '../controllers/master data/type_motor_controller.dart';
import '../models/input data realisasi/tambah_type_motor_model.dart';
import '../models/master data/type_motor_model.dart';
import '../screens/input data realisasi/component/tambah_type_kendaraan.dart';
import '../utils/theme/app_colors.dart';

class DynamicFormFieldHonda extends StatelessWidget {
  final int index;
  final TabDaerahTujuan tab;
  final FormFieldData data;
  final Function(String?) onDropdownChanged;
  final Function(String?) onTextFieldChanged;
  final VoidCallback onRemove;

  const DynamicFormFieldHonda({
    super.key,
    required this.index,
    required this.tab,
    required this.data,
    required this.onDropdownChanged,
    required this.onTextFieldChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final typeMotorHondaController = Get.put(TypeMotorHondaController());
    final controller = Get.find<TambahTypeMotorController>();
    final textController = controller.controllersPerTab[tab]?[index];

    if (textController == null) {
      // Handle the case where the TextEditingController is not found
      print(
          'Error: TextEditingController not found for index $index and tab $tab');
      return const SizedBox
          .shrink(); // Return an empty widget or handle appropriately
    }

    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final selectedItem =
                typeMotorHondaController.typeMotorHondaModel.firstWhere(
              (kendaraan) => kendaraan.typeMotor == data.dropdownValue,
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
            );

            return DropdownSearch<TypeMotorHondaModel>(
              items: typeMotorHondaController.typeMotorHondaModel,
              itemAsString: (TypeMotorHondaModel kendaraan) =>
                  kendaraan.typeMotor,
              selectedItem:
                  selectedItem.typeMotor.isNotEmpty ? selectedItem : null,
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
            controller: textController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              onTextFieldChanged(value);
              controller.updateTextFieldValue(tab, index, value);
            },
            decoration: InputDecoration(
              labelText: 'JML ${index + 1}',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Iconsax.trash, color: AppColors.error),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
