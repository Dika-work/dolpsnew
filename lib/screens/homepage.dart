import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageUtil();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Welcome ${storage.getUsername()}'),
          Text('Username: ${storage.getName()}'),
          Text('Tipe: ${storage.getTipe()}'),
          Text('App: ${storage.getApp()}'),
          Text('Lihat: ${storage.getLihat()}'),
          Text('Print: ${storage.getPrint()}'),
          Text('Tambah: ${storage.getTambah()}'),
          Text('Hapus: ${storage.getHapus()}'),
          Text('Jumlah: ${storage.getJumlah()}'),
          Text('Kirim: ${storage.getKirim()}'),
          Text('Batal: ${storage.getBatal()}'),
          Text('Cek Unit: ${storage.getCekUnit()}'),
          Text('Wilayah: ${storage.getWilayah()}'),
          Text('Plant: ${storage.getPlant()}'),
          Text('Cek Regular: ${storage.getCekRegular()}'),
          Text('Cek Mutasi: ${storage.getCekMutasi()}'),
          Text('Acc1: ${storage.getAcc1()}'),
          Text('Acc2: ${storage.getAcc2()}'),
          Text('Acc3: ${storage.getAcc3()}'),
          Text('Menu1: ${storage.getMenu1()}'),
          Text('Menu2: ${storage.getMenu2()}'),
          Text('Menu3: ${storage.getMenu3()}'),
          Text('Menu4: ${storage.getMenu4()}'),
          Text('Menu5: ${storage.getMenu5()}'),
          Text('Menu6: ${storage.getMenu6()}'),
          Text('Menu7: ${storage.getMenu7()}'),
          Text('Menu8: ${storage.getMenu8()}'),
          Text('Menu9: ${storage.getMenu9()}'),
          Text('Menu10: ${storage.getMenu10()}'),
          Text('Gambar: ${storage.getGambar()}'),
          Text('Online: ${storage.getOnline()}'),
        ],
      ),
    );
  }
}
