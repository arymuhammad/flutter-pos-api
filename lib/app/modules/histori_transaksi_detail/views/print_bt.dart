// // import 'dart:math';

// // ignore_for_file: depend_on_referenced_packages

// import 'package:bluetooth_print/bluetooth_print_model.dart';
// // import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:my_first_app/app/modules/histori_transaksi_detail/controllers/histori_transaksi_detail_controller.dart';

// class PrintBt extends GetView<HistoriTransaksiDetailController> {
//   PrintBt({Key? key}) : super(key: key);

//   final itemTrx = Get.put(HistoriTransaksiDetailController());

//   // printWithDevice(BluetoothDevice device) async {
//   //   await device.connect();
//   //   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   //   final printer = BluePrint();
//   //   printer.add(gen.qrcode('https://altospos.com'));
//   //   printer.add(gen.text('Hello'));
//   //   printer.add(gen.text('World', styles: const PosStyles(bold: true)));
//   //   printer.add(gen.feed(1));
//   //   await printer.printData(device);
//   //   device.disconnect();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     print(itemTrx.connected.value);
//     return Scaffold(
//         appBar: AppBar(title: const Text('Bluetooth devices')),
//         body: Obx(() => itemTrx.deviceBt.isEmpty
//             ? Center(
//                 child: Text(itemTrx.tips.isNotEmpty ? itemTrx.tips : 'Ops'))
//             : ListView.builder(
//                 itemCount: itemTrx.deviceBt.length,
//                 itemBuilder: (c, i) {
//                   return ListTile(
//                       leading: Icon(Icons.print),
//                       title: Text(itemTrx.deviceBt[i].name.toString()),
//                       subtitle: Text(itemTrx.deviceBt[i].address.toString()),
//                       onTap: () {
//                         startPrint(itemTrx.deviceBt[i]);
//                       });
//                 })));
//   }

//   Future<void> startPrint(BluetoothDevice deviceBt) async {
//     if (deviceBt.address != null && deviceBt.name != null) {
//       await itemTrx.bluetoothPrint.connect(deviceBt);
      
//       Map<String, dynamic> config = {};
//       List<LineText> list = [];

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content: 'DEALER SUSU',
//         width: 2,
//         height: 2,
//         weight: 2,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content: '==============================',
//         // width: 1,
//         // height: 1,
//         weight: 2,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));

//       for (var i = 0; i < itemTrx.detailHistoryTrx.length; i++) {
//         list.add(LineText(
//             type: LineText.TYPE_TEXT,
//             content: itemTrx.detailHistoryTrx[i].namaBarang,
//             weight: 0,
//             align: LineText.ALIGN_LEFT,
//             linefeed: 1));

//         list.add(LineText(
//             type: LineText.TYPE_TEXT,
//             content:
//                 '${itemTrx.detailHistoryTrx[i].totalItem.toString()} x ${itemTrx.detailHistoryTrx[i].hargaBarang.toString()}',
//             weight: 0,
//             align: LineText.ALIGN_LEFT,
//             linefeed: 1));
//       }
//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content: '==============================',
//         // width: 1,
//         // height: 1,
//         weight: 2,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));
//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content: 'Total ${itemTrx.detailHistoryTrx[0].total}',
//         width: 2,
//         height: 1,
//         weight: 1,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content: '==============================',
//         // width: 1,
//         // height: 1,
//         weight: 2,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content:
//             'Tunai ${NumberFormat.simpleCurrency(locale: 'id').format(itemTrx.detailHistoryTrx[0].pembayaran)}',
//         // width: 1,
//         // height: 1,
//         weight: 1,
//         align: LineText.ALIGN_RIGHT,
//         linefeed: 1,
//       ));

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content:
//             'Kembali ${NumberFormat.simpleCurrency(locale: 'id').format(itemTrx.detailHistoryTrx[0].kembalian)}\n\n\n',
//         // width: 1,
//         // height: 1,
//         weight: 1,
//         align: LineText.ALIGN_RIGHT,
//         linefeed: 1,
//       ));

//       list.add(LineText(
//         type: LineText.TYPE_TEXT,
//         content:
//             'Barang yang sudah dibeli,\ntidak dapat ditukar/dikembalikan.\nTerima kasih.',
//         // width: 1,
//         // height: 1,
//         // weight: 1,
//         align: LineText.ALIGN_CENTER,
//         linefeed: 1,
//       ));
//       await itemTrx.bluetoothPrint.printReceipt(config, list);
    
//     }
//   }
// }
