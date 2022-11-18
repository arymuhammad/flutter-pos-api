import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_first_app/app/desktop/views/home_view_desktop.dart';
import 'package:my_first_app/app/modules/stock/views/stock_view.dart';
import 'package:my_first_app/app/modules/transaksi/views/transaksi_view.dart';
import '../../../service/repo.dart';
import '../../../settings/settings.dart';
import '../../historytransaksi/views/historytransaksi_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return mediaQuery.width > 1000
        ? HomeViewDesktop()
        : WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              await Get.defaultDialog(
                  title: 'Peringatan',
                  content: Container(
                    child: const Text(
                        'Anda yakin ingin keluar dari aplikasi ini?'),
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

              return willLeave;
            },
            child: Scaffold(
                body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 29, 30, 32),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 490),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(218, 228, 225, 225),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 410, 30, 10),
                  child: Container(
                    child: GridView.count(
                      crossAxisCount:
                          mediaQuery.width > 600 && mediaQuery.width < 1100
                              ? 4
                              : 2,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: myDefaultBackground,
                          child: InkWell(
                            onTap: () => Get.to(() => StockView()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset('asset/stocks.png'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Data Master (Stok)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: myDefaultBackground,
                          child: InkWell(
                            onTap: () => Get.to(() => TransaksiView()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset('asset/transaksi.png'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Transaksi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: myDefaultBackground,
                          child: InkWell(
                            onTap: () => Get.to(() => HistoryTransaksiView()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child:
                                        Image.asset('asset/report_sales.png'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Laporan Penjualan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: myDefaultBackground,
                          child: InkWell(
                            onTap: () => Get.to(() => SettingsView()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset('asset/setting.png'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Pengaturan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'asset/logo_app.png',
                          scale: 1.5,
                        ),
                      ),
                      const Text(
                        'POS App',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Versi 1.9.22',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            )),
          );
  }
}
