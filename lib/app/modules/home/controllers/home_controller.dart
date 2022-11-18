import 'package:get/get.dart';
import 'package:my_first_app/app/helper/db_helper.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  var url = ''.obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ipServer();
  }

  ipServer() async {
    await SQLHelper.instance.getIp().then((data) {
      url.value = data.toString();
      print(url);
    });
  }
}
