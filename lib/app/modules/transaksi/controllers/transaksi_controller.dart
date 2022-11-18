import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/models/master_barang_model.dart';
import 'package:my_first_app/app/service/service_api.dart';

import '../../../helper/db_helper.dart';
import '../../../service/app_exceptions.dart';
import '../../../service/base_client.dart';
import '../../../settings/settings.dart';

class TransaksiController extends GetxController {
  var dataBarang = <MasterBarang>[].obs;
  var listdata = [].obs;
  var barcodeBarang = ''.obs;
  var generateTrx =
      int.parse(DateFormat('ddMMyyHHmmss').format(DateTime.now())).obs;
  var uri = "";
  var total = 0.obs;
  var kembalian = 0.obs;
  final count = 0.obs;
  String? barkode;
  TextEditingController transaksi = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDtBarang(barkode);
    scanBarcodeDiscovery();
    // clearTable();
  }

  // fetchDtBarang(barkode) async {
  //   var dtBarang = await ServiceApi().fetchDataItem(barkode);

  //   dataBarang.value = dtBarang;
  // }

  Future<List<MasterBarang>> fetchDtBarang(String? barcode) async {
    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await BaseClient().get('http://$uri/api-pos',
        '/stock/cekstock.php?kode_barang=$barcode&nama_barang=$barcode').catchError(handleError);
    List<dynamic> kdBarang = json.decode(response)['rows'];
    List<MasterBarang> dtBarang =
        kdBarang.map((e) => MasterBarang.fromJson(e)).toList();
    dataBarang.value = dtBarang;
    return dataBarang;
  }

  @override
  void pembayaran(String bayar) async {
    var result = int.parse(bayar) - total.value;
    kembalian.value = result;
    print(kembalian.value);
  }

  void scanBarcodeDiscovery() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
      transaksi.text = barcodeScanRes;
      await fetchDtBarang(barcodeScanRes);

      final int index1 = dataBarang
          .indexWhere(((book) => book.kodeBarang == int.parse(barcodeScanRes)));

      if (index1 != -1) {
        // print('Index: $index1');
        // print(transaksiController.dataBarang[index1].kodeBarang);
      } else {
        Fluttertoast.showToast(
            msg: "Kode barang atau Stok tidak ada.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // myFocusNode.requestFocus();
      }

      if (dataBarang[index1].stok == 0) {
        Fluttertoast.showToast(
            msg:
                "Stok barang kosong, Harap periksa stok barang di menu Data Stok.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        listdata.add(MasterBarang(
            kodeBarang: int.parse(barcodeScanRes),
            namaBarang: dataBarang[index1].namaBarang,
            hargaBarang: dataBarang[index1].hargaBarang,
            stok: dataBarang[index1].stok,
            tanggal: DateFormat('yyyy-MM-dd H:mm:ss')
                .format(DateTime.now())
                .toString(),
            totalData: dataBarang[index1].totalData));
        transaksi.clear();
        // myFocusNode.requestFocus();
        var initialV = 0;
        int sum = listdata.fold(
            initialV,
            (hargaBarang, dst) =>
                hargaBarang.toInt() + int.parse(dst.hargaBarang.toString()));
        total.value = sum;
        scanBarcodeDiscovery();
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
  }

  handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                fetchDtBarang(transaksi.text);
                Get.back();
              }));
    } else if (error is FetchDataException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          radius: 5,
          barrierDismissible: false,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Periksa'),
              onPressed: () async {
                await Get.to(() => SettingsView());
                await Future.delayed(const Duration(milliseconds: 10), () {
                  Get.back();
                   fetchDtBarang(transaksi.text);
                });
              }));
    } else if (error is ApiNotRespondingException) {
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: const Text('Oops! Server terlalu lama merespon.'),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                Get.back();
                 fetchDtBarang(transaksi.text);
              }),
          cancel: ElevatedButton.icon(
              icon: const Icon(Icons.wifi_protected_setup_rounded),
              onPressed: () async {
                await Get.to(() => SettingsView());
                await Future.delayed(const Duration(milliseconds: 10), () {
                  Get.back();
                   fetchDtBarang(transaksi.text);
                });
              },
              label: const Text('Cek koneksi')));
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
