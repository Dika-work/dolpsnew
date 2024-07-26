class KirimKendaraanModel {
  int id;
  String plant;
  String tujuan;
  String plant2;
  String tujuan2;
  String type;
  String kendaraan;
  String supir;
  String jam;
  String tgl;
  int bulan;
  int tahun;
  String user;
  int status;
  String lvKerusakaan;

  KirimKendaraanModel(
      {required this.id,
      required this.plant,
      required this.tujuan,
      required this.plant2,
      required this.tujuan2,
      required this.type,
      required this.kendaraan,
      required this.supir,
      required this.jam,
      required this.tgl,
      required this.bulan,
      required this.tahun,
      required this.user,
      required this.status,
      required this.lvKerusakaan});

  factory KirimKendaraanModel.fromJson(Map<String, dynamic> json) {
    return KirimKendaraanModel(
      id: json['id'] ?? 0,
      plant: json['plant'] ?? '',
      tujuan: json['tujuan'] ?? '',
      plant2: json['plant_2'] ?? '',
      tujuan2: json['tujuan_2'] ?? '',
      type: json['type'] ?? '',
      kendaraan: json['kendaraan'] ?? '',
      supir: json['supir'] ?? '',
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      bulan: json['bulan'] ?? 0,
      tahun: json['tahun'] ?? 0,
      user: json['user'] ?? '',
      status: json['status'] ?? 0,
      lvKerusakaan: json['lv_kerusakan'] ?? '',
    );
  }
}
