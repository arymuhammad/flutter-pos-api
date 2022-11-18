import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/models/trx_model.dart';

import '../../../helper/db_helper.dart';
import '../../../service/app_exceptions.dart';
import '../../../service/base_client.dart';
import '../../../settings/settings.dart';

// import 'base_controller.dart';

class HistorytransaksiController extends GetxController {
  var historyTrx = <Trx>[].obs;
  var isLoading = true.obs;
  var isSearch = true.obs;
  var totalTrx = 0.obs;

  final List<String> selected = ["", "10", "20", "30", "40", "50", "100"].obs;
  var selectedItem = ''.obs;

  RxList<Trx> searchTrx = RxList<Trx>([]);

  String? tgl1;
  String? tgl2;
  var uri = '';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDataHistory(tgl1, tgl2);
    searchTrx.value = historyTrx;
    ipServer();
  }

  ipServer() async {
    await SQLHelper.instance.getIp().then((data) {
      if (data.isNotEmpty) {
        uri = data.first.ipaddress!;
      } else {
        Get.defaultDialog(
            radius: 5,
            title: 'Koneksi Bermasalah',
            barrierDismissible: false,
            content: const Text(
                'Tidak ada koneksi ke server\nPeriksa IP Address server'),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.to(() => SettingsView());
                },
                child: const Text('Periksa')));
      }
    });
  }

  Future<List<Trx>> fetchDataHistory(
    String? tglAwal,
    String? tglAkhir,
  ) async {
    if (tglAwal == null && tglAkhir == null ||
        tglAwal == "" && tglAkhir == "") {
      tgl1 = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      tgl2 = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      // lmt = "20";
    } else if (tglAwal != "" && tglAkhir != "") {
      tgl1 = tglAwal;
      tgl2 = tglAkhir;
      // lmt = "20";
    }

    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });

    var response = await BaseClient()
        .get('http://$uri/api-pos',
            '/transaksi/history.php?tgl1=$tgl1&tgl2=$tgl2')
        .catchError(handleError);
    List<dynamic> dataTrx = json.decode(response)['rows'];
    List<Trx> trx = dataTrx.map((e) => Trx.fromJson(e)).toList();
    // print(response);
    historyTrx.value = trx;
    isLoading.value = false;
    return historyTrx;
  }

  filterDataTrx(String noTrx) {
    List<Trx> result = [];

    if (noTrx.isEmpty) {
      result = historyTrx;
    } else {
      result = historyTrx
          .where((e) =>
              e.noTrx.toString().toLowerCase().contains(noTrx.toLowerCase()))
          .toList();
    }
    searchTrx.value = result;
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
                fetchDataHistory(tgl1, tgl2);
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
                  isLoading.value = true;
                  fetchDataHistory(tgl1, tgl2);
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
                isLoading.value = true;
                fetchDataHistory(tgl1, tgl2);
              }),
          cancel: ElevatedButton.icon(
              icon: const Icon(Icons.wifi_protected_setup_rounded),
              onPressed: () async {
                await Get.to(() => SettingsView());
                await Future.delayed(const Duration(milliseconds: 10), () {
                  Get.back();
                  isLoading.value = true;
                  fetchDataHistory(tgl1, tgl2);
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
