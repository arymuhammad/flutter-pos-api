import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_first_app/app/models/detail_trx_model.dart';

import '../models/detail_trx_model_db.dart';

class PrintSetting extends StatefulWidget {
  final RxList<DetailTrxDb>? data;
  const PrintSetting({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  PrintSettingState createState() =>
      PrintSettingState(dataPrint: null, dataPrintDetail: null);
}

class PrintSettingState extends State<PrintSetting> {
  final RxList<DetailTrx>? dataPrint;
  final RxList<DetailTrx>? dataPrintDetail;
  PrintSettingState({required this.dataPrint, required this.dataPrintDetail});
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Printer'),
        backgroundColor: const Color.fromARGB(255, 29, 30, 32),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name ?? ''),
                            subtitle: Text(d.address!),
                            onTap: () async {
                              setState(() {
                                _device = d;
                              });
                            },
                            trailing:
                                _device != null && _device?.address == d.address
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                          ))
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                          child: const Text('connect'),
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                          child: const Text('disconnect'),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = {};

                              List<LineText> list = [];

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'DEALER SUSU\n\n',
                                width: 2,
                                height: 2,
                                weight: 2,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'No Transaksi : ${widget.data![0].noTrx}',
                                // width: 2,
                                // height: 2,
                                weight: 2,
                                align: LineText.ALIGN_LEFT,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Tanggal/jam : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.data![0].createdAt!))}',
                                // width: 2,
                                // height: 2,
                                weight: 2,
                                align: LineText.ALIGN_LEFT,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: '==============================',
                                // width: 1,
                                // height: 1,
                                weight: 2,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));

                              for (var i = 0; i < widget.data!.length; i++) {
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: widget.data![i].namaBarang,
                                    weight: 0,
                                    align: LineText.ALIGN_LEFT,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content:
                                        '${widget.data![i].totalItem.toString()} x ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(widget.data![i].hargaJual).toString()}',
                                    weight: 0,
                                    align: LineText.ALIGN_LEFT,
                                    linefeed: 1));
                              }
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: '==============================',
                                // width: 1,
                                // height: 1,
                                weight: 2,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Total ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(widget.data![0].total)}',
                                // width: 1,
                                // height: 1,
                                weight: 1,
                                align: LineText.ALIGN_RIGHT,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: '==============================',
                                // width: 1,
                                // height: 1,
                                weight: 2,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Tunai ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(widget.data![0].pembayaran)}',
                                // width: 1,
                                // height: 1,
                                weight: 1,
                                align: LineText.ALIGN_RIGHT,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Kembali ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(widget.data![0].kembali)}\n\n',
                                // width: 1,
                                // height: 1,
                                weight: 1,
                                align: LineText.ALIGN_RIGHT,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Barang yang sudah dibeli,\ntidak dapat ditukar/dikembalikan\nTerima kasih',
                                // width: 1,
                                // height: 1,
                                // weight: 1,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));

                              await bluetoothPrint.printReceipt(config, list);
                            }
                          : null,
                      child: const Text('print struk'),
                    ),

                    //           List<LineText> list1 = [];
                    //           ByteData data = await rootBundle
                    //               .load("asset/logo_print.png");
                    //           List<int> imageBytes = data.buffer.asUint8List(
                    //               data.offsetInBytes, data.lengthInBytes);
                    //           String base64Image = base64Encode(imageBytes);
                    //           list1.add(LineText(
                    //             type: LineText.TYPE_IMAGE,
                    //             x: 10,
                    //             y: 10,
                    //             content: base64Image,
                    //           ));

                    //           await bluetoothPrint.printLabel(config, list);
                    //           await bluetoothPrint.printLabel(config, list1);
                    //         }
                    //       : null,
                    // ),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              await bluetoothPrint.printTest();
                            }
                          : null,
                      child: const Text('print test'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => bluetoothPrint.startScan(
                    timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }

  printStruk() async {
    _connected;
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) async {
      print('cur device status: $state');

      if (state == 12 && isConnected!) {
        _connected = true;
        // print(_connected);
        Map<String, dynamic> config = {};

        List<LineText> list = [];

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'DEALER SUSU\n\n',
          width: 2,
          height: 2,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'No Transaksi : ${dataPrint![0].noTrx}',
          // width: 2,
          // height: 2,
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Tanggal/jam : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(dataPrint![0].tanggal))}',
          // width: 2,
          // height: 2,
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        for (var i = 0; i < dataPrint!.length; i++) {
          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: dataPrint![i].namaBarang,
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 1));

          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content:
                  '${dataPrint![i].totalItem.toString()} x ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrint![i].hargaJual).toString()}',
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 1));
        }
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Total ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrint![0].total)}',
          // width: 1,
          // height: 1,
          weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Tunai ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrint![0].pembayaran)}',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Kembali ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrint![0].kembalian)}\n\n',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Barang yang sudah dibeli,\ntidak dapat ditukar/dikembalikan.\nTerima kasih',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        await bluetoothPrint.printReceipt(config, list);

        Fluttertoast.showToast(
            msg: "Print Struk Berhasil.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // });
        //   break;
        // case BluetoothPrint.DISCONNECTED:
        // setState(() {
        _connected = false;
        // print(_connected);

        Fluttertoast.showToast(
            msg: "Print Struk Gagal. Cek koneksi printer.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
      // });
      //       break;
      //     default:
      //       break;
      //   }
    });
  }

  printDetail() async {
    _connected;
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) async {
      print('cur device status: $state');
      // switch (state) {
      //   case BluetoothPrint.CONNECTED:
      // if(BluetoothPrint.CONNECTED){
      //     // setState(() {
      // if (state == 12) {
      //   Fluttertoast.showToast(
      //       msg: "Bluetooth Aktif",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.greenAccent[700],
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // } else {
      //   Fluttertoast.showToast(
      //       msg: "Bluetooth Non aktif",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.redAccent[700],
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }

      if (state == 12 && isConnected!) {
        _connected = true;
        // print(_connected);
        Map<String, dynamic> config = {};

        List<LineText> list = [];

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'DEALER SUSU\n\n',
          width: 2,
          height: 2,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'No Transaksi : ${dataPrintDetail![0].noTrx}',
          // width: 2,
          // height: 2,
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Tanggal/jam : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(dataPrintDetail![0].tanggal))}',
          // width: 2,
          // height: 2,
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        for (var i = 0; i < dataPrintDetail!.length; i++) {
          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: dataPrintDetail![i].namaBarang,
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 1));

          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content:
                  '${dataPrintDetail![i].totalItem.toString()} x ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrintDetail![i].hargaJual).toString()}',
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 1));
        }
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Total ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrintDetail![0].total)}',
          // width: 1,
          // height: 1,
          weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '==============================',
          // width: 1,
          // height: 1,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Tunai ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrintDetail![0].pembayaran)}',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Kembali ${NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0).format(dataPrintDetail![0].kembalian)}\n\n',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Barang yang sudah dibeli,\ntidak dapat ditukar/dikembalikan.\nTerima kasih',
          // width: 1,
          // height: 1,
          // weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        await bluetoothPrint.printReceipt(config, list);

        Fluttertoast.showToast(
            msg: "Print Struk Berhasil.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // });
        //   break;
        // case BluetoothPrint.DISCONNECTED:
        // setState(() {
        _connected = false;
        // print(_connected);

        Fluttertoast.showToast(
            msg: "Print Struk Gagal. Cek koneksi printer.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
      // });
      //       break;
      //     default:
      //       break;
      //   }
    });
  }
}
