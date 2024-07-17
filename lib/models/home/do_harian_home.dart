class DoHarianHomeModel {
  int idPlant;
  String tujuan;
  String tgl;
  String jam;
  int jumlah;
  int srd;
  int mks;
  int ptk;
  int bjm;
  String plant;

  DoHarianHomeModel({
    required this.idPlant,
    required this.tujuan,
    required this.tgl,
    required this.jam,
    required this.jumlah,
    required this.srd,
    required this.mks,
    required this.ptk,
    required this.bjm,
    required this.plant,
  });

  factory DoHarianHomeModel.fromJson(Map<String, dynamic> json) {
    return DoHarianHomeModel(
      idPlant: json['id_plant'] ?? 0,
      tujuan: json['tujuan'] ?? '',
      tgl: json['tgl'] ?? '',
      jam: json['jam'] ?? '',
      jumlah: json['jumlah_harian'] ?? 0,
      srd: json['jumlah_srd'] ?? 0,
      mks: json['jumlah_mks'] ?? 0,
      ptk: json['jumlah_ptk'] ?? 0,
      bjm: json['jumlah_bjm'] ?? 0,
      plant: json['plant'] ?? '',
    );
  }
}
