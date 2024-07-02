class DataUserModel {
  String username;
  String nama;
  String tipe;
  String app;
  int lihat;
  int print;
  int tambah;
  int edit;
  int hapus;
  int jumlah;
  int kirim;
  int batal;
  int cekUnit;
  String wilayah;
  String plant;
  int cekReguler;
  int cekMutasi;
  int acc1;
  int acc2;
  int acc3;
  int menu1;
  int menu2;
  int menu3;
  int menu4;
  int menu5;
  int menu6;
  int menu7;
  int menu8;
  int menu9;
  int menu10;
  String gambar;
  int online;

  DataUserModel({
    required this.username,
    required this.nama,
    required this.tipe,
    required this.app,
    required this.lihat,
    required this.print,
    required this.tambah,
    required this.edit,
    required this.hapus,
    required this.jumlah,
    required this.kirim,
    required this.batal,
    required this.cekUnit,
    required this.wilayah,
    required this.plant,
    required this.cekReguler,
    required this.cekMutasi,
    required this.acc1,
    required this.acc2,
    required this.acc3,
    required this.menu1,
    required this.menu2,
    required this.menu3,
    required this.menu4,
    required this.menu5,
    required this.menu6,
    required this.menu7,
    required this.menu8,
    required this.menu9,
    required this.menu10,
    required this.gambar,
    required this.online,
  });

  factory DataUserModel.fromJson(Map<String, dynamic> json) {
    return DataUserModel(
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      tipe: json['tipe'] ?? '',
      app: json['app'] ?? '',
      lihat: json['lihat'] ?? 0,
      print: json['print'] ?? 0,
      tambah: json['tambah'] ?? 0,
      edit: json['edit'] ?? 0,
      hapus: json['hapus'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
      kirim: json['kirim'] ?? 0,
      batal: json['batal'] ?? 0,
      cekUnit: json['cek_unit'] ?? 0,
      wilayah: json['wilayah'] ?? '',
      plant: json['plant'] ?? '',
      cekReguler: json['cek_reguler'] ?? 0,
      cekMutasi: json['cek_mutasi'] ?? 0,
      acc1: json['acc_1'] ?? 0,
      acc2: json['acc_2'] ?? 0,
      acc3: json['acc_3'] ?? 0,
      menu1: json['menu1'] ?? 0,
      menu2: json['menu2'] ?? 0,
      menu3: json['menu3'] ?? 0,
      menu4: json['menu4'] ?? 0,
      menu5: json['menu5'] ?? 0,
      menu6: json['menu6'] ?? 0,
      menu7: json['menu7'] ?? 0,
      menu8: json['menu8'] ?? 0,
      menu9: json['menu9'] ?? 0,
      menu10: json['menu10'] ?? 0,
      gambar: json['gambar'] ?? '',
      online: json['online'] ?? 0,
    );
  }
}
