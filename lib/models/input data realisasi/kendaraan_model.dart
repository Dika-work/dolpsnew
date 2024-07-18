class KendaraanModel {
  int idKendaraan;
  String noPolisi;
  String jenisKendaraan;
  String kapasitas;
  String merek;
  String type;

  KendaraanModel({
    required this.idKendaraan,
    required this.noPolisi,
    required this.jenisKendaraan,
    required this.kapasitas,
    required this.merek,
    required this.type,
  });

  factory KendaraanModel.fromJson(Map<String, dynamic> json) {
    return KendaraanModel(
      idKendaraan: json['id_kendaraan'] ?? 0,
      noPolisi: json['no_polisi'] ?? '',
      jenisKendaraan: json['jenis_ken'] ?? '',
      kapasitas: json['kapasitas'] ?? '',
      merek: json['merk'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
