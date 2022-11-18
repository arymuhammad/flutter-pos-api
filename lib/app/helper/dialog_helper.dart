import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DialogHelper {

  //show error dialog
  void showErroDialog(
      {String title = 'Error', String? description = 'Something went wrong', String? notr}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline5,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.headline6,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Get.currentRoute;
                  //   return Future.value(true);
                  // if (Get.isDialogOpen!)
                  print(Get.currentRoute);
                  if (Get.currentRoute == '/HistoriTransaksiDetailView') {
                    // final trxDetail = Get.put(HistoriTransaksiDetailController());
                    // trxDetail.fetchDetailTrx('');
                  } else if (Get.currentRoute == '/HistoriTransaksiView') {
                    // trx.fetchDataHistory('', '', '');
                  }
                  Get.back();
                },
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show toast
  //show snack bar
  //show loading
  static void showLoading([String? message]) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
