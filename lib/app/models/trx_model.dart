class Trx {
  late int totalTrx;
  late int noTrx;
  late int total;
  late String tanggal;
  late int pcs;

  Trx(
      {
      required this.totalTrx,
      required this.noTrx,
      required this.total,
      required this.tanggal,
      required this.pcs});

  Trx.fromJson(Map<String, dynamic> json) {
    totalTrx = json['total_trx'];
    noTrx = json['no_trx'];
    total = json['total'];
    tanggal = json['tanggal'];
    pcs = json['pcs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['total_trx'] = totalTrx;
    data['no_trx'] = noTrx;
    data['total'] = total;
    data['tanggal'] = tanggal;
    data['pcs'] = pcs;
    return data;
  }
}
