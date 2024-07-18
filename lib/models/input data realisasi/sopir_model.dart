class SopirModel {
  int id;
  String nama;
  String namaPanggilan;
  String namaDivisi;

  SopirModel({
    required this.id,
    required this.nama,
    required this.namaPanggilan,
    required this.namaDivisi,
  });

  factory SopirModel.fromJson(Map<String, dynamic> json) {
    return SopirModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      namaPanggilan: json['nama_panggilan'] ?? '',
      namaDivisi: json['nama_divisi'] ?? '',
    );
  }
}
