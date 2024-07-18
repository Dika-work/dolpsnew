class RequestKendaraanModel {
  int idReq;
  String pengurus;
  String tgl;
  String jam;
  String plant;
  String tujuan;
  int type;
  String jenis;
  int jumlah;
  int statusReq;
  String inisialDepan;
  String inisitalBelakang;

  RequestKendaraanModel({
    required this.idReq,
    required this.pengurus,
    required this.tgl,
    required this.jam,
    required this.plant,
    required this.tujuan,
    required this.type,
    required this.jenis,
    required this.jumlah,
    required this.statusReq,
    required this.inisialDepan,
    required this.inisitalBelakang,
  });

  factory RequestKendaraanModel.fromJson(Map<String, dynamic> json) {
    return RequestKendaraanModel(
      idReq: json['id_req'] ?? '',
      pengurus: json['nama_pengurus'] ?? '',
      tgl: json['tgl_req'] ?? '',
      jam: json['jam_req'] ?? '',
      plant: json['plant_req'] ?? '',
      tujuan: json['tujuan_req'] ?? '',
      type: json['type_req'] ?? '',
      jenis: json['jenis_req'] ?? '',
      jumlah: json['jumlah_req'] ?? '',
      statusReq: json['status_req'] ?? 0,
      inisialDepan: json['inisial_depan'] ?? '',
      inisitalBelakang: json['inisial_belakang'] ?? '',
    );
  }
}
