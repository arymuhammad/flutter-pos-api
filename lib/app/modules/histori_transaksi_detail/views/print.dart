// import 'dart:io';
// import 'dart:typed_data';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:my_first_app/app/modules/histori_transaksi_detail/controllers/histori_transaksi_detail_controller.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart' hide Image;
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:flutter/services.dart';
// // import 'package:ping_discover_network/ping_discover_network.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:image/image.dart';
// // import 'package:wifi/wifi.dart';

// import '../../../helper/currency_format.dart';

// class PrintPage extends GetView<HistoriTransaksiDetailController> {
//   PrintPage({Key? key}) : super(key: key);

//   final itemCtr = Get.put(HistoriTransaksiDetailController());

//   Future<void> testReceipt(NetworkPrinter printer) async {
//     printer.text(
//         'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//     printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
//         styles: PosStyles(codeTable: 'CP1252'));
//     printer.text('Special 2: blåbærgrød',
//         styles: PosStyles(codeTable: 'CP1252'));

//     printer.text('Bold text', styles: PosStyles(bold: true));
//     printer.text('Reverse text', styles: PosStyles(reverse: true));
//     printer.text('Underlined text',
//         styles: PosStyles(underline: true), linesAfter: 1);
//     printer.text('Align left', styles: PosStyles(align: PosAlign.left));
//     printer.text('Align center', styles: PosStyles(align: PosAlign.center));
//     printer.text('Align right',
//         styles: PosStyles(align: PosAlign.right), linesAfter: 1);

//     printer.row([
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col6',
//         width: 6,
//         styles: PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: PosStyles(align: PosAlign.center, underline: true),
//       ),
//     ]);

//     printer.text('Text size 200%',
//         styles: PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ));

//     // Print image
//     final ByteData data = await rootBundle.load('asset/logo.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Image? image = decodeImage(bytes);
//     printer.image(image!);
//     // Print image using alternative commands
//     // printer.imageRaster(image);
//     // printer.imageRaster(image, imageFn: PosImageFn.graphics);

//     // Print barcode
//     final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     printer.barcode(Barcode.upcA(barData));

//     // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
//     // printer.text(
//     //   'hello ! 中文字 # world @ éphémère &',
//     //   styles: PosStyles(codeTable: PosCodeTable.westEur),
//     //   containsChinese: true,
//     // );

//     printer.feed(2);
//     printer.cut();
//   }

//   Future<void> printDemoReceipt(NetworkPrinter printer) async {
//     // Print image
//     final ByteData data = await rootBundle.load('asset/logo_print.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Image? image = decodeImage(bytes);
//     printer.image(image!);

//     // printer.text('POS App',
//     //     styles: PosStyles(
//     //       align: PosAlign.center,
//     //       height: PosTextSize.size2,
//     //       width: PosTextSize.size2,
//     //     ),
//     //     linesAfter: 1);
//     printer.hr();

//     final now = DateTime.now();
//     final formatter = DateFormat('MM/dd/yyyy H:m');
//     final String timestamp = formatter.format(now);

//     printer.row([
//       PosColumn(
//           text: 'No Transaksi',
//           width: 4,
//           styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
//       PosColumn(
//           text: itemCtr.detailHistoryTrx[0].noTrx.toString(),
//           width: 4,
//           styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
//       PosColumn(
//           text: "",
//           width: 4,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
//     ]);
//     printer.row([
//       PosColumn(
//           text: timestamp.toString(),
//           width: 4,
//           styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
//       PosColumn(
//           text: "",
//           width: 8,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
//     ]);

//     printer.hr();
//     printer.row([
//       PosColumn(text: 'Qty', width: 1),
//       PosColumn(text: 'Item', width: 7),
//       PosColumn(
//           text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
//     ]);

//     for (var i in itemCtr.detailHistoryTrx) {
//       printer.row([
//         PosColumn(text: '${i.totalItem}', width: 1),
//         PosColumn(text: i.namaBarang, width: 7),
//         PosColumn(
//             text: '${i.hargaBarang}',
//             width: 2,
//             styles: PosStyles(align: PosAlign.right)),
//         PosColumn(
//             text: '${i.hargaBarang * i.totalItem}',
//             width: 2,
//             styles: PosStyles(align: PosAlign.right)),
//       ]);
//     }

