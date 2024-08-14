class DoRealisasiModel {
  int id;
  int idReq;
  String plant;
  String tujuan;
  String plant2;
  String tujuan2;
  int type;
  String kendaraan;
  String supir;
  String jam;
  String tgl;
  int bulan;
  int tahun;
  String user;
  String userPengurus;
  int jumlahUnit;
  String edit;
  int status;
  String statusPengiriman;
  String tgl2;
  String userUbah;
  String statusMemo;
  String gabungan;
  String tglReal;
  String noPolisi;
  String jenisKen;
  String kapasitas;
  String merk;
  String nama;
  String lokasi;
  String plantDo;
  String namaDepan;
  String? namaTengah;
  String namaBelakang;
  String inisialDepan;
  String inisialBelakang;
  String namaPanggilan;
  int hutangHelm;
  int hutangAc;
  int hutangKs;
  int hutangTs;
  int hutangBp;
  int hutangBs;
  int hutangPlt;
  int hutangStay;
  int hutangAcBesar;
  int hutangPlastik;
  String? klasifikasi;
  int statusAnalisa;
  int statusKerusakan;
  int totalHutang;

  DoRealisasiModel({
    required this.id,
    required this.idReq,
    required this.plant,
    required this.tujuan,
    required this.plant2,
    required this.tujuan2,
    required this.type,
    required this.kendaraan,
    required this.supir,
    required this.jam,
    required this.tgl,
    required this.bulan,
    required this.tahun,
    required this.user,
    required this.userPengurus,
    required this.jumlahUnit,
    required this.edit,
    required this.status,
    required this.statusPengiriman,
    required this.tgl2,
    required this.userUbah,
    required this.statusMemo,
    required this.gabungan,
    required this.tglReal,
    required this.noPolisi,
    required this.jenisKen,
    required this.kapasitas,
    required this.merk,
    required this.nama,
    required this.lokasi,
    required this.plantDo,
    required this.namaDepan,
    this.namaTengah,
    required this.namaBelakang,
    required this.inisialDepan,
    required this.inisialBelakang,
    required this.namaPanggilan,
    required this.hutangHelm,
    required this.hutangAc,
    required this.hutangKs,
    required this.hutangTs,
    required this.hutangBp,
    required this.hutangBs,
    required this.hutangPlt,
    required this.hutangStay,
    required this.hutangAcBesar,
    required this.hutangPlastik,
    required this.klasifikasi,
    required this.statusAnalisa,
    required this.statusKerusakan,
    required this.totalHutang,
  });

  factory DoRealisasiModel.fromJson(Map<String, dynamic> json) {
    return DoRealisasiModel(
        id: json['id'] ?? 0,
        idReq: json['id_request'] ?? 0,
        plant: json['plant'] ?? '',
        tujuan: json['tujuan'] ?? '',
        plant2: json['plant_2'] ?? '',
        tujuan2: json['tujuan_2'] ?? '',
        type: json['type'] ?? 0,
        kendaraan: json['kendaraan'] ?? '',
        supir: json['supir'] ?? '',
        jam: json['jam'] ?? '',
        tgl: json['tgl'] ?? '',
        bulan: json['bulan'] ?? 0,
        tahun: json['tahun'] ?? 0,
        user: json['user'] ?? '',
        userPengurus: json['user_pengurus'] ?? '',
        jumlahUnit: json['jumlah_unit'] ?? 0,
        edit: json['edit'] ?? '',
        status: json['status'] ?? 0,
        statusPengiriman: json['status_pengiriman'] ?? '',
        tgl2: json['tgl2'] ?? '',
        userUbah: json['user_ubah'],
        statusMemo: json['status_memo'] ?? '',
        gabungan: json['gabungan'] ?? '',
        tglReal: json['tgl_real'] ?? '',
        noPolisi: json['no_polisi'] ?? '',
        jenisKen: json['jenis_ken'] ?? '',
        kapasitas: json['kapasitas'] ?? '',
        merk: json['merk'] ?? '',
        nama: json['nama'] ?? '',
        lokasi: json['lokasi'] ?? '',
        plantDo: json['plant_do'] ?? '',
        namaDepan: json['nama_depan'] ?? '',
        namaTengah: json['nama_tengah'],
        namaBelakang: json['nama_belakang'] ?? '',
        inisialDepan: json['inisial_depan'] ?? '',
        inisialBelakang: json['inisial_belakang'] ?? '',
        namaPanggilan: json['nama_panggilan'] ?? '',
        hutangHelm: json['hutang_hlm'] ?? 0,
        hutangAc: json['hutang_ac'] ?? 0,
        hutangKs: json['hutang_ks'] ?? 0,
        hutangTs: json['hutang_ts'] ?? 0,
        hutangBp: json['hutang_bp'] ?? 0,
        hutangBs: json['hutang_bs'] ?? 0,
        hutangPlt: json['hutang_plt'] ?? 0,
        hutangStay: json['hutang_stay'] ?? 0,
        hutangAcBesar: json['hutang_ac_besar'] ?? 0,
        hutangPlastik: json['hutang_plastik'] ?? 0,
        klasifikasi: json['klasifikasi'],
        statusAnalisa: json['status_analisa'] ?? 0,
        statusKerusakan: json['status_kerusakan'] ?? 0,
        totalHutang: json['total_hutang'] ?? 0);
  }
}
