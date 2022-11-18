class MasterBarang {
  late int kodeBarang;
  late String namaBarang;
  late int hargaBarang;
  late int stok;
  late String tanggal;
  late int totalData;

  MasterBarang(
      {required this.kodeBarang,
      required this.namaBarang,
      required this.hargaBarang,
      required this.stok,
      required this.tanggal,
      required this.totalData
      });

  MasterBarang.fromJson(Map<String, dynamic> json) {
    kodeBarang = json['kode_barang'];
    namaBarang = json['nama_barang'];
    hargaBarang = json['harga_barang'];
    stok = json['stok'];
    tanggal = json['created_at'];
    totalData = json['total_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kode_barang'] = kodeBarang;
    data['nama_barang'] = namaBarang;
    data['harga_barang'] = hargaBarang;
    data['stok'] = stok;
    data['created_at'] = tanggal;
    data['total_data'] = totalData;
    return data;
  }
}
