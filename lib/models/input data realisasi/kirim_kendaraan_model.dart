class KirimKendaraanModel {
  String plant;
  String type;
  String kendaraan;
  String jenisKendaraan;
  String status;
  String lvKerusakaan;
  String supir;

  KirimKendaraanModel({
    required this.plant,
    required this.type,
    required this.kendaraan,
    required this.jenisKendaraan,
    required this.status,
    required this.lvKerusakaan,
    required this.supir,
  });

  factory KirimKendaraanModel.fromJson(Map<String, dynamic> json) {
    return KirimKendaraanModel(
      plant: json['plant'] ?? '',
      type: json['type'] ?? '',
      kendaraan: json['kendaraan'] ?? '',
      jenisKendaraan: json['jenis_ken'] ?? '',
      status: json['status'] ?? '',
      lvKerusakaan: json['lv_kerusakaan'] ?? '',
      supir: json['supir'] ?? '',
    );
  }
}
