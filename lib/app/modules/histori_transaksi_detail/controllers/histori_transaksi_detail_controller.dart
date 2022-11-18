import 'dart:convert';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import '../../../helper/db_helper.dart';
import '../../../models/detail_trx_model.dart';
import '../../../models/detail_trx_model_db.dart';
import '../../../service/app_exceptions.dart';
import '../../../service/base_client.dart';

class HistoriTransaksiDetailController extends GetxController {
  var detailHistoryTrx = <DetailTrx>[].obs;
  // var dbHistoryTrx = <DetailTrxDb>[].obs;
  var isLoading = true.obs;
  final count = 0.obs;
  var uri = '';
  var param = Get.arguments;
  // var url = 'http://103.112.139.155/api-pos';

  var isDiscovering = false.obs;
  String localIp = '192.168.100.15';
  List devices = [].obs;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');

  // FlutterBlue flutterBlue = FlutterBlue.instance;
  // List<ScanResult>? scanResult;

  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  // var connected = true.obs;
  // var deviceBt = <BluetoothDevice>[].obs;
  // String tips = "";

  @override
  void onInit() {
    super.onInit();
    fetchDetailTrx(param['notrx']);
    // findDevices();
    // WidgetsBinding.instance.addPostFrameCallback((_) => {initBluetooth()});
  }

  Future<List<DetailTrx>> fetchDetailTrx(noTrx) async {
    // Future<List<DetailTrx>> fetchDetHistoryTrx(noTrx) async {
    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await BaseClient()
        .get('http://$uri/api-pos', '/transaksi/detail_history.php?no_trx=$noTrx')
        .catchError(handleError);

    List<dynamic> dataDetTrx = json.decode(response)['rows'];
    print(dataDetTrx);
    List<DetailTrx> detailtrx =
        dataDetTrx.map((e) => DetailTrx.fromJson(e)).toList();
    // print(response.body);

    // var dataDetail = await ServiceApi().fetchDetHistoryTrx(noTrx);
    detailHistoryTrx.value = detailtrx;
    isLoading.value = false;
    return detailHistoryTrx;
  }
  // fetchDetailTrx(noTrx) async {
  //   await SQLHelper.instance.getItemTrx(noTrx).then((data) {
  //     dbHistoryTrx.value = data;
  //     isLoading.value = false;
  //     // print(data.length);
  //   });
  // }

  void discover(BuildContext ctx) async {
    isDiscovering.value = true;
    devices.clear();
    found = -1;
    // });

    String ip;
    // try {
    //   ip = await Wifi.ip;
    //   print('local ip:\t$ip');
    // } catch (e) {
    //   final snackBar = SnackBar(
    //       content: Text('WiFi is not connected', textAlign: TextAlign.center));
    //   Scaffold.of(ctx).showSnackBar(snackBar);
    //   return;
    // }
    // setState(() {
    // localIp = "192.168.100.15";
    // });

    final String subnet =
        "192.168.100".substring(0, "192.168.100.15".lastIndexOf('.'));
    int port = 9100;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    print('subnet:\t$subnet, port:\t$port');

    final stream = NetworkAnalyzer.discover2(subnet, port);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        // setState(() {
        devices.add(addr.ip);
        found = devices.length;
        // });
      }
    })
      ..onDone(() {
        // setState(() {
        isDiscovering.value = false;
        found = devices.length;
        // });
      })
      ..onError((dynamic e) {
        // final snackBar = SnackBar(
        //     content: Text('Unexpected exception', textAlign: TextAlign.center));
        // Scaffold.of(ctx).showSnackBar(snackBar);
        Get.snackbar('Unexpected exception', 'Unexpected exception');
      });
  }

  handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () {
                fetchDetailTrx(param['notrx']);
                Get.back();
              }));
    } else if (error is FetchDataException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () {
                fetchDetailTrx(param['notrx']);
                Get.back();
              }));
    } else if (error is ApiNotRespondingException) {
      // DialogHelper()
      //     .showErroDialog(description: 'Oops! It took longer to respond.');
      Get.defaultDialog(
          title: 'Error',
          content: const Text('Oops! It took longer to respond.'),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () {
                fetchDetailTrx(param['notrx']);
                Get.back();
              }));
    }
  }

  showLoading([String? message]) {
    // DialogHelper.showLoading(message);
    Get.defaultDialog(
        title: '',
        content: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  hideLoading() {
    // DialogHelper.hideLoading();
  }
}
