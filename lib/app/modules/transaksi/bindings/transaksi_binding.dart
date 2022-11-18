import 'package:get/get.dart';

import '../controllers/transaksi_controller.dart';

class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransaksiController>(
      () => TransaksiController(),
    );
  }
}
