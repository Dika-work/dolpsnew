class LaporanRealisasiModel {
  String tgl;
  int bulan;
  int tahun;
  int jumlahRealisasi;
  int jumlahHarian;
  int jumlahGlobal;

  LaporanRealisasiModel({
    required this.tgl,
    required this.bulan,
    required this.tahun,
    required this.jumlahRealisasi,
    required this.jumlahHarian,
    required this.jumlahGlobal,
  });

  factory LaporanRealisasiModel.fromJson(Map<String, dynamic> json) {
    return LaporanRealisasiModel(
      tgl: json['tgl'] ?? '',
      bulan: json['bulan'] ?? 0,
      tahun: json['tahun'] ?? 0,
      jumlahRealisasi: json['jumlah_realisasi'] ?? 0,
      jumlahHarian: json['jumlah_harian'] ?? 0,
      jumlahGlobal: json['jumlah_global'] ?? 0,
    );
  }
}
