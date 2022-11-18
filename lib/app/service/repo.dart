import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/app/modules/home/views/home_view.dart';
import 'package:my_first_app/app/modules/stock/views/stock_view.dart';
import 'package:my_first_app/app/modules/transaksi/views/transaksi_view.dart';
import 'package:my_first_app/app/settings/print_setting.dart';


// class Repo {
var apiUrl = 'http://103.112.139.155:9000/api';
var img = 'http://103.112.139.155:9000/product/';
var imgToko = 'http://103.112.139.155:9000/product/imgtoko/';
var imgLokal = 'http://103.112.139.155/api-pos/assets/product/';
var mediaQuery = Get.mediaQuery.size;

var myDefaultBackground = Colors.grey[300];

var myAppbar = AppBar(
  // title: const Text('HomeView'),
  // centerTitle: true,
  backgroundColor: Colors.grey[900],
);

var myDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  elevation: 20.0,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const SizedBox(height: 160, child: DrawerHeader(child: Icon(Icons.favorite))),
      ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text('D A S H B O A R D'),
          onTap: () =>
              Get.to(() => const HomeView(), transition: Transition.cupertino)),
      Expanded(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('S T O C K'),
              onTap:()=> Get.to(()=> StockView())
            ),
          
            ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('T R A N S A K S I'),
                onTap: () => Get.to(() => TransaksiView(),
                    transition: Transition.cupertino)),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('S E T T I N G  P R I N T E R'),
            onTap: () => Get.to(() => const PrintSetting(data: null,),
                    transition: Transition.cupertino)),
          ],
        ),
      )
    ],
  ),
);
// }
