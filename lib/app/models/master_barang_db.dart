class MasterBarangDb {
  int? kodeBarang;
  String? namaBarang;
  int? hargaBarang;
  int? stok;
  String? createdAt;

  MasterBarangDb({
    this.kodeBarang,
    this.namaBarang,
    this.hargaBarang,
    this.stok,
    this.createdAt,
  });

    MasterBarangDb.fromJson(Map<String, dynamic> json) {
    kodeBarang = json['kode_barang'];
    namaBarang = json['nama_barang'];
    hargaBarang = json['harga_barang'];
    stok = json['stok'];
    createdAt = json['createdAt'];
  }


  Map<String, dynamic> toMap() {
   final Map<String, dynamic> data = <String, dynamic>{};
    data['kode_barang'] = kodeBarang;
    data['nama_barang'] = namaBarang;
    data['harga_barang'] = hargaBarang;
    data['stok'] = stok;
    data['createdAt'] = createdAt;
    return data;
  }
}
