import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_app/app/models/master_barang_model.dart';
import 'package:my_first_app/app/service/base_client.dart';
import 'package:my_first_app/app/settings/settings.dart';

import '../../../helper/db_helper.dart';
import '../../../service/app_exceptions.dart';
import '../../../service/service_api.dart';

class StockController extends GetxController {
  var dataMaster = <MasterBarang>[].obs;
  var dtSearch = <MasterBarang>[].obs;
  var isLoading = true.obs;
  // var isLengthData = 0.obs;
  var isSearch = true.obs;
  String? barcode;
  String? kode;
  final count = 0.obs;
  final List<String> selected = ["", "10", "20", "30", "40", "50", "100"].obs;
  var selectedItem = ''.obs;
  var uri = '';
  @override
  void onInit() {
    super.onInit();
    fetchdataMaster();
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

  Future<List<MasterBarang>> fetchdataMaster() async {
    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });

    var response = await BaseClient()
        .get('http://$uri/api-pos', '/stock/cekstock.php')
        .catchError(handleError);

    List<dynamic> kdBarang = json.decode(response)['rows'];
    List<MasterBarang> dtBarang =
        kdBarang.map((e) => MasterBarang.fromJson(e)).toList();
    dataMaster.value = dtBarang;
    isLoading.value = false;
    return dataMaster;
  }

  getDataItem(String? barcode) async {
    var dataBarang = await ServiceApi().fetchDataItem(barcode);
    dataMaster.value = dataBarang;
    dtSearch.value = dataBarang;
    isLoading.value = false;
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
                fetchdataMaster();
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
                  fetchdataMaster();
                });
              }));
    } else if (error is ApiNotRespondingException) {
      // DialogHelper()
      //     .showErroDialog(description: 'Oops! It took longer to respond.');
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: const Text('Oops! Server terlalu lama merespon.'),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                fetchdataMaster();
                Get.back();
              }),
          cancel: ElevatedButton.icon(
              icon: const Icon(Icons.wifi_protected_setup_rounded),
              onPressed: () async {
                await Get.to(() => SettingsView());
                await Future.delayed(const Duration(milliseconds: 10), () {
                  Get.back();
                  isLoading.value = true;
                  fetchdataMaster();
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

  Future<List<MasterBarang>> getDataFilter(limit) async {
    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });

    var response = await BaseClient()
        .get('http://$uri/api-pos', '/stock/cekstock.php?limit=$limit')
        .catchError(handleError);

    List<dynamic> kdBarang = json.decode(response)['rows'];
    List<MasterBarang> dtBarang =
        kdBarang.map((e) => MasterBarang.fromJson(e)).toList();
    dataMaster.value = dtBarang;
    isLoading.value = false;
    return dataMaster;
  }
}
