import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_first_app/app/modules/home/views/home_view.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'app/routes/app_pages.dart';
import 'package:appspector/appspector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runAppSpector();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(
        GetMaterialApp(
          title: "POS App",
          // home: ResponsiveLayout(mobileBody: const HomeViewMobile(), tabletBody: const Homeviewtablet(), desktopBody: const HomeViewDesktop()),
          theme: ThemeData(fontFamily: 'Nunito'),
          home: SplashScreenView(
            navigateRoute: const HomeView(),
            duration: 3500,
            imageSize: 140,
            imageSrc: "asset/logo_app.png",
            text: "POS App",
            textType: TextType.TyperAnimatedText,
            textStyle: const TextStyle(
              fontSize: 40.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
            // colors: const [
            //   Colors.purple,
            //   Colors.blue,
            //   Colors.yellow,
            //   Colors.red,
            // ],
            backgroundColor: const Color.fromARGB(255, 29, 30, 32),
          ),
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        ),
      ));
}

void runAppSpector() {
  final config = Config()
    ..iosApiKey = "Your iOS API_KEY"
    ..androidApiKey =
        "android_YTY4NTYzNmYtYzE4OS00YWI2LWEwZTgtNDNmMDcyNmZhZmU3";

  // If you don't want to start all monitors you can specify a list of necessary ones
  config.monitors = [
    Monitors.http,
    Monitors.logs,
    Monitors.screenshot,
    Monitors.location,
    Monitors.performance,
    Monitors.sqLite,
    Monitors.fileSystem
  ];

  AppSpectorPlugin.run(config);
}
