// class UserModel {
//   String username;
//   String password;
//   String nama;
//   String tipe;
//   String app;
//   String lihat;
//   String print;
//   String tambah;
//   String edit;
//   String hapus;
//   String jumlah;
//   String kirim;
//   String batal;
//   String cekUnit;
//   String wilayah;
//   String plant;
//   String cekReguler;
//   String cekMutasi;
//   String acc1;
//   String acc2;
//   String acc3;
//   String menu1;
//   String menu2;
//   String menu3;
//   String menu4;
//   String menu5;
//   String menu6;
//   String menu7;
//   String menu8;
//   String menu9;
//   String menu10;
//   String gambar;
//   String online;

//   UserModel({
//     required this.username,
//     required this.password,
//     required this.nama,
//     required this.tipe,
//     required this.app,
//     required this.lihat,
//     required this.print,
//     required this.tambah,
//     required this.edit,
//     required this.hapus,
//     required this.jumlah,
//     required this.kirim,
//     required this.batal,
//     required this.cekUnit,
//     required this.wilayah,
//     required this.plant,
//     required this.cekReguler,
//     required this.cekMutasi,
//     required this.acc1,
//     required this.acc2,
//     required this.acc3,
//     required this.menu1,
//     required this.menu2,
//     required this.menu3,
//     required this.menu4,
//     required this.menu5,
//     required this.menu6,
//     required this.menu7,
//     required this.menu8,
//     required this.menu9,
//     required this.menu10,
//     required this.gambar,
//     required this.online,
//   });

//   static UserModel empty() => UserModel(
//         username: '',
//         password: '',
//         nama: '',
//         tipe: '',
//         app: '',
//         lihat: '',
//         print: '',
//         tambah: '',
//         edit: '',
//         hapus: '',
//         jumlah: '',
//         kirim: '',
//         batal: '',
//         cekUnit: '',
//         wilayah: '',
//         plant: '',
//         cekReguler: '',
//         cekMutasi: '',
//         acc1: '',
//         acc2: '',
//         acc3: '',
//         menu1: '',
//         menu2: '',
//         menu3: '',
//         menu4: '',
//         menu5: '',
//         menu6: '',
//         menu7: '',
//         menu8: '',
//         menu9: '',
//         menu10: '',
//         gambar: '',
//         online: '',
//       );

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       username: json['username'] ?? '',
//       password: json['password'] ?? '',
//       nama: json['nama'] ?? '',
//       tipe: json['tipe'] ?? '',
//       app: json['app'] ?? '',
//       lihat: json['lihat'] ?? '',
//       print: json['print'] ?? '',
//       tambah: json['tambah'] ?? '',
//       edit: json['edit'] ?? '',
//       hapus: json['hapus'] ?? '',
//       jumlah: json['jumlah'] ?? '',
//       kirim: json['kirim'] ?? '',
//       batal: json['batal'] ?? '',
//       cekUnit: json['cek_unit'] ?? '',
//       wilayah: json['wilayah'] ?? '',
//       plant: json['plant'] ?? '',
//       cekReguler: json['cek_reguler'] ?? '',
//       cekMutasi: json['cek_mutasi'] ?? '',
//       acc1: json['acc_1'] ?? '',
//       acc2: json['acc_2'] ?? '',
//       acc3: json['acc_3'] ?? '',
//       menu1: json['menu1'] ?? '',
//       menu2: json['menu2'] ?? '',
//       menu3: json['menu3'] ?? '',
//       menu4: json['menu4'] ?? '',
//       menu5: json['menu5'] ?? '',
//       menu6: json['menu6'] ?? '',
//       menu7: json['menu7'] ?? '',
//       menu8: json['menu8'] ?? '',
//       menu9: json['menu9'] ?? '',
//       menu10: json['menu10'] ?? '',
//       gambar: json['gambar'] ?? '',
//       online: json['online'] ?? '',
//     );
//   }
// }
