class LaporanPlantModel {
  String tgl;
  String bulan;
  String tahun;
  int totalHarianSRD;
  int totalHarianMKS;
  int totalHarianPTK;
  int totalHarianBJM;
  String plant;

  LaporanPlantModel({
    required this.tgl,
    required this.bulan,
    required this.tahun,
    required this.totalHarianSRD,
    required this.totalHarianMKS,
    required this.totalHarianPTK,
    required this.totalHarianBJM,
    required this.plant,
  });

  factory LaporanPlantModel.fromJson(Map<String, dynamic> json) {
    return LaporanPlantModel(
        tgl: json['tgl'] ?? '',
        bulan: json['bulan'] ?? '',
        tahun: json['tahun'] ?? '',
        totalHarianSRD: json['jumlah_srd'] ?? 0,
        totalHarianMKS: json['jumlah_mks'] ?? 0,
        totalHarianPTK: json['jumlah_ptk'] ?? 0,
        totalHarianBJM: json['jumlah_bjm'] ?? 0,
        plant: json['plant'] ?? '');
  }
}

class LaporanDoRealisasiModel {
  String plant;
  String tgl;
  String bulan;
  String tahun;
  String daerah;
  int jumlahMotor;

  LaporanDoRealisasiModel({
    required this.plant,
    required this.tgl,
    required this.bulan,
    required this.tahun,
    required this.daerah,
    required this.jumlahMotor,
  });

  factory LaporanDoRealisasiModel.fromJson(Map<String, dynamic> json) {
    return LaporanDoRealisasiModel(
        plant: json['plant'] ?? '',
        tgl: json['tgl'] ?? '',
        bulan: json['bulan'] ?? '',
        tahun: json['tahun'] ?? '',
        daerah: json['daerah'] ?? '',
        jumlahMotor: json['jumlah_motor'] ?? 0);
  }
}
