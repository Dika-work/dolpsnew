import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtil {
  final prefs = GetStorage();

  String getUsername() {
    return prefs.read('username') ?? '';
  }

  String getName() {
    return prefs.read('nama') ?? '';
  }

  String getTipe() {
    return prefs.read('tipe') ?? '';
  }

  String getApp() {
    return prefs.read('app') ?? '';
  }

  String getLihat() {
    return prefs.read('lihat') ?? '';
  }

  String getPrint() {
    return prefs.read('print') ?? '';
  }

  String getTambah() {
    return prefs.read('tambah') ?? '';
  }

  String getEdit() {
    return prefs.read('edit') ?? '';
  }

  String getHapus() {
    return prefs.read('hapus') ?? '';
  }

  String getJumlah() {
    return prefs.read('jumlah') ?? '';
  }

  String getKirim() {
    return prefs.read('kirim') ?? '';
  }

  String getBatal() {
    return prefs.read('batal') ?? '';
  }

  String getCekUnit() {
    return prefs.read('cek_unit') ?? '';
  }

  String getWilayah() {
    return prefs.read('wilayah') ?? '';
  }

  String getPlant() {
    return prefs.read('plant') ?? '';
  }

  String getCekRegular() {
    return prefs.read('cek_reguler') ?? '';
  }

  String getCekMutasi() {
    return prefs.read('cek_mutasi') ?? '';
  }

  String getAcc1() {
    return prefs.read('acc_1') ?? '';
  }

  String getAcc2() {
    return prefs.read('acc_2') ?? '';
  }

  String getAcc3() {
    return prefs.read('acc_3') ?? '';
  }

  String getMenu1() {
    return prefs.read('menu1') ?? '';
  }

  String getMenu2() {
    return prefs.read('menu2') ?? '';
  }

  String getMenu3() {
    return prefs.read('menu3') ?? '';
  }

  String getMenu4() {
    return prefs.read('menu4') ?? '';
  }

  String getMenu5() {
    return prefs.read('menu5') ?? '';
  }

  String getMenu6() {
    return prefs.read('menu6') ?? '';
  }

  String getMenu7() {
    return prefs.read('menu7') ?? '';
  }

  String getMenu8() {
    return prefs.read('menu8') ?? '';
  }

  String getMenu9() {
    return prefs.read('menu9') ?? '';
  }

  String getMenu10() {
    return prefs.read('menu10') ?? '';
  }

  String getGambar() {
    return prefs.read('gambar') ?? '';
  }

  String getOnline() {
    return prefs.read('online') ?? '';
  }

  void saveUserDetails({
    required String username,
    required String nama,
    required String tipe,
    required String app,
    required String lihat,
    required String print,
    required String tambah,
    required String edit,
    required String hapus,
    required String jumlah,
    required String kirim,
    required String batal,
    required String cekUnit,
    required String wilayah,
    required String plant,
    required String cekReguler,
    required String cekMutasi,
    required String acc1,
    required String acc2,
    required String acc3,
    required String menu1,
    required String menu2,
    required String menu3,
    required String menu4,
    required String menu5,
    required String menu6,
    required String menu7,
    required String menu8,
    required String menu9,
    required String menu10,
    required String gambar,
    required String online,
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
