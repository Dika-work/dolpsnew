class SamarindaModel {
  int bulan;
  int tahun;
  String sumberData;
  int hasil;

  SamarindaModel(
      {required this.bulan,
      required this.tahun,
      required this.sumberData,
      required this.hasil});

  factory SamarindaModel.fromJson(Map<String, dynamic> json) {
    return SamarindaModel(
        bulan: json['bulan'] ?? 0,
        tahun: json['tahun'] ?? 0,
        sumberData: json['sumber_data'] ?? '',
        hasil: json['hasil'] ?? 0);
  }
}
