import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageUtil();
    final user = storage.getUserDetails();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Welcome ${user!.username}'),
          Text('Username: ${user.nama}'),
          Text('Tipe: ${user.tipe}'),
          Text('App: ${user.app}'),
          Text('Lihat: ${user.lihat}'),
          Text('Print: ${user.print}'),
          Text('Tambah: ${user.tambah}'),
          Text('Hapus: ${user.hapus}'),
          Text('Jumlah: ${user.jumlah}'),
          Text('Kirim: ${user.kirim}'),
          Text('Batal: ${user.batal}'),
          Text('Cek Unit: ${user.cekUnit}'),
          Text('Wilayah: ${user.wilayah}'),
          Text('Plant: ${user.plant}'),
          Text('Cek Regular: ${user.cekReguler}'),
          Text('Cek Mutasi: ${user.cekMutasi}'),
          Text('Acc1: ${user.acc1}'),
          Text('Acc2: ${user.acc2}'),
          Text('Acc3: ${user.acc3}'),
          Text('Menu1: ${user.menu1}'),
          Text('Menu2: ${user.menu2}'),
          Text('Menu3: ${user.menu3}'),
          Text('Menu4: ${user.menu4}'),
          Text('Menu5: ${user.menu5}'),
          Text('Menu6: ${user.menu6}'),
          Text('Menu7: ${user.menu7}'),
          Text('Menu8: ${user.menu8}'),
          Text('Menu9: ${user.menu9}'),
          Text('Menu10: ${user.menu10}'),
          Text('Gambar: ${user.gambar}'),
          Text('Online: ${user.online}'),
        ],
      ),
    );
  }
}
