import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/app/modules/histori_transaksi_detail/views/histori_transaksi_detail_view.dart';
import 'package:my_first_app/app/service/repo.dart';

import '../../../helper/currency_format.dart';
import '../controllers/historytransaksi_controller.dart';

class HistoryTransaksiView extends GetView<HistorytransaksiController> {
  HistoryTransaksiView({Key? key}) : super(key: key);

  final historyCtr = Get.put(HistorytransaksiController());
  TextEditingController dateInputAwal = TextEditingController();
  TextEditingController dateInputAkhir = TextEditingController();
  TextEditingController searchData = TextEditingController();
  FocusNode searchFocus = FocusNode();
  int total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() => historyCtr.isSearch.value
              ? const Text('History Transaksi')
              : SizedBox(
                  child: TextField(
                    autofocus: true,
                    focusNode: searchFocus,
                    controller: searchData,
                    onChanged: (value) => historyCtr.filterDataTrx(value),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: -15),
                        hintText: 'Cari No Transaksi 3 digit terakhir',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none),
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorHeight: 20,
                  ),
                )),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 29, 30, 32),
          actions: [
            Obx(() => historyCtr.isSearch.value
                ? IconButton(
                    onPressed: () {
                      // print(salesCtr.isSearch.value);
                      historyCtr.isSearch.value = false;
                    },
                    icon: const Icon(Icons.search),
                    tooltip: 'Cari',
                  )
                : IconButton(
                    onPressed: () {
                      historyCtr.isSearch.value = true;
                      searchData.clear();
                      // salesCtr.searchSales.length;
                      historyCtr.filterDataTrx('');
                    },
                    icon: const Icon(Icons.cancel),
                    tooltip: 'Hapus',
                  )),
            IconButton(
              onPressed: () => filterTrx(),
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Filter',
            )
          ],
        ),
        backgroundColor: myDefaultBackground,
        body: Obx(() => historyCtr.isLoading.value
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
            : historyCtr.searchTrx.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Tidak ada data ${searchData.text}'),
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
                              'Menampilkan ${historyCtr.searchTrx.length} baris data'),
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 15,
                        child: Container(
                          child: ListView.builder(
                              itemCount: historyCtr.searchTrx.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                int sum = historyCtr.searchTrx
                                    .fold(0, (total, dst) => total + dst.total);
                                total = sum;
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() => HistoriTransaksiDetailView(),
                                          arguments: {
                                            "notrx": historyCtr
                                                .searchTrx[index].noTrx
                                                .toString(),
                                            "total": historyCtr
                                                .searchTrx[index].total
                                          },
                                          transition: Transition.zoom);
                                      // detailTrx.noTrx.value =
                                      //     historyCtr.searchTrx[index].noTrx;
                                      // print(detailTrx.noTrx.value);
                                    },
                                    title: Text(
                                        'No Transaksi ${historyCtr.searchTrx[index].noTrx}'),
                                    subtitle: Text(
                                        'Grand Total ${CurrencyFormat.convertToIdr(historyCtr.searchTrx[index].total, 0)}\nTotal item ${historyCtr.searchTrx[index].pcs} (pcs)'),
                                    trailing: Text(DateFormat(" d MMM yyyy")
                                        .format(DateTime.parse(historyCtr
                                            .searchTrx[index].tanggal))),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Memuat ${historyCtr.searchTrx.length} baris data',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  'Total ${CurrencyFormat.convertToIdr(historyCtr.searchTrx[0].totalTrx, 0).toString()}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  )));
  }

  filterTrx() {
    return Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: 280,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Tanggal History Transaksi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                DateTimeField(
                  controller: dateInputAwal,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      hintText: 'Tanggal Awal',
                      border: OutlineInputBorder()),
                  format: DateFormat("yyyy-MM-dd"),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                DateTimeField(
                  controller: dateInputAkhir,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      hintText: 'Tanggal Akhir',
                      border: OutlineInputBorder()),
                  format: DateFormat("yyyy-MM-dd"),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Obx(
                //   (() => DropdownButtonFormField<String>(
                //         decoration:
                //             InputDecoration(border: OutlineInputBorder()),
                //         isExpanded: true,
                //         hint: Text('Limit data'),
                //         icon: Icon(Icons.list_alt),
                //         value: historyCtr.selectedItem.value == ""
                //             ? null
                //             : historyCtr.selectedItem.value,
                //         items: historyCtr.selected.map((value) {
                //           // print(salesCtr.selectedItem.value);
                //           return DropdownMenuItem(
                //             value: value,
                //             child: Text(value),
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           historyCtr.selectedItem.value = value!;
                //         },
                //         selectedItemBuilder: (ctx) => historyCtr.selected
                //             .map((e) => Text(
                //                   e,
                //                   style: const TextStyle(
                //                       // fontSize: 18,
                //                       // color: Colors.amber,
                //                       // fontStyle: FontStyle.italic,
                //                       // fontWeight: FontWeight.bold
                //                       ),
                //                 ))
                //             .toList(),
                //       )),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          // SalesController().fetchSales(tgl1, tgl2);
                          // ignore: unrelated_type_equality_checks
                          if (dateInputAwal.text == "" ||
                              dateInputAkhir.text == "" ||
                              DateTime.parse(dateInputAkhir.text).isBefore(
                                  DateTime.parse(dateInputAwal.text))) {
                            // ignore: void_checks
                            return modalError(
                                dateInputAwal.text, dateInputAkhir.text);
                          } else {
                            historyCtr.fetchDataHistory(
                                dateInputAwal.text, dateInputAkhir.text
                                // historyCtr.selectedItem.value
                                );
                            historyCtr.isLoading.value = true;
                            Get.back();
                            dateInputAwal.clear();
                            dateInputAkhir.clear();
                            historyCtr.selectedItem.value = '';
                          }
                        },
                        icon: const Icon(Icons.save_as),
                        label: const Text('S E T'),
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          minimumSize: const Size(130, 50),
                          maximumSize: const Size(130, 50),
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
        isDismissible: false);
  }

  modalError(String tgl1, String tgl2) {
    return Get.defaultDialog(
      title: "Perhatian",
      content: Text(tgl1 == '' && tgl2 == ''
          ? 'Tanggal awal atau tanggal akhir tidak boleh kosong!\nHarap isi tanggal pencarian.'
          : 'Tanggal akhir tidak boleh lebih kecil dari tanggal awal!'),
      confirm:
          ElevatedButton(onPressed: () => Get.back(), child: const Text('OK')),
      barrierDismissible: false,
      radius: 8,
    );
  }
}
