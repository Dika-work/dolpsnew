class EstimasiPengambilanModel {
  int idPlant;
  String tujuan;
  int type;
  String jenisKen;
  int jumlah;
  String user;
  String jam;
  String tgl;
  int status;
  String plant1;

  EstimasiPengambilanModel({
    required this.idPlant,
    required this.tujuan,
    required this.type,
    required this.jenisKen,
    required this.jumlah,
    required this.user,
    required this.jam,
    required this.tgl,
    required this.status,
    required this.plant1,
  });

  factory EstimasiPengambilanModel.fromJson(Map<String, dynamic> json) {
    return EstimasiPengambilanModel(
        idPlant: json['plant'] ?? 0,
        tujuan: json['tujuan'] ?? '',
        type: json['type'] ?? 0,
        jenisKen: json['jenis'] ?? '',
        jumlah: json['jumlah'] ?? 0,
        user: json['user'] ?? '',
        jam: json['jam'] ?? '',
        tgl: json['tgl'] ?? '',
        status: json['status'] ?? 0,
        plant1: json['plant1'] ?? '');
  }
}
