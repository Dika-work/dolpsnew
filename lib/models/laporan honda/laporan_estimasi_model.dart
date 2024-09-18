class LaporanEstimasiModel {
  String tgl;
  int estimasiSRD;
  int estimasiMKS;
  int estimasiPTK;
  int doEstimasi;
  int doHarian;

  LaporanEstimasiModel({
    required this.tgl,
    required this.estimasiSRD,
    required this.estimasiMKS,
    required this.estimasiPTK,
    required this.doEstimasi,
    required this.doHarian,
  });

  factory LaporanEstimasiModel.fromJson(Map<String, dynamic> json) {
    return LaporanEstimasiModel(
      tgl: json['tgl'] ?? '',
      estimasiSRD: json['jumlah_1'] ?? 0,
      estimasiMKS: json['jumlah_2'] ?? 0,
      estimasiPTK: json['jumlah_3'] ?? 0,
      doEstimasi: json['jumlah_estimasi'] ?? 0,
      doHarian: json['jumlah_do'] ?? 0,
    );
  }
}
