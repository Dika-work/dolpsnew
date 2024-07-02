import 'package:doplsnew/controllers/data_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/source/data_user_source.dart';

class DataUserScreen extends GetView<DataUserController> {
  const DataUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isDataUserLoading.value &&
              controller.dataUserModel.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.dataUserModel.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return PaginatedDataTable(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Data User',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Iconsax.user_add))
                ],
              ),
              columns: const [
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Tipe')),
                DataColumn(label: Text('App')),
                DataColumn(label: Text('Lihat')),
                DataColumn(label: Text('Print')),
                DataColumn(label: Text('Tambah')),
                DataColumn(label: Text('Edit')),
                DataColumn(label: Text('Hapus')),
                DataColumn(label: Text('Jumlah')),
                DataColumn(label: Text('Kirim')),
                DataColumn(label: Text('Batal')),
                DataColumn(label: Text('Cek Unit')),
                DataColumn(label: Text('Wilayah')),
                DataColumn(label: Text('Plant')),
                DataColumn(label: Text('Cek Reguler')),
                DataColumn(label: Text('Cek Mutasi')),
                DataColumn(label: Text('Acc1')),
                DataColumn(label: Text('Acc2')),
                DataColumn(label: Text('Acc3')),
                DataColumn(label: Text('Menu1')),
                DataColumn(label: Text('Menu2')),
                DataColumn(label: Text('Menu3')),
                DataColumn(label: Text('Menu4')),
                DataColumn(label: Text('Menu5')),
                DataColumn(label: Text('Menu6')),
                DataColumn(label: Text('Menu7')),
                DataColumn(label: Text('Menu8')),
                DataColumn(label: Text('Menu9')),
                DataColumn(label: Text('Menu10')),
                DataColumn(label: Text('Gambar')),
                DataColumn(label: Text('Online')),
                DataColumn(label: Text('Action')),
              ],
              source: DataUserDataSource(controller, context),
            );
          }
        }),
      ),
    );
  }
}
