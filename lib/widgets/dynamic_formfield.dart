import 'package:flutter/material.dart';

import '../models/input data realisasi/tambah_type_motor_model.dart';

class DynamicFormField extends StatelessWidget {
  final int index;
  final FormFieldData data;
  final Function(String?) onDropdownChanged;
  final Function(String?) onTextFieldChanged;
  final VoidCallback onRemove;

  const DynamicFormField({
    super.key,
    required this.index,
    required this.data,
    required this.onDropdownChanged,
    required this.onTextFieldChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: data.dropdownValue,
            onChanged: onDropdownChanged,
            items: ['Type 1', 'Type 2', 'Type 3']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: InputDecoration(labelText: 'Type ${index + 1}'),
          ),
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
          icon: const Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
