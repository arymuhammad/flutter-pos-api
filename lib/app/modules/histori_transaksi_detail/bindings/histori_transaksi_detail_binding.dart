import 'package:get/get.dart';

import '../controllers/histori_transaksi_detail_controller.dart';

class HistoriTransaksiDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoriTransaksiDetailController>(
      () => HistoriTransaksiDetailController(),
    );
  }
}
