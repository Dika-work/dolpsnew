class KendaraanModel {
  int idKendaraan;
  String noPolisi;
  String jenisKendaraan;
  String kapasitas;
  String merek;
  String type;
  String type2;
  String batangan;
  String wilayah;
  String karoseri;
  String hidrolik;
  String gps;
  String tahunRakit;
  String tahunBeli;
  String status;
  String kapasitasB;
  String kapasitasC;
  String plat;

  KendaraanModel({
    required this.idKendaraan,
    required this.noPolisi,
    required this.jenisKendaraan,
    required this.kapasitas,
    required this.merek,
    required this.type,
    required this.type2,
    required this.batangan,
    required this.wilayah,
    required this.karoseri,
    required this.hidrolik,
    required this.gps,
    required this.tahunRakit,
    required this.tahunBeli,
    required this.status,
    required this.kapasitasB,
    required this.kapasitasC,
    required this.plat,
  });

  factory KendaraanModel.fromJson(Map<String, dynamic> json) {
    return KendaraanModel(
      idKendaraan: json['id_kendaraan'] ?? 0,
      noPolisi: json['no_polisi'] ?? '',
      jenisKendaraan: json['jenis_ken'] ?? '',
      kapasitas: json['kapasitas'] ?? '',
      merek: json['merk'] ?? '',
      type: json['type'] ?? '',
      type2: json['type2'] ?? '',
      batangan: json['batangan'] ?? '',
      wilayah: json['wilayah'] ?? '',
      karoseri: json['karoseri'] ?? '',
      hidrolik: json['hidrolik'] ?? '',
      gps: json['gps'] ?? '',
      tahunRakit: json['tahun_rakit'] ?? '',
      tahunBeli: json['tahun_beli'] ?? '',
      status: json['status'] ?? '',
      kapasitasB: json['kapasitas_b'] ?? '',
      kapasitasC: json['kapasitas_c'] ?? '',
      plat: json['plat'] ?? '',
    );
  }
}
