import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constant/custom_size.dart';

class LaporanPlant extends StatefulWidget {
  const LaporanPlant({super.key});

  @override
  State<LaporanPlant> createState() => _LaporanPlantState();
}

class _LaporanPlantState extends State<LaporanPlant> {
  List<String> plant = [
    'PLANT 1100',
    'PLANT 1200',
    'PLANT 1300',
    'PLANT 1350',
    'PLANT 1700',
    'PLANT 1800',
    'PLANT 1900',
  ];

  int? selectedIndex; // To keep track of the selected button index
  String selectedPlant = '';

  @override
  void initState() {
    super.initState();
    // Retrieve the argument passed from the drawer ListTile
    if (Get.arguments != null) {
      selectedPlant = Get.arguments as String;
      // Update the selected index based on the argument received
      selectedIndex = plant.indexOf(selectedPlant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 4.0,
                children: List.generate(plant.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex =
                            index; // Update the selected button index
                        selectedPlant =
                            plant[index]; // Update the text below the buttons
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CustomSize.sm)),
                    child: Text(plant[index],
                        style: Theme.of(context).textTheme.titleMedium?.apply(
                              color: selectedIndex == index
                                  ? Colors.red
                                  : Colors.white,
                            )),
                  );
                }),
              ),
            ),
            Text(selectedPlant)
          ],
        ),
      ),
    );
  }
}
