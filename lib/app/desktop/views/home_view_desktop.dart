import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_first_app/app/modules/home/controllers/home_controller.dart';
import 'package:my_first_app/app/service/repo.dart';

import '../../modules/stock/views/stock_view.dart';

class HomeViewDesktop extends GetView<HomeController> {
  HomeViewDesktop({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());
  PageController page = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar,
      backgroundColor: myDefaultBackground,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            // onDisplayModeChanged: (mode) {
            //   print(mode);
            // },
            style: SideMenuStyle(
              displayMode: mediaQuery.width > 1001 && mediaQuery.width <= 1100
                  ? SideMenuDisplayMode.compact
                  : SideMenuDisplayMode.open,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'POS App',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'POS App\nv.2022.08.11',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: () {
                  page.animateToPage(0,
                      duration: const Duration(seconds: 1), curve: Curves.easeIn);
                },
                icon: const Icon(Icons.home),
                badgeContent: const Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Stok',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Files',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Download',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.download),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Settings',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Exit',
                onTap: () async {},
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                // const HomeView(),
                // Container(
                //   color: Colors.white,
                //   child: const Center(
                //     child: Text(
                //       'Stok',
                //       style: TextStyle(fontSize: 35),
                //     ),
                //   ),
                // ),
                StockView(),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Files',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Download',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Row(

      //   children: <Widget>[
      //     Obx(
      //       () => NavigationRail(
      //         elevation: 10,
      //         selectedIndex: homeController.selectedIndex.value,
      //         onDestinationSelected: (int index) {
      //           homeController.selectedIndex.value = index;
      //         },
      //         labelType: NavigationRailLabelType.all,
      //         destinations: const <NavigationRailDestination>[
      //           NavigationRailDestination(
      //             icon: Icon(Icons.favorite_border),
      //             selectedIcon: Icon(Icons.favorite),
      //             label: Text('First'),
      //           ),
      //           NavigationRailDestination(
      //             icon: Icon(Icons.bookmark_border),
      //             selectedIcon: Icon(Icons.book),
      //             label: Text('Second'),
      //           ),
      //           NavigationRailDestination(
      //             icon: Icon(Icons.star_border),
      //             selectedIcon: Icon(Icons.star),
      //             label: Text('Third'),
      //           ),
      //         ],
      //       ),
      //     ),
      //     const VerticalDivider(thickness: 1, width: 1),
      //     // This is the main content.
      //     Expanded(
      //       child: Center(
      //         child: Obx(() =>
      //             Text('selectedIndex: ${homeController.selectedIndex.value}')),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
