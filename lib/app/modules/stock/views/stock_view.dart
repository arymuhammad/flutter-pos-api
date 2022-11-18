import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/service/repo.dart';
import 'package:my_first_app/app/service/service_api.dart';

import '../../../helper/currency_format.dart';
import '../controllers/stock_controller.dart';

class StockView extends GetView<StockController> {
  StockView({Key? key}) : super(key: key);

  final masterCtr = Get.put(StockController());
  TextEditingController artikel = TextEditingController();
  TextEditingController inputKodeBarang = TextEditingController();
  TextEditingController inputNamaBarang = TextEditingController();
  TextEditingController inputHargaBarang = TextEditingController();
  TextEditingController inputJumlahBarang = TextEditingController();
  TextEditingController inputHargaUpdate = TextEditingController();
  TextEditingController inputSisaUpdate = TextEditingController();
  TextEditingController inputNamaUpdate = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNodeKode = FocusNode();
  FocusNode myFocusNodeNama = FocusNode();
  FocusNode myFocusNodeHarga = FocusNode();
  FocusNode myFocusNodeStatus = FocusNode();
  FocusNode myFocusNodeQty = FocusNode();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Master (Stok)'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 29, 30, 32),
        actions: [
          IconButton(
            onPressed: () {
              masterCtr.fetchdataMaster();
              masterCtr.isLoading.value = true;
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh',
          )
        ],
      ),
      backgroundColor: myDefaultBackground,
      body: Obx(() {
        print('total data : ${masterCtr.dataMaster.length}');
        return masterCtr.isLoading.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading...')
                  ],
                ),
              )
            : masterCtr.dataMaster.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Tidak ada data ${artikel.text}'),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Menampilkan ${masterCtr.dataMaster.length} baris data'),
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      masterCtr.dataMaster.isNotEmpty
                          ? Expanded(
                              child: GridView.count(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  // padding: EdgeInsets.all(8),
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  children: List.generate(
                                      masterCtr.dataMaster.length, (index) {
                                    int sisa = 0;

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          updateData(
                                              masterCtr
                                                  .dataMaster[index].kodeBarang,
                                              masterCtr
                                                  .dataMaster[index].namaBarang,
                                              masterCtr.dataMaster[index]
                                                  .hargaBarang,
                                              masterCtr.dataMaster[index].stok);
                                        },
                                        child: Card(
                                          semanticContainer: true,
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    BarcodeWidget(
                                                        barcode:
                                                            Barcode.codabar(),
                                                        data: masterCtr
                                                            .dataMaster[index]
                                                            .kodeBarang
                                                            .toString(),
                                                        height: 100,
                                                        width: 320,
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${masterCtr.dataMaster[index].namaBarang}\n${masterCtr.dataMaster[index].kodeBarang}',
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      fontFamily: 'avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Stock : ${masterCtr.dataMaster[index].stok}',
                                                  style: const TextStyle(
                                                    fontFamily: 'avenir',
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      int.parse(masterCtr
                                                          .dataMaster[index]
                                                          .hargaBarang
                                                          .toString()),
                                                      0),
                                                  style: const TextStyle(
                                                    fontFamily: 'avenir',
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                            )
                          : Text('Tidak ada data barang ${artikel.text}'),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Menampilkan ${masterCtr.dataMaster.length} dari ${masterCtr.dataMaster.first.totalData} data stok'),
                        ),
                      )
                    ],
                  );
      }),
      floatingActionButton: SpeedDial(
          elevation: 8,
          overlayOpacity: 0,
          icon: Icons.menu_rounded,
          activeIcon: Icons.close,
          backgroundColor: const Color.fromARGB(255, 29, 30, 32),
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              label: 'Filter',
              backgroundColor: const Color.fromARGB(255, 29, 30, 32),
              onTap: () {
                filterData();
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: 'Cari',
              backgroundColor: const Color.fromARGB(255, 29, 30, 32),
              onTap: () {
                cariBarang();
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              label: 'Tambah Data',
              backgroundColor: const Color.fromARGB(255, 29, 30, 32),
              onTap: () {
                tambahMaster();
              },
            ),
          ]),
    );
  }

  tambahMaster() {
    Get.bottomSheet(
        Container(
          height: 356,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Input Data Master Barang (Stock)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: inputKodeBarang,
                    autofocus: true,
                    focusNode: myFocusNodeKode,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Kode Barang'),
                        suffixIcon: IconButton(
                            onPressed: () {
                              scanBarcode();
                            },
                            icon: const Icon(Icons.qr_code))),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    autofocus: true,
                    focusNode: myFocusNodeNama,
                    controller: inputNamaBarang,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Nama Barang'),
                        suffixIcon: const Icon(Icons.paste_rounded)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: inputHargaBarang,
                    autofocus: true,
                    focusNode: myFocusNodeHarga,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Harga'),
                        suffixIcon: const Icon(Icons.price_check_rounded)),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: inputJumlahBarang,
                    autofocus: true,
                    focusNode: myFocusNodeQty,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Quantity Input (pcs)'),
                      suffixIcon: const Icon(Icons.note_alt_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(Icons.save_as),
                        label: const Text('S I M P A N'),
                        onPressed: () async {
                          if (inputKodeBarang.text == "" &&
                              inputNamaBarang.text == "" &&
                              inputHargaBarang.text == "" &&
                              inputJumlahBarang.text == "") {
                            Get.snackbar('Warning',
                                'Data Master tidak boleh ada yang kosong. Harap dilengkapi semua datanya.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ));
                            myFocusNodeKode.requestFocus();
                          } else if (inputNamaBarang.text == "") {
                            Get.snackbar(
                                'Warning', 'Nama Barang tidak boleh kosong.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ));
                            myFocusNodeNama.requestFocus();
                          } else if (inputKodeBarang.text == "") {
                            Get.snackbar(
                                'Warning', 'Kode Barang tidak boleh kosong.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ));
                            myFocusNodeKode.requestFocus();
                          } else if (inputHargaBarang.text == "") {
                            Get.snackbar('Warning', 'Harga tidak boleh kosong.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ));
                            myFocusNodeHarga.requestFocus();
                          } else if (inputJumlahBarang.text == "") {
                            Get.snackbar(
                                'Warning', 'Quantity Input tidak boleh kosong.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent[700],
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ));
                            myFocusNodeQty.requestFocus();
                          } else {
                            var dataMaster = {
                              "kode_barang": inputKodeBarang.text,
                              "nama_barang": inputNamaBarang.text,
                              "harga_barang": inputHargaBarang.text,
                              "stok": inputJumlahBarang.text,
                              "created_at": DateFormat('yyyy-MM-dd H:mm:ss')
                                  .format(DateTime.now())
                                  .toString()
                            };
                            await masterCtr.getDataItem(inputKodeBarang.text);
                            // for (var i in masterCtr.dataMaster) {
                            // print('kode barang: ${i.kodeBarang}');
                            if (masterCtr.dtSearch.isNotEmpty &&
                                masterCtr.dtSearch.first.kodeBarang ==
                                    int.parse(inputKodeBarang.text)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Kode Barang sudah terdaftar.\nHarap cek kembali.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              await ServiceApi().inputDataMaster(dataMaster);
                              masterCtr.fetchdataMaster();
                              masterCtr.isLoading.value = true;
                              inputKodeBarang.clear();
                              inputNamaBarang.clear();
                              inputHargaBarang.clear();
                              inputJumlahBarang.clear();
                              Get.back();

                              Fluttertoast.showToast(
                                  msg: "Data berhasil diinput.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.greenAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            // }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          minimumSize: const Size(135, 50),
                          maximumSize: const Size(135, 50),
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          if (inputKodeBarang.text != "" ||
                              inputNamaBarang.text != "" ||
                              inputHargaBarang.text != "" ||
                              inputJumlahBarang.text != "") {
                            Get.defaultDialog(
                                title: 'Warning',
                                content: const Text(
                                    'Anda Yakin ingin membatalkan proses ini?\nData tidak akan disimpan'),
                                confirm: ElevatedButton(
                                    onPressed: () {
                                      inputKodeBarang.clear();
                                      inputNamaBarang.clear();
                                      inputHargaBarang.clear();
                                      inputJumlahBarang.clear();
                                      masterCtr.selectedItem.value = '';
                                      Get.back();
                                      Get.back();
                                    },
                                    child: const Text('Ya')),
                                cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Batal'),
                                ));
                          } else {
                            Get.back();
                          }
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('B A T A L'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 15,
                          minimumSize: const Size(200, 50),
                          maximumSize: const Size(200, 50),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
        isScrollControlled: true);
  }

  updateData(kode, nama, harga, stok) {
    Get.defaultDialog(
        radius: 10,
        title: 'Update Master Barang',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(),
            TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: kode.toString(),
                    hintStyle: const TextStyle(color: Colors.black))),
            const SizedBox(
              height: 10,
            ),
            TextField(
                // readOnly: true,
                controller: inputNamaUpdate,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: nama.toString(),
                    hintStyle: const TextStyle(color: Colors.black))),
            const SizedBox(
              height: 10,
            ),
            TextField(
              // readOnly: true,
              controller: inputHargaUpdate,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText:
                    'Harga sebelumnya ${CurrencyFormat.convertToIdr(harga, 0)}',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              // readOnly: true,
              controller: inputSisaUpdate,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Stock sisa ${stok.toString()} pcs',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      var hargaUpdate = "";
                      var stokUpdate = "";
                      var namaUpdate = "";
                      if (inputHargaUpdate.text == "") {
                        hargaUpdate = harga.toString();
                      } else {
                        hargaUpdate = inputHargaUpdate.text;
                      }

                      if (inputSisaUpdate.text == "") {
                        stokUpdate = stok.toString();
                      } else {
                        stokUpdate = inputSisaUpdate.text;
                      }

                      if (inputNamaUpdate.text == "") {
                        namaUpdate = nama.toString();
                      } else {
                        namaUpdate = inputNamaUpdate.text;
                      }

                      var updated = {
                        "kode_barang": kode.toString(),
                        "nama_barang": namaUpdate.toString(),
                        "harga_barang": hargaUpdate.toString(),
                        "stok": stokUpdate.toString(),
                      };

                      await ServiceApi().updateMasterBarang(updated);

                      masterCtr.getDataItem(kode.toString());
                      Get.back();
                      masterCtr.isLoading.value = true;
                      inputHargaUpdate.clear();
                      inputSisaUpdate.clear();

                      Fluttertoast.showToast(
                          msg: "Data berhasil diupdate.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.greenAccent[700],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    icon: const Icon(Icons.update_rounded),
                    label: const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent[700],
                      elevation: 15,
                      minimumSize: const Size(140, 50),
                      maximumSize: const Size(140, 50),
                    )),
                ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Batal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent[700],
                      elevation: 15,
                      minimumSize: const Size(120, 50),
                      maximumSize: const Size(120, 50),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  Get.defaultDialog(
                      title: 'Peringatan',
                      content: Text(
                          'Anda ingin menghapus data barang ini?\n- $nama'),
                      confirm: ElevatedButton(
                          onPressed: () async {
                            var barcodeMaster = {
                              'kode_barang': kode.toString()
                            };

                            await ServiceApi()
                                .deleteMasterBarang(barcodeMaster);
                            // masterCtr.delete(kode);
                            Get.back();
                            Get.back();
                            masterCtr.fetchdataMaster();
                            // masterCtr.getData();
                            masterCtr.isLoading.value = true;

                            Fluttertoast.showToast(
                                msg: "Data berhasil dihapus.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent[700],
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: const Text('Oke')),
                      cancel: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Batal')));
                },
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Hapus Data Barang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[700],
                  elevation: 15,
                  minimumSize: const Size(double.maxFinite, 50),
                  maximumSize: const Size(double.maxFinite, 50),
                )),
          ],
        ),
        barrierDismissible: false);
  }

  void scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
      inputKodeBarang.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  void scanCariBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
      artikel.text = barcodeScanRes;
      Get.back();
      await masterCtr.getDataItem(barcodeScanRes);
      artikel.clear();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  cariBarang() {
    Get.defaultDialog(
        radius: 10,
        title: 'Cari Data Barang',
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                focusNode: myFocusNode,
                controller: artikel,
                onSubmitted: (value) async {
                  // print(artikel.text.length);
                  if (value.isNotEmpty) {
                    await masterCtr.getDataItem(value);
                    // masterCtr.isLoading.value = true;
                    // masterCtr.isLengthData.value = artikel.text.length;
                    artikel.clear();
                    Get.back();
                  } else {
                    Get.defaultDialog(
                        radius: 10,
                        title: 'Peringatan',
                        content: const Center(
                            child: Text(
                                'Data tidak boleh kosong!\nHarap masukkan nama barang yang ingin dicari.')),
                        confirm: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              myFocusNode.requestFocus();
                            },
                            child: const Text('OK')),
                        barrierDismissible: false);
                  }
                },
                decoration: InputDecoration(
                    label: const Text('Nama / Kode Barang'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Icons.search),
                    prefixIcon: IconButton(
                      onPressed: () {
                        scanCariBarcode();
                      },
                      icon: const Icon(Icons.qr_code_2),
                    )),
              ),
            ),
          ],
        ));
  }

  filterData() {
    Get.bottomSheet(
        Container(
          height: 200,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Limit Tampilkan Data Master',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 60,
                  child: Obx(
                    (() => DropdownButtonFormField<String>(
                          autofocus: true,
                          focusNode: myFocusNodeStatus,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          isExpanded: true,
                          hint: const Text('Limit'),
                          icon: const Icon(Icons.list_alt),
                          value: masterCtr.selectedItem.value == ""
                              ? null
                              : masterCtr.selectedItem.value,
                          items: masterCtr.selected.map((value) {
                            // print(masterCtr.selectedItem.value);
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            masterCtr.selectedItem.value = value!;
                          },
                          selectedItemBuilder: (ctx) => masterCtr.selected
                              .map((e) => Text(
                                    e,
                                    style: const TextStyle(
                                        // fontSize: 18,
                                        // color: Colors.amber,
                                        // fontStyle: FontStyle.italic,
                                        // fontWeight: FontWeight.bold
                                        ),
                                  ))
                              .toList(),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(Icons.save_as),
                        label: const Text('S E T'),
                        onPressed: () async {
                          if (masterCtr.selectedItem.value == "") {
                            Fluttertoast.showToast(
                                msg: "Pilih limit yang tersedia.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent[700],
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            masterCtr
                                .getDataFilter(masterCtr.selectedItem.value);
                            masterCtr.isLoading.value = true;

                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          minimumSize: const Size(135, 50),
                          maximumSize: const Size(135, 50),
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('B A T A L'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 15,
                          minimumSize: const Size(200, 50),
                          maximumSize: const Size(200, 50),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
        isScrollControlled: true);
  }
}
