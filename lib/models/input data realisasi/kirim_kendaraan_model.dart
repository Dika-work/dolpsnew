class KirimKendaraanModel {
  int id;
  int idReq;
  String plant;
  String tujuan;
  String plant2;
  String tujuan2;
  int type;
  String kendaraan;
  String noPolisi;
  String jenisKen;
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
      required this.idReq,
      required this.plant,
      required this.tujuan,
      required this.plant2,
      required this.tujuan2,
      required this.type,
      required this.kendaraan,
      required this.noPolisi,
      required this.jenisKen,
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
      idReq: json['id_request'] ?? 0,
      plant: json['plant'] ?? '',
      tujuan: json['tujuan'] ?? '',
      plant2: json['plant_2'] ?? '',
      tujuan2: json['tujuan_2'] ?? '',
      type: json['type'] ?? 0,
      kendaraan: json['kendaraan'] ?? '',
      noPolisi: json['no_polisi'] ?? '',
      jenisKen: json['jenis_ken'] ?? '',
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
