class AksesorisModel {
  int idRealisasi;
  int idRequest;
  int type;
  String plant;
  String tujuan;
  String noPolisi;
  String jenisKen;
  int jumlahUnit;
  int status;
  String jam;
  String user;
  String userPengurus;
  int accHLM;
  int accAC;
  int accKS;
  int accTS;
  int accBP;
  int accBS;
  int accPLT;
  int accSTAY;
  int accAcBesar;
  int accPlastik;

  AksesorisModel({
    required this.idRealisasi,
    required this.idRequest,
    required this.type,
    required this.plant,
    required this.tujuan,
    required this.noPolisi,
    required this.jenisKen,
    required this.jumlahUnit,
    required this.status,
    required this.jam,
    required this.user,
    required this.userPengurus,
    required this.accHLM,
    required this.accAC,
    required this.accKS,
    required this.accTS,
    required this.accBP,
    required this.accBS,
    required this.accPLT,
    required this.accSTAY,
    required this.accAcBesar,
    required this.accPlastik,
  });

  factory AksesorisModel.fromJson(Map<String, dynamic> json) {
    return AksesorisModel(
      idRealisasi: json['id_realisai'] ?? 0,
      idRequest: json['type_motor'] ?? 0,
      type: json['type'] ?? 0,
      plant: json['plant'] ?? '',
      tujuan: json['tujuan'] ?? '',
      noPolisi: json['no_polisi'] ?? '',
      jenisKen: json['jenis_ken'] ?? '',
      jumlahUnit: json['jumlah_unit'] ?? 0,
      status: json['status'] ?? 0,
      jam: json['jam'] ?? '',
      user: json['user'] ?? '',
      userPengurus: json['user_pengurus'] ?? '',
      accHLM: json['acc_hlm'] ?? 0,
      accAC: json['acc_ac'] ?? 0,
      accKS: json['acc_ks'] ?? 0,
      accTS: json['acc_ts'] ?? 0,
      accBP: json['acc_bp'] ?? 0,
      accBS: json['acc_bs'] ?? 0,
      accPLT: json['acc_plt'] ?? 0,
      accSTAY: json['acc_stay'] ?? 0,
      accAcBesar: json['acc_ac_besar'] ?? 0,
      accPlastik: json['acc_plastik'] ?? 0,
    );
  }
}
