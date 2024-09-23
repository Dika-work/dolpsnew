class LaporanDealerModel {
  String tgl;
  String daerah;
  int jumlah;
  String sumberData;

  LaporanDealerModel(
      {required this.tgl,
      required this.daerah,
      required this.jumlah,
      required this.sumberData});

  factory LaporanDealerModel.fromJson(Map<String, dynamic> json) {
    return LaporanDealerModel(
        tgl: json['tgl'] ?? '',
        daerah: json['daerah'] ?? '',
        jumlah: json['jumlah'] ?? 0,
        sumberData: json['sumber'] ?? '');
  }
}
