class DoHarianModel {
  int idPlant;
  String tujuan;
  String tgl;
  String jam;
  int srd;
  int mks;
  int ptk;
  int bjm;
  int jumlah5;
  int jumlah6;
  String user;
  String plant;

  DoHarianModel({
    required this.idPlant,
    required this.tujuan,
    required this.tgl,
    required this.jam,
    required this.srd,
    required this.mks,
    required this.ptk,
    required this.bjm,
    required this.jumlah5,
    required this.jumlah6,
    required this.user,
    required this.plant,
  });

  factory DoHarianModel.fromJson(Map<String, dynamic> json) {
    return DoHarianModel(
      idPlant: json['id_plant'] ?? 0,
      tujuan: json['tujuan'] ?? '',
      tgl: json['tgl'] ?? '',
      jam: json['jam'] ?? '',
      srd: json['jumlah_1'] ?? 0,
      mks: json['jumlah_2'] ?? 0,
      ptk: json['jumlah_3'] ?? 0,
      bjm: json['jumlah_4'] ?? 0,
      jumlah5: json['jumlah_5'] ?? 0,
      jumlah6: json['jumlah_6'] ?? 0,
      user: json['user'] ?? '',
      plant: json['plant'] ?? '',
    );
  }
}
