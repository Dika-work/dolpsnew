class HutangRegulerModel {
  int idHutang;
  int noRealisasiHutang;
  int hutangHLM;
  int hutangAc;
  int hutangKS;
  int hutangTS;
  int hutangBP;
  int hutangBS;
  int hutangPLT;
  int hutangStay;
  int hutangAcBesar;
  int hutangPlastik;

  HutangRegulerModel(
      {required this.idHutang,
      required this.noRealisasiHutang,
      required this.hutangHLM,
      required this.hutangAc,
      required this.hutangKS,
      required this.hutangTS,
      required this.hutangBP,
      required this.hutangBS,
      required this.hutangPLT,
      required this.hutangStay,
      required this.hutangAcBesar,
      required this.hutangPlastik});

  factory HutangRegulerModel.fromJson(Map<String, dynamic> json) {
    return HutangRegulerModel(
        idHutang: json['id_hutang_acc'] ?? 0,
        noRealisasiHutang: json['no_realisasi_hutang'] ?? 0,
        hutangHLM: json['hutang_hlm'] ?? 0,
        hutangAc: json['hutang_ac'] ?? 0,
        hutangKS: json['hutang_ks'] ?? 0,
        hutangTS: json['hutang_ts'] ?? 0,
        hutangBP: json['hutang_bp'] ?? 0,
        hutangBS: json['hutang_bs'] ?? 0,
        hutangPLT: json['hutang_plt'] ?? 0,
        hutangStay: json['hutang_stay'] ?? 0,
        hutangAcBesar: json['hutang_ac_besar'] ?? 0,
        hutangPlastik: json['hutang_plastik'] ?? 0);
  }
}

class AlatKelengkapanModel {
  int idDetail;
  int noRealisasi;
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

  AlatKelengkapanModel(
      {required this.idDetail,
      required this.noRealisasi,
      required this.hlm,
      required this.ac,
      required this.ks,
      required this.ts,
      required this.bp,
      required this.bs,
      required this.plt,
      required this.stay,
      required this.acBesar,
      required this.plastik});

  factory AlatKelengkapanModel.fromJson(Map<String, dynamic> json) {
    return AlatKelengkapanModel(
        idDetail: json['id_detail_packing'] ?? 0,
        noRealisasi: json['no_realisasi'] ?? 0,
        hlm: json['hlm_1'] ?? 0,
        ac: json['ac_1'] ?? 0,
        ks: json['ks_1'] ?? 0,
        ts: json['ts_1'] ?? 0,
        bp: json['bp_1'] ?? 0,
        bs: json['bs_1'] ?? 0,
        plt: json['plt_1'] ?? 0,
        stay: json['stay_1'] ?? 0,
        acBesar: json['ac_besar_1'] ?? 0,
        plastik: json['plastik_1'] ?? 0);
  }
}
