class TrxDb {
  int? noTrx;
  int? total;
  int? pembayaran;
  int? kembali;
  String? tanggal;
  int? totalsales;
  int? totalitem;
  String? createdAt;
  TrxDb({
    this.noTrx,
    this.total,
    this.pembayaran,
    this.kembali,
    this.tanggal,
    this.totalsales,
    this.totalitem,
    this.createdAt,
  });

  TrxDb.fromJson(Map<String, dynamic> json) {
    noTrx = json['no_trx'];
    total = json['total'];
    pembayaran = json['pembayaran'];
    kembali = json['kembali'];
    tanggal = json['tanggal'];
    totalsales = json['total_sales'];
    totalitem = json['total_item'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_trx'] = noTrx;
    data['total'] = total;
    data['pembayaran'] = pembayaran;
    data['kembali'] = kembali;
    data['tanggal'] = tanggal;
    data['createdAt'] = createdAt;
    return data;
  }
}
