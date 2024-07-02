import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtil {
  final prefs = GetStorage();

  String getUsername() {
    return prefs.read('username');
  }

  String getName() {
    return prefs.read('nama');
  }

  String getTipe() {
    return prefs.read('tipe');
  }

  String getApp() {
    return prefs.read('app');
  }

  int getLihat() {
    return prefs.read('lihat');
  }

  int getPrint() {
    return prefs.read('print');
  }

  int getTambah() {
    return prefs.read('tambah');
  }

  int getEdit() {
    return prefs.read('edit');
  }

  int getHapus() {
    return prefs.read('hapus');
  }

  int getJumlah() {
    return prefs.read('jumlah');
  }

  int getKirim() {
    return prefs.read('kirim');
  }

  int getBatal() {
    return prefs.read('batal');
  }

  int getCekUnit() {
    return prefs.read('cek_unit');
  }

  int getWilayah() {
    return prefs.read('wilayah');
  }

  String getPlant() {
    return prefs.read('plant');
  }

  int getCekRegular() {
    return prefs.read('cek_reguler');
  }

  int getCekMutasi() {
    return prefs.read('cek_mutasi');
  }

  int getAcc1() {
    return prefs.read('acc_1');
  }

  int getAcc2() {
    return prefs.read('acc_2');
  }

  int getAcc3() {
    return prefs.read('acc_3');
  }

  int getMenu1() {
    return prefs.read('menu1');
  }

  int getMenu2() {
    return prefs.read('menu2');
  }

  int getMenu3() {
    return prefs.read('menu3');
  }

  int getMenu4() {
    return prefs.read('menu4');
  }

  int getMenu5() {
    return prefs.read('menu5');
  }

  int getMenu6() {
    return prefs.read('menu6');
  }

  int getMenu7() {
    return prefs.read('menu7');
  }

  int getMenu8() {
    return prefs.read('menu8');
  }

  int getMenu9() {
    return prefs.read('menu9');
  }

  int getMenu10() {
    return prefs.read('menu10');
  }

  String getGambar() {
    return prefs.read('gambar');
  }

  int getOnline() {
    return prefs.read('online');
  }

  void saveUserDetails({
    required String username,
    required String nama,
    required String tipe,
    required String app,
    required int lihat,
    required int print,
    required int tambah,
    required int edit,
    required int hapus,
    required int jumlah,
    required int kirim,
    required int batal,
    required int cekUnit,
    required int wilayah,
    required String plant,
    required int cekReguler,
    required int cekMutasi,
    required int acc1,
    required int acc2,
    required int acc3,
    required int menu1,
    required int menu2,
    required int menu3,
    required int menu4,
    required int menu5,
    required int menu6,
    required int menu7,
    required int menu8,
    required int menu9,
    required int menu10,
    required String gambar,
    required int online,
  }) {
    prefs.write('username', username);
    prefs.write('nama', nama);
    prefs.write('tipe', tipe);
    prefs.write('app', app);
    prefs.write('lihat', lihat);
    prefs.write('print', print);
    prefs.write('tambah', tambah);
    prefs.write('edit', edit);
    prefs.write('hapus', hapus);
    prefs.write('jumlah', jumlah);
    prefs.write('kirim', kirim);
    prefs.write('batal', batal);
    prefs.write('cek_unit', cekUnit);
    prefs.write('wilayah', wilayah);
    prefs.write('plant', plant);
    prefs.write('cek_reguler', cekReguler);
    prefs.write('cek_mutasi', cekMutasi);
    prefs.write('acc_1', acc1);
    prefs.write('acc_2', acc2);
    prefs.write('acc_3', acc3);
    prefs.write('menu1', menu1);
    prefs.write('menu2', menu2);
    prefs.write('menu3', menu3);
    prefs.write('menu4', menu4);
    prefs.write('menu5', menu5);
    prefs.write('menu6', menu6);
    prefs.write('menu7', menu7);
    prefs.write('menu8', menu8);
    prefs.write('menu9', menu9);
    prefs.write('menu10', menu10);
    prefs.write('gambar', gambar);
    prefs.write('online', online);
  }

  void logout() {
    prefs.remove('username');
    prefs.remove('nama');
    prefs.remove('tipe');
    prefs.remove('app');
    prefs.remove('lihat');
    prefs.remove('print');
    prefs.remove('tambah');
    prefs.remove('edit');
    prefs.remove('hapus');
    prefs.remove('jumlah');
    prefs.remove('kirim');
    prefs.remove('batal');
    prefs.remove('cek_unit');
    prefs.remove('wilayah');
    prefs.remove('plant');
    prefs.remove('cek_reguler');
    prefs.remove('cek_mutasi');
    prefs.remove('acc_1');
    prefs.remove('acc_2');
    prefs.remove('acc_3');
    prefs.remove('menu1');
    prefs.remove('menu2');
    prefs.remove('menu3');
    prefs.remove('menu4');
    prefs.remove('menu5');
    prefs.remove('menu6');
    prefs.remove('menu7');
    prefs.remove('menu8');
    prefs.remove('menu9');
    prefs.remove('menu10');
    prefs.remove('gambar');
    prefs.remove('online');
    Get.offAllNamed('/');

    SnackbarLoader.successSnackBar(
      title: 'Logged Out',
      message: 'Anda telah berhasil keluar.',
    );
  }
}
