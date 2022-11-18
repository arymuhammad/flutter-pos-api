import 'package:get/get.dart';

import '../controllers/historytransaksi_controller.dart';

class HistorytransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistorytransaksiController>(
      () => HistorytransaksiController(),
    );
  }
}
