class DetailTrxDb {
  int? noTrx;
  int? kodeBarang;
  String? namaBarang;
  int? hargaJual;
  int? stokAwal;
  int? totalItem;
  int? total;
  int? pembayaran;
  int? kembali;
  String? createdAt;

  DetailTrxDb(
      {this.noTrx,
      this.kodeBarang,
      this.namaBarang,
      this.hargaJual,
      this.stokAwal,
      this.totalItem,
      this.total,
      this.pembayaran,
      this.kembali,
      this.createdAt});

  DetailTrxDb.fromJson(Map<String, dynamic> json) {
    noTrx = json['no_trx'];
    kodeBarang = json['kode_barang'];
    namaBarang = json['nama_barang'];
    hargaJual = json['harga_jual'];
    stokAwal = json['stok_awal'];
    totalItem = json['total_item'];
    total = json['total'];
    pembayaran = json['pembayaran'];
    kembali = json['kembali'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_trx'] = noTrx;
    data['kode_barang'] = kodeBarang;
    data['nama_barang'] = namaBarang;
    data['harga_jual'] = hargaJual;
    data['stok_awal'] = stokAwal;
    data['total_item'] = totalItem;
    data['createdAt'] = createdAt;
    return data;
  }
}