//     printer.hr();
//     printer.row([
//       PosColumn(
//           text: 'GRAND TOTAL',
//           width: 6,
//           styles: PosStyles(
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(
//           text:
//               '${NumberFormat.simpleCurrency(locale: 'id').format(itemCtr.detailHistoryTrx[0].total)}',
//           width: 6,
//           styles: PosStyles(
//             align: PosAlign.right,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//     ]);

//     printer.hr(ch: '=', linesAfter: 1);

//     printer.row([
//       PosColumn(
//           text: 'Cash',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//       PosColumn(
//           text:
//               '${NumberFormat.simpleCurrency(locale: 'id').format(itemCtr.detailHistoryTrx[0].pembayaran)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//     ]);
//     printer.row([
//       PosColumn(
//           text: 'Kembali',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//       PosColumn(
//           text:
//               '${NumberFormat.simpleCurrency(locale: 'id').format(itemCtr.detailHistoryTrx[0].kembalian)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
//     ]);

//     printer.feed(2);
//     printer.text('Barang yang sudah dibeli tidak dapat ditukar/\ndikembalikan.',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//     printer.text('Terima kasih telah belanja di toko kami.',
//         styles: PosStyles(align: PosAlign.center, bold: true));

//     // Print QR Code from image
//     // try {
//     //   const String qrData = 'example.com';
//     //   const double qrSize = 200;
//     //   final uiImg = await QrPainter(
//     //     data: qrData,
//     //     version: QrVersions.auto,
//     //     gapless: false,
//     //   ).toImageData(qrSize);
//     //   final dir = await getTemporaryDirectory();
//     //   final pathName = '${dir.path}/qr_tmp.png';
//     //   final qrFile = File(pathName);
//     //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
//     //   final img = decodeImage(imgFile.readAsBytesSync());

//     //   printer.image(img);
//     // } catch (e) {
//     //   print(e);
//     // }

//     // Print QR Code using native function
//     // printer.qrcode('example.com');

//     printer.feed(1);
//     printer.cut();
//   }

//   testPrint(String printerIp, BuildContext ctx) async {
//     // TODO Don't forget to choose printer's paper size
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);

//     final PosPrintResult res =
//         await printer.connect("192.168.100.15", port: 9100);

//     if (res == PosPrintResult.success) {
//       // DEMO RECEIPT
//       await printDemoReceipt(printer);
//       // TEST PRINT
//       // await testReceipt(printer);
//       printer.disconnect();
//     }

//     final snackBar =
//         SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
//     Scaffold.of(ctx).showSnackBar(snackBar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover Printers'),
//       ),
//       body: Builder(
//         builder: (BuildContext context) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 TextField(
//                   controller: itemCtr.portController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Port',
//                     hintText: 'Port',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Local ip: ${itemCtr.localIp}',
//                     style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 15),
//                 RaisedButton(
//                     child: Text(
//                         '${itemCtr.isDiscovering.value ? 'Discovering...' : 'Discover'}'),
//                     onPressed: itemCtr.isDiscovering.value
//                         ? null
//                         : () => itemCtr.discover(context)),
//                 SizedBox(height: 15),
//                 itemCtr.found >= 0
//                     ? Text('Found: ${itemCtr.found} device(s)',
//                         style: TextStyle(fontSize: 16))
//                     : Container(),
//                 Obx(
//                   () => Expanded(
//                     child: ListView.builder(
//                       itemCount: itemCtr.devices.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return InkWell(
//                           onTap: () =>
//                               testPrint(itemCtr.devices[index], context),
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 height: 60,
//                                 padding: EdgeInsets.only(left: 10),
//                                 alignment: Alignment.centerLeft,
//                                 child: Row(
//                                   children: <Widget>[
//                                     Icon(Icons.print),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             '${itemCtr.devices[index]}:${itemCtr.portController.text}',
//                                             style: TextStyle(fontSize: 16),
//                                           ),
//                                           Text(
//                                             'Click to print a test receipt',
//                                             style: TextStyle(
//                                                 color: Colors.grey[700]),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Icon(Icons.chevron_right),
//                                   ],
//                                 ),
//                               ),
//                               Divider(),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
