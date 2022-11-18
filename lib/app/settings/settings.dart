import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masked_text_field/masked_text_field.dart';
import '../helper/db_helper.dart';
import 'print_setting.dart';

class SettingsView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController ip = TextEditingController();
  final FocusNode myFocus = FocusNode();
  var dataIp = <IpServer>[];

  @override
  void initState() {
    super.initState();
    ipServer();
    // SQLHelper.instance.deleteIp();
  }

  ipServer() async {
    await SQLHelper.instance.getIp().then((data) {
      setState(() {
        dataIp = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pengaturan'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 29, 30, 32),
        ),
        body: SizedBox(
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                ListTile(
                  leading: const Icon(Icons.local_printshop_rounded),
                  title: const Text('Pengaturan Printer'),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => Get.to(() => const PrintSetting(data: null)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: const Text('Konfigurasi IP Address Server'),
                  subtitle: Text(
                      'IP Address : ${dataIp.isEmpty ? 'ip address belum di set' : dataIp.first.ipaddress}'),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Get.defaultDialog(
                      barrierDismissible: false,
                      radius: 5,
                      title: 'Koneksi Server',
                      content: TextField(
                      controller: ip,
                      autofocus: true,
                      decoration: const InputDecoration(
                      hintText: '192.168.100.13',
                      labelText: 'IP Address Server'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),),
                      cancel: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent[700]),
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            Get.back();
                          },
                          label: const Text('Batal')),
                      confirm: ElevatedButton.icon(
                          onPressed: () {
                            if (dataIp.isNotEmpty) {
                              if (ip.text != "") {
                                SQLHelper.instance
                                    .updateIp(ip.text, dataIp.first.ipaddress);
                                // historyCtr.uri.value = ip.text;
                                Fluttertoast.showToast(
                                    msg: "IP Address berhasil diperbarui.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.greenAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Get.back();
                                ip.clear();
                                ipServer();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "IP Address tidak boleh kosong.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              if (ip.text != "") {
                                SQLHelper.instance
                                    .insertIp(IpServer(ipaddress: ip.text));
                                Fluttertoast.showToast(
                                    msg: "IP Address berhasil ditambahkan",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.greenAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Get.back();
                                ip.clear();
                                ipServer();
                              }else{
                                Fluttertoast.showToast(
                                    msg: "IP Address tidak boleh kosong.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: dataIp.isNotEmpty
                              ? const Text('Update')
                              : const Text('Simpan')),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.man),
                  title: const Text('About'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AboutDialog(
                              applicationIcon: Image.asset(
                                'asset/logo_app.png',
                                scale: 3,
                              ),
                              applicationName: 'POS App',
                              applicationVersion: 'Versi 2022.09.12',
                              children: const [
                                Text(
                                    'POS App (Point Of Sales) adalah aplikasi yang berbasis mobile multi\nplatform (Android, IOS, Windows, Web)\n\nDibangun untuk membantu memudah\nkan dalam mengelola stok inventori, laporan penjualan, transaksi,dan fitur fitur lain untuk kedepan nya akan depelover kembangkan.\n\nPOS App dapat berjalan secara offline maupun online.\n\nUntuk info lanjut, kontak depelover \nademuhammad12@gmail.com')
                              ],
                            ));
                  },
                ),
                const Divider(),
              ]),
        ));
  }
}
