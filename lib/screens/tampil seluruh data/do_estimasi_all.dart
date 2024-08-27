import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AllDoEstimasi extends StatelessWidget {
  const AllDoEstimasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text('Data DO Estimasi',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: null, icon: Icon(Iconsax.add_circle)),
                Text('Tambah Data')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
