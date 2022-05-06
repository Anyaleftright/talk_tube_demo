import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';
import 'call_screen.dart';
import 'chat_list_screen.dart';
import 'contact_screen.dart';
import 'setting_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          onTap: (index){
            controller.onItemClick(index);
            controller.pageController.jumpToPage(index);
          },
          key: controller.bottomNavigationKey,
          color: Theme.of(context).primaryColor,
          index: controller.page.value,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            Icon(Icons.chat_rounded, size: 30, color: Colors.white),
            Icon(Icons.contacts_rounded, size: 30, color: Colors.white),
            Icon(Icons.phone_rounded, size: 30, color: Colors.white),
            Icon(Icons.settings_rounded, size: 30, color: Colors.white),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          ChatListScreen(),
          ContactScreen(),
          CallScreen(),
          SettingScreen(),
        ],
      ),
    );
  }
}
