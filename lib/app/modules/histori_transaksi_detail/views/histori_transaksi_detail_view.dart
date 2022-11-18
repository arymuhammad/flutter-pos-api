import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/helper/currency_format.dart';
import 'package:my_first_app/app/settings/print_setting.dart';

import '../controllers/histori_transaksi_detail_controller.dart';

class HistoriTransaksiDetailView
    extends GetView<HistoriTransaksiDetailController> {
  HistoriTransaksiDetailView({Key? key}) : super(key: key);
  final detailTrx = Get.put(HistoriTransaksiDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Transaksi'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 29, 30, 32),
        ),
        // backgroundColor: myDefaultBackground,
        body: Obx(
          () => detailTrx.isLoading.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Text('Loading data...')
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 20),
                      child: Text(
                        'DEALER SUSU',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //       BarcodeWidget(
                          //           barcode: Barcode.codabar(),
                          //           data:
                          //               detailTrx.detailHistoryTrx[0].noTrx.toString(),
                          //           height: 100,
                          //           width: 320,
                          //           style: TextStyle(fontSize: 20)),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 5),
                                child: Text(
                                  'No Transaksi   : ${(detailTrx.detailHistoryTrx[0].noTrx)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 5),
                                child: Text(
                                  'Tanggal / Jam  : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(detailTrx.detailHistoryTrx[0].tanggal))}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Nama Barang',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: detailTrx.detailHistoryTrx.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          //  contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          visualDensity: const VisualDensity(
                                              horizontal: -4, vertical: -4),
                                          title: Text(
                                            detailTrx.detailHistoryTrx[index]
                                                .namaBarang,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          subtitle: Text(
                                            '${detailTrx.detailHistoryTrx[index].totalItem} x ${CurrencyFormat.convertToIdr(detailTrx.detailHistoryTrx[index].hargaJual, 0)}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          trailing: Text(
                                            CurrencyFormat.convertToIdr(
                                                detailTrx.detailHistoryTrx[index]
                                                        .hargaJual *
                                                    detailTrx
                                                        .detailHistoryTrx[index]
                                                        .totalItem,
                                                0),
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: FDottedLine(
                                      color: Colors.black,
                                      width: double.infinity,
                                      strokeWidth: 2.0,
                                      dottedLength: 14.0,
                                      space: 2.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 17.0),
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              detailTrx.detailHistoryTrx[0].total,
                                              0),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Tunai',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 17.0),
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              detailTrx
                                                  .detailHistoryTrx[0].pembayaran,
                                              0),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Kembali',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 17.0),
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              detailTrx.detailHistoryTrx[0].kembalian,
                                              0),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Column(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       'Grand Total',
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold, fontSize: 15),
                                    //     ),
                                    //     Text(
                                    //       CurrencyFormat.convertToIdr(param['total'], 0),
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold, fontSize: 20),
                                    //     )
                                    //   ],
                                    // ),
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          PrintSettingState(
                                                  dataPrintDetail:
                                                      detailTrx.detailHistoryTrx,
                                                  dataPrint: null)
                                              .printDetail();
                                        },
                                        // onPressed: () => Get.to(() =>
                                        //     PrintSetting(
                                        //         data: detailTrx.detailHistoryTrx)),
                                        icon: const Icon(Icons.print),
                                        label: const Text('Print'),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 15,
                                          minimumSize: const Size(130, 50),
                                          maximumSize: const Size(130, 50),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ));
  }
}
