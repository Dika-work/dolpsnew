class LaporanDOModel {
  LaporanDOModel(this.region, this.totalDO, this.realisasiDO, this.unfilledDO);

  final String region;
  final List<int> totalDO;
  final List<int> realisasiDO;
  final List<int> unfilledDO;
}
