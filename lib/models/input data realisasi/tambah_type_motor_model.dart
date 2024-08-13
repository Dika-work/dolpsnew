class TambahTypeMotorModel {
  int id;
  String typeMotor;
  String daerah;
  int jumlahSRD;
  int jumlahMKS;
  int jumlahPTK;
  int jumlahBJM;

  TambahTypeMotorModel({
    required this.id,
    required this.typeMotor,
    required this.daerah,
    required this.jumlahSRD,
    required this.jumlahMKS,
    required this.jumlahPTK,
    required this.jumlahBJM,
  });

  factory TambahTypeMotorModel.fromJson(Map<String, dynamic> json) {
    return TambahTypeMotorModel(
        id: json['id'] ?? 0,
        typeMotor: json['type_motor'] ?? '',
        daerah: json['daerah'] ?? '',
        jumlahSRD: json['Jumlah_SRD'] ?? 0,
        jumlahMKS: json['Jumlah_MKS'] ?? 0,
        jumlahPTK: json['Jumlah_PTK'] ?? 0,
        jumlahBJM: json['Jumlah_BJM'] ?? 0);
  }
}

class FormFieldData {
  String? dropdownValue;
  String? textFieldValue;
}

class TambahTypeMotorMutasiModel {
  String typeMotor;
  String jumlahUnit;

  TambahTypeMotorMutasiModel(
      {required this.typeMotor, required this.jumlahUnit});

  factory TambahTypeMotorMutasiModel.fromJson(Map<String, dynamic> json) {
    return TambahTypeMotorMutasiModel(
        typeMotor: json['type_motor'] ?? '',
        jumlahUnit: json['Jumlah_M'] ?? '');
  }
}
