// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/app/models/master_barang_model.dart';

import '../helper/db_helper.dart';
import '../models/detail_trx_model.dart';
import '../models/trx_model.dart';
import 'base_client.dart';

class ServiceApi {
  var apiUrl = 'http://103.112.139.155:9000/api/';

  var uri = "";

  Future<List<MasterBarang>> fetchDataMasterBarang() async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var pathUrl = 'http://$uri/api-pos/stock/cekstock.php';
    var response = await http.get(Uri.parse(pathUrl));
    print(pathUrl);
    List<dynamic> kdBarang = json.decode(response.body)['rows'];
    List<MasterBarang> dtBarang =
        kdBarang.map((e) => MasterBarang.fromJson(e)).toList();

    return dtBarang;
  }

  Future<List<MasterBarang>> fetchDataItem(String? barcode) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var pathUrl =
        'http://$uri/api-pos/stock/cekstock.php?kode_barang=$barcode&nama_barang=$barcode';
    var response = await http.get(Uri.parse(pathUrl));
    print(pathUrl);
    List<dynamic> kdBarang = json.decode(response.body)['rows'];
    List<MasterBarang> dtBarang =
        kdBarang.map((e) => MasterBarang.fromJson(e)).toList();

    return dtBarang;
  }

  postData(data) async {
    //   final url = Uri.parse('http://103.112.139.155/api-pos/transaksi/input.php');
    // final headers = {"Content-type": "application/json"};
    // final json = jsonEncode(data);
    // final response = await http.post(url, headers: headers, body: json);
     await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await http.post(
        Uri.parse('http://$uri/api-pos/transaksi/input.php'),
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: data);
    // print('Status code: ${response.statusCode}');
    // print('Body: $data');
    // print('response body :${response.body}');
  }

  updateMasterBarang(data) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await http.post(
        Uri.parse('http://$uri/api-pos/stock/update_stock.php'),
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: data);
    // print('Status code: ${response.statusCode}');
    // print('Body: $data');
    // print('response body :${response.body}');
  }

  updateMasterTrx(data) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await http.post(
        Uri.parse('http://$uri/api-pos/stock/update_stockV2.php'),
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: data);
    // print('Status code: ${response.statusCode}');
    // print('Body: $data');
    // print('response body :${response.body}');
  }

  postDataPenjualan(dataPenjualan) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await http.post(
        Uri.parse('http://$uri/api-pos/transaksi/input.php'),
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        // },
        body: dataPenjualan);
    // print('Status code: ${response.statusCode}');
    // print('Body: $dataPenjualan');
    // print('response body :${response.body}');
  }

  Future<List<Trx>> fetchHistoryTrx(
      String? tgl1, String? tgl2, String? limit) async {
       await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var pathUrl =
        'http://$uri/api-pos/transaksi/history.php?tgl1=$tgl1&tgl2=$tgl2&limit=$limit';
    var response = await http.get(Uri.parse(pathUrl));
    // print(tgl1);
    // print(tgl2);
    // print(pathUrl);
    List<dynamic> dataTrx = json.decode(response.body)['rows'];
    List<Trx> trx = dataTrx.map((e) => Trx.fromJson(e)).toList();
    print(response.body);
    return trx;
  }

  Future<List<Trx>> getDataTrx(
      String? tgl1, String? tgl2, String? limit) async {
    // showLoading('Fetching data');
    await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await BaseClient().get('http://$uri/api-pos',
        '/transaksi/history.php?tgl1=$tgl1&tgl2=$tgl2&limit=$limit');
    // .catchError(handleError);
    List<dynamic> dataTrx = json.decode(response)['rows'];
    List<Trx> trx = dataTrx.map((e) => Trx.fromJson(e)).toList();

    // print(response);
    // if (response == null) return null;
    // hideLoading();
    return trx;
    // return trx;
  }

  Future<List<DetailTrx>> fetchDetHistoryTrx(noTrx) async {
    var response = await BaseClient()
        .get('http://$uri/api-pos', '/transaksi/detail_history.php?no_trx=$noTrx');
    // .catchError(handleError);
    // print(pathUrl);
    List<dynamic> dataDetTrx = json.decode(response)['rows'];
    // print(dataDetTrx);
    List<DetailTrx> detailtrx =
        dataDetTrx.map((e) => DetailTrx.fromJson(e)).toList();
    // print(response.body);
    return detailtrx;
  }

  inputDataMaster(dataMaster) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var pathUrl = 'http://$uri/api-pos/stock/input_master.php';
    var response = await http.post(Uri.parse(pathUrl), body: dataMaster);
    // print(pathUrl);
    // print('Status code: ${response.statusCode}');
    // print('Body: $dataMaster');
    // print('response body :${response.body}');
  }

  deleteMasterBarang(barcodeMaster) async {
   await SQLHelper.instance.getIp().then((data) {
      uri = data.first.ipaddress!;
    });
    var response = await http.post(
        Uri.parse('http://$uri/api-pos/stock/delete_master.php'),
        body: barcodeMaster);
    // print(url);
  }

}
