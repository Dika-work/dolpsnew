class TypeMotorModel {
  int idType;
  String merk;
  String typeMotor;
  int hlm;
  int ac;
  int ks;
  int ts;
  int bp;
  int bs;
  int plt;
  int stay;
  int acBesar;
  int plastik;

  TypeMotorModel({
    required this.idType,
    required this.merk,
    required this.typeMotor,
    required this.hlm,
    required this.ac,
    required this.ks,
    required this.ts,
    required this.bp,
    required this.bs,
    required this.plt,
    required this.stay,
    required this.acBesar,
    required this.plastik,
  });

  factory TypeMotorModel.fromJson(Map<String, dynamic> json) {
    return TypeMotorModel(
      idType: json['id_type'] ?? 0,
      merk: json['merk'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      hlm: json['hlm'] ?? '',
      ac: json['ac'] ?? '',
      ks: json['ks'] ?? 0,
      ts: json['ts'] ?? 0,
      bp: json['bp'] ?? 0,
      bs: json['bs'] ?? 0,
      plt: json['plt'] ?? 0,
      stay: json['stay'] ?? 0,
      acBesar: json['ac_besar'] ?? 0,
      plastik: json['plastik'] ?? 0,
    );
  }
}

class TypeMotorHondaModel {
  int idType;
  String merk;
  String typeMotor;
  int hlm;
  int ac;
  int ks;
  int ts;
  int bp;
  int bs;
  int plt;
  int stay;
  int acBesar;
  int plastik;

  TypeMotorHondaModel({
    required this.idType,
    required this.merk,
    required this.typeMotor,
    required this.hlm,
    required this.ac,
    required this.ks,
    required this.ts,
    required this.bp,
    required this.bs,
    required this.plt,
    required this.stay,
    required this.acBesar,
    required this.plastik,
  });

  factory TypeMotorHondaModel.fromJson(Map<String, dynamic> json) {
    return TypeMotorHondaModel(
      idType: json['id_type'] ?? 0,
      merk: json['merk'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      hlm: json['hlm'] ?? '',
      ac: json['ac'] ?? '',
      ks: json['ks'] ?? 0,
      ts: json['ts'] ?? 0,
      bp: json['bp'] ?? 0,
      bs: json['bs'] ?? 0,
      plt: json['plt'] ?? 0,
      stay: json['stay'] ?? 0,
      acBesar: json['ac_besar'] ?? 0,
      plastik: json['plastik'] ?? 0,
    );
  }
}
