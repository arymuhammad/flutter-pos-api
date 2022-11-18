class DetailTrx {
 late int noTrx;
  late int kodeBarang;
  late String namaBarang;
  late int hargaJual;
  late int total;
  late int pembayaran;
  late int kembalian;
  late String tanggal;
  late int totalItem;

  DetailTrx(
      {required this.noTrx, required this.kodeBarang, required this.namaBarang, required this.hargaJual, 
      required this.total,
      required this.pembayaran,
      required this.kembalian,
      required this.tanggal,
      required this.totalItem
      });

  DetailTrx.fromJson(Map<String, dynamic> json) {
     noTrx = json['no_trx'];
    kodeBarang = json['kode_barang'];
    namaBarang = json['nama_barang'];
    hargaJual = json['harga_jual'];
    total = json['total'];
    pembayaran = json['pembayaran'];
    kembalian = json['kembalian'];
    tanggal = json['tanggal'];
    totalItem = json['total_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
     data['no_trx'] = noTrx;
    data['kode_barang'] = kodeBarang;
    data['nama_barang'] = namaBarang;
    data['harga_jual'] = hargaJual;
    data['total'] = total;
    data['pembayaran'] = pembayaran;
    data['kembalian'] = kembalian;
    data['tanggal'] = tanggal;
    data['total_item'] = totalItem;
    return data;
  }
}
