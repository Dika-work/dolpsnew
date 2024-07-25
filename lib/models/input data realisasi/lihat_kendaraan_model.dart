class LihatKendaraanModel {
  String noPolisi;
  String jenisKen;
  String supir;

  LihatKendaraanModel(
      {required this.noPolisi, required this.jenisKen, required this.supir});

  factory LihatKendaraanModel.fromJson(Map<String, dynamic> json) {
    return LihatKendaraanModel(
      noPolisi: json['no_polisi'] ?? '',
      jenisKen: json['jenis_ken'] ?? '',
      supir: json['supir'] ?? '',
    );
  }
}
