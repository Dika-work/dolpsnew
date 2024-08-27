class DoEstimasiAllModel {
  int id;
  String tgl;
  String jam;
  int jumlah1;
  int jumlah2;
  int jumlah3;
  int jumlah4;
  String user;
  String tglDo;
  String jumlahEstimasi;

  DoEstimasiAllModel({
    required this.id,
    required this.tgl,
    required this.jam,
    required this.jumlah1,
    required this.jumlah2,
    required this.jumlah3,
    required this.jumlah4,
    required this.user,
    required this.tglDo,
    required this.jumlahEstimasi,
  });

  factory DoEstimasiAllModel.fromJson(Map<String, dynamic> json) {
    return DoEstimasiAllModel(
        id: json['id'] ?? 0,
        tgl: json['tgl'] ?? '',
        jam: json['jam'] ?? '',
        jumlah1: json['jumlah_1'] ?? 0,
        jumlah2: json['jumlah_2'] ?? 0,
        jumlah3: json['jumlah_3'] ?? 0,
        jumlah4: json['jumlah_4'] ?? 0,
        user: json['user'] ?? '',
        tglDo: json['tgl_do'] ?? '',
        jumlahEstimasi: json['jumlah_estimasi'] ?? '');
  }
}
