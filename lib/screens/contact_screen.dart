import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../widgets/contact_list_view.dart';

class ContactScreen extends GetView<ChatController> {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .backgroundColor,
          title: Text(
            'Contact',
            style: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .bodyText1
                  ?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            SizedBox(
              width: 60,
              height: 60,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      controller.getContact();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() => controller.isLoading.value == true
            ? const Center(child: Text('Loading'))
            : ListView.builder(
          itemCount: controller.contacts.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ContactListView(userModel: controller.contacts[index], callback: () {},);
          },))
    );
  }
}
