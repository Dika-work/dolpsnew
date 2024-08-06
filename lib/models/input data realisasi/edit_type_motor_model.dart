class EditTypeMotorModel {
  int id;
  int idPacking;
  String daerah;
  String typeMotor;
  String jumlah;

  EditTypeMotorModel({
    required this.id,
    required this.idPacking,
    required this.daerah,
    required this.typeMotor,
    required this.jumlah,
  });

  factory EditTypeMotorModel.fromJson(Map<String, dynamic> json) {
    return EditTypeMotorModel(
      id: json['id_realisasi'] ?? 0,
      idPacking: json['id_packing'] ?? 0,
      daerah: json['daerah'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      jumlah: json['jumlah'] ?? '',
    );
  }
}
