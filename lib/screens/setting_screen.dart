import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_tube_1/screens/profile_screen.dart';

import '../controller/setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: SafeArea(
          child: GestureDetector(
            onTap: () {
              Get.to(const ProfileScreen());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'profileName',
                          child: Obx(
                            () => Text(
                              controller.userModel.value.name == ""
                                  ? "No name"
                                  : controller.userModel.value.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'View and edit profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: 'profileImage',
                    child: Obx(
                      () => controller.userModel.value.image == ""
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/default.png'),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                controller.userModel.value.image,
                              ),
                              maxRadius: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
                    leading: Icon(
                      Icons.language_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text("App Language"),
                    trailing: const Text("English"),
                  ),
                ),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
              leading: Icon(
                Icons.help_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text("Help"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
                    leading: Icon(
                      Icons.info_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text("About"),
                  ),
                ),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
              leading: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
