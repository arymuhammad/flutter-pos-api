import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/helper/currency_format.dart';
import 'package:my_first_app/app/models/detail_trx_model.dart';
import 'package:my_first_app/app/modules/historytransaksi/views/historytransaksi_view.dart';
import 'package:my_first_app/app/service/repo.dart';
import 'package:my_first_app/app/service/service_api.dart';
import 'package:my_first_app/app/settings/print_setting.dart';

import '../../../models/master_barang_model.dart';
import '../controllers/transaksi_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class TransaksiView extends GetView<TransaksiController> {
  TransaksiView({Key? key}) : super(key: key);

  final transaksiController = Get.put(TransaksiController());

  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNodePembayaran = FocusNode();
  TextEditingController pembayaran = TextEditingController();
  TextEditingController transaksi = TextEditingController();
  double dataBarang = 0.0;

  var dateTrx = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        if (transaksiController.listdata.isNotEmpty) {
          await Get.defaultDialog(
              title: 'Peringatan',
              content: Container(
                child: const Text(
                    'Semua List Item akan dihapus.\nBatalakan Transaksi ini?'),
              ),
              confirm: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent[700]),
                  child: const Text('TIDAK')),
              cancel: ElevatedButton(
                  onPressed: () {
                    willLeave = true;
                    Get.back();
                  },
                  child: const Text('IYA')));
        } else {
          willLeave = true;
        }
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaksi'),
          backgroundColor: const Color.fromARGB(255, 29, 30, 32),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Get.to(() => HistoryTransaksiView(),
                  transition: Transition.zoom),
              icon: const Icon(Icons.add_chart_sharp),
              tooltip: 'History Transaksi',
            )
          ],
        ),
        backgroundColor: myDefaultBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              height: 25,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                          'No Transaksi: ${transaksiController.generateTrx}'))
                    ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      autofocus: true,
                      focusNode: myFocusNode,
                      controller: transaksi,
                      onSubmitted: (data) async {
                        if (transaksi.text.isNotEmpty) {
                          await transaksiController.fetchDtBarang(data);

                          final int index1 = transaksiController.dataBarang
                              .indexWhere(((book) =>
                                  book.kodeBarang == int.parse(data)));

                          if (index1 != -1) {
                            // print('Index: $index1');
                            // print(transaksiController.dataBarang[index1].kodeBarang);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Kode barang atau Stok tidak ada",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          if (transaksiController.dataBarang[index1].stok ==
                              0) {
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
                            transaksiController.listdata.add(MasterBarang(
                                kodeBarang: int.parse(data),
                                namaBarang: transaksiController
                                    .dataBarang[index1].namaBarang,
                                hargaBarang: transaksiController
                                    .dataBarang[index1].hargaBarang,
                                stok:
                                    transaksiController.dataBarang[index1].stok,
                                tanggal: DateFormat('yyyy-MM-dd H:mm:ss')
                                    .format(DateTime.now())
                                    .toString(),
                                totalData: transaksiController
                                    .dataBarang[index1].totalData));

                            transaksi.clear();
                            myFocusNode.requestFocus();

                            var initialV = 0;
                            int sum = transaksiController.listdata.fold(
                                initialV,
                                (hargaBarang, dst) =>
                                    hargaBarang.toInt() +
                                    int.parse(dst.hargaBarang.toString()));

                            transaksiController.total.value = sum;
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Harap masukkan kode barang!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent[700],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          // transaksi.clear();
                          myFocusNode.requestFocus();
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)),
                          suffixIcon: const Icon(Icons.search),
                          label: const Text('Input / Scan Barcode disini')),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Obx(
              () => transaksiController.listdata.isEmpty
                  ? const Center(child: Text('Belum ada Transaksi'))
                  : ListView.builder(
                      itemCount: transaksiController.listdata.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                    title: 'Perhatian',
                                    content: Text(
                                        'Apakah Anda Yakin Ingin Menghapus Item Ini?\n${transaksiController.listdata[index].namaBarang}'),
                                    confirm: ElevatedButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        transaksiController.listdata
                                            .removeAt(index)
                                            .toString();

                                        int sum =
                                            transaksiController.listdata
                                                .fold(
                                                    0,
                                                    (hargaBarang, dst) =>
                                                        hargaBarang.toInt() +
                                                        int.parse(dst
                                                            .hargaBarang
                                                            .toString()));

                                        transaksiController.total.value = sum;

                                        Get.back();
                                      },
                                    ),
                                    barrierDismissible: false,
                                    cancel: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          elevation: 15,
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('BATAL')));
                              },
                              child: const Icon(Icons.cancel_rounded),
                            ),
                            title: Text(
                                '${transaksiController.listdata[index].kodeBarang}'),
                            subtitle: Text(
                              '${transaksiController.listdata[index].namaBarang}\n${CurrencyFormat.convertToIdr(transaksiController.listdata[index].hargaBarang, 0)}',
                            ),
                          ),
                        );
                      },
                    ),
            )),
            Container(
              height: 144,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => Text(
                            'Qty Item : ${transaksiController.listdata.length} pcs',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() => Text(
                          CurrencyFormat.convertToIdr(
                                  transaksiController.total.value, 0)
                              .toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => ElevatedButton.icon(
                              icon: const Icon(Icons.clear_all_outlined),
                              onPressed: () {
                                if (transaksiController.listdata.isEmpty) {
                                  return;
                                } else {
                                  Get.defaultDialog(
                                      content: const Text(
                                          'Apakah Anda Yakin Membatalkan Transaksi Ini?'),
                                      confirm: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.blueAccent[700],
                                          elevation: 15,
                                        ),
                                        onPressed: () {
                                          transaksiController.listdata.clear();
                                          transaksiController.total.value = 0;
                                          Get.back();
                                          myFocusNode.requestFocus();
                                          scanBarcodeDiscovery();
                                        },
                                        child: const Text('OK'),
                                      ),
                                      barrierDismissible: false,
                                      cancel: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.redAccent[700],
                                            elevation: 15,
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('BATAL')));
                                }
                              },
                              label: const Text('BATALKAN'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      transaksiController.listdata.isEmpty
                                          ? Colors.grey[300]
                                          : Colors.redAccent[700],
                                  // elevation: 15,
                                  side: BorderSide.none,
                                  maximumSize: const Size(190, 55),
                                  minimumSize: const Size(190, 55))),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Obx(
                          () => ElevatedButton.icon(
                            label: const Text('CHECKOUT'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    transaksiController.listdata.isEmpty
                                        ? Colors.grey[300]
                                        : Colors.blueAccent[700],
                                // elevation: 15,
                                maximumSize: const Size(175, 55),
                                minimumSize: const Size(175, 55)),
                            icon: const Icon(Icons.payments),
                            onPressed: () {
                              if (transaksiController.listdata.isEmpty) {
                                return;
                              } else {
                                var dataList = [];
                                for (var e in transaksiController.listdata) {
                                  // for(var i =0, i< transaksiController.listdata.length, $i++){
                                  // print(e.kodeBarang);
                                  // }
                                  var totalItem = transaksiController.listdata
                                      .where(
                                          (c) => c.kodeBarang == e.kodeBarang)
                                      .length;

                                  // print(e.hargaBarang);
                                  var dataItem = {
                                    'no_trx': transaksiController.generateTrx
                                        .toString(),
                                    'kode_barang': e.kodeBarang.toString(),
                                    'nama_barang': e.namaBarang.toString(),
                                    'harga_barang': e.hargaBarang.toString(),
                                    'qty_awal': e.stok.toString(),
                                    'qty_akhir': totalItem.toString(),
                                  };
                                  dataList.add(dataItem);

                                  // ServiceApi().postData(data);
                                }
                                final jsonListData = dataList
                                    .map((item) => jsonEncode(item))
                                    .toList();

                                final uniqueJsonList =
                                    jsonListData.toSet().toList();
                                final resultList = uniqueJsonList
                                    .map((item) => jsonDecode(item))
                                    .toList();

                                Get.defaultDialog(
                                    radius: 10,
                                    title: 'Pembayaran',
                                    // barrierDismissible: false,
                                    content: SizedBox(
                                      // width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text("Item"),
                                              Text('Total')
                                            ],
                                          ),
                                          const Divider(),
                                          SizedBox(
                                            height:
                                                150.0, // Change as per your requirement
                                            width: 300.0,
                                            child: ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  left: 1, right: 1),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: resultList.length,
                                              itemBuilder: (c, i) {
                                                return ListTile(
                                                  title: Text(
                                                      '${resultList[i]['nama_barang']}'),
                                                  subtitle: Text(
                                                    '${CurrencyFormat.convertToIdr(int.parse(resultList[i]['harga_barang']), 0).toString()} x ${resultList[i]['qty_akhir']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                  trailing: Text(
                                                    CurrencyFormat.convertToIdr(
                                                            int.parse(resultList[
                                                                        i][
                                                                    'harga_barang']) *
                                                                int.parse(
                                                                    resultList[
                                                                            i][
                                                                        'qty_akhir']),
                                                            0)
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Pembayaran'),
                                              SizedBox(
                                                width: 170,
                                                height: 40,
                                                child: TextField(
                                                  autofocus: true,
                                                  focusNode:
                                                      myFocusNodePembayaran,
                                                  controller: pembayaran,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  cursorHeight: 20,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) =>
                                                      transaksiController
                                                          .pembayaran(value),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Total '),
                                              SizedBox(
                                                width: 170,
                                                height: 40,
                                                child: TextFormField(
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: CurrencyFormat
                                                          .convertToIdr(
                                                              transaksiController
                                                                  .total.value,
                                                              0),
                                                      hintStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                  cursorHeight: 20,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  readOnly: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Kembalian'),
                                              SizedBox(
                                                width: 170,
                                                height: 40,
                                                child: Obx(
                                                  () => TextFormField(
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: CurrencyFormat
                                                            .convertToIdr(
                                                                transaksiController
                                                                    .kembalian
                                                                    .value,
                                                                0),
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                    cursorHeight: 20,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    confirm: ElevatedButton.icon(
                                        icon: const Icon(Icons.payments),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blueAccent[700],
                                            minimumSize: const Size(100, 45)),
                                        onPressed: () {
                                          if (pembayaran.text.isNotEmpty) {
                                            var dataMaster = [];
                                            for (var e in transaksiController
                                                .listdata) {
                                              // for(var i =0, i< transaksiController.listdata.length, $i++){
                                              // print(e.kodeBarang);
                                              // }
                                              var count = transaksiController
                                                  .listdata
                                                  .where((c) =>
                                                      c.kodeBarang ==
                                                      e.kodeBarang)
                                                  .length;

                                              var data = {
                                                'no_trx': transaksiController
                                                    .generateTrx
                                                    .toString(),
                                                'kode_barang':
                                                    e.kodeBarang.toString(),
                                                'nama_barang':
                                                    e.namaBarang.toString(),
                                                'harga_barang':
                                                    e.hargaBarang.toString(),
                                                'qty_awal': e.stok.toString(),
                                                'qty_akhir': count.toString(),
                                              };
                                              dataMaster.add(data);
                                            }
                                            final jsonList = dataMaster
                                                .map((item) => jsonEncode(item))
                                                .toList();

                                            final uniqueJsonList =
                                                jsonList.toSet().toList();
                                            final result = uniqueJsonList
                                                .map((item) => jsonDecode(item))
                                                .toList();

                                            for (var item in result) {
                                              var sisaStok = int.parse(
                                                      item['qty_awal']) -
                                                  int.parse(item['qty_akhir']);

                                              var dataItem = {
                                                'no_trx': transaksiController
                                                    .generateTrx
                                                    .toString(),
                                                'kode_barang':
                                                    item['kode_barang']
                                                        .toString(),
                                                'nama_barang':
                                                    item['nama_barang']
                                                        .toString(),
                                                'harga_jual':
                                                    item['harga_barang']
                                                        .toString(),
                                                'qty_awal':
                                                    item['qty_awal'].toString(),
                                                'qty_akhir': item['qty_akhir']
                                                    .toString(),
                                                'created_at': DateFormat(
                                                        'yyyy-MM-dd H:mm:ss')
                                                    .format(DateTime.now())
                                                    .toString()
                                              };

                                              ServiceApi()
                                                  .updateMasterTrx(dataItem);
                                              ServiceApi().postData(dataItem);
                                            }

                                            var dataPenjualan = {
                                              'no_trx': transaksiController
                                                  .generateTrx
                                                  .toString(),
                                              'total_trx': transaksiController
                                                  .total.value
                                                  .toString(),
                                              'pembayaran':
                                                  pembayaran.text.toString(),
                                              'kembali': transaksiController
                                                  .kembalian.value
                                                  .toString(),
                                              'tgl_trx': dateTrx,
                                              'created_at': DateFormat(
                                                      'yyyy-MM-dd H:mm:ss')
                                                  .format(DateTime.now())
                                                  .toString()
                                            };
                                            ServiceApi().postDataPenjualan(
                                                dataPenjualan);

                                            var dataPrint =
                                                RxList<DetailTrx>([]);
                                            for (var item in result) {
                                              var dataItemPrint = DetailTrx(
                                                  noTrx: transaksiController
                                                      .generateTrx
                                                      .toInt(),
                                                  kodeBarang: int.parse(
                                                      item['kode_barang']),
                                                  namaBarang:
                                                      item['nama_barang'],
                                                  hargaJual: int.parse(
                                                      item['harga_barang']),
                                                  total: transaksiController
                                                      .total.value,
                                                  pembayaran: int.parse(
                                                      pembayaran.text),
                                                  kembalian: transaksiController
                                                      .kembalian.value,
                                                  tanggal: DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(DateTime.now()),
                                                  totalItem: int.parse(
                                                      item['qty_akhir']));

                                              dataPrint.add(dataItemPrint);
                                            }

                                            PrintSettingState(
                                                    dataPrint: dataPrint,
                                                    dataPrintDetail: null)
                                                .printStruk();

                                            // HistoriTransaksiDetailController()
                                            //     .fetchDetailTrx(
                                            //         '00${initNum.toString() + generateTrx.toString()}');

                                            // Get.back();
                                            pembayaran.clear();
                                            transaksiController
                                                .kembalian.value = 0;
                                            // Get.back();
                                            transaksiController.listdata
                                                .clear();
                                            transaksiController.total.value = 0;
                                            myFocusNode.requestFocus();
                                            transaksiController.generateTrx++;
                                            Get.defaultDialog(
                                                barrierDismissible: false,
                                                radius: 10,
                                                title: 'Sukses',
                                                content: const Text(
                                                    'Pembayaran Berhasil.\nTransaksi Selesai!'),
                                                confirm: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                  child: const Text('OK'),
                                                ));
                                          } else {
                                            Get.snackbar('Peringatan',
                                                'Harap isi kolom pembayaran!',
                                                duration:
                                                    const Duration(seconds: 2),
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                backgroundColor:
                                                    Colors.redAccent[700],
                                                colorText: Colors.white,
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                ));
                                            myFocusNodePembayaran
                                                .requestFocus();
                                          }
                                        },
                                        label: const Text('BAYAR')),
                                    cancel: ElevatedButton.icon(
                                        icon: const Icon(Icons.cancel),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.redAccent[700],
                                            minimumSize: const Size(100, 45)),
                                        onPressed: () {
                                          pembayaran.clear();
                                          transaksiController.kembalian.value =
                                              0;
                                          Get.back();
                                          myFocusNode.requestFocus();
                                        },
                                        label: const Text('BATAL')));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 145.0),
          child: FloatingActionButton(
            onPressed: () {
              scanBarcodeDiscovery();
            },
            tooltip: 'Scan Barcode',
            elevation: 10,
            child: Image.asset(
              'asset/barcode.png',
              scale: 3,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  scanBarcodeDiscovery() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
      transaksi.text = barcodeScanRes;
      await transaksiController.fetchDtBarang(barcodeScanRes);

      final int index1 = transaksiController.dataBarang
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
      }

      if (transaksiController.dataBarang[index1].stok == 0) {
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
        transaksiController.listdata.add(MasterBarang(
            kodeBarang: int.parse(barcodeScanRes),
            namaBarang: transaksiController.dataBarang[index1].namaBarang,
            hargaBarang: transaksiController.dataBarang[index1].hargaBarang,
            stok: transaksiController.dataBarang[index1].stok,
            tanggal: DateFormat('yyyy-MM-dd H:mm:ss')
                .format(DateTime.now())
                .toString(),
            totalData: transaksiController.dataBarang[index1].totalData));
        transaksi.clear();
        myFocusNode.requestFocus();
        var initialV = 0;
        int sum = transaksiController.listdata.fold(
            initialV,
            (hargaBarang, dst) =>
                hargaBarang.toInt() + int.parse(dst.hargaBarang.toString()));
        // print('$sum fold');
        transaksiController.total.value = sum;
      }
      // print(barcodeBarang + ' barcode nih scan');
      scanBarcodeDiscovery();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }
}
