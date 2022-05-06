import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_tube_1/models/user_model.dart';
import 'package:talk_tube_1/network/app_firebase.dart';
import 'package:talk_tube_1/others/app_permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../others/app_util.dart';

class SettingController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controllerText = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AppPermission appPermission = AppPermission();
  final isLoading = RxBool(false);
  AppFirebase appFirebase = AppFirebase();
  Rx<UserModel> userModel = UserModel(
    uid: "",
    name: "",
    image: "",
    number: "",
    status: "",
    typing: "",
    online: "",
  ).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser?.uid)
        .get()
        .then((value) {
      if (value.exists) {
        userModel.value =
            UserModel.fromJson(value.data() as Map<String, dynamic>);
      }
    });
  }

  void updateStatus(String status, BuildContext context) {
    controllerText.clear();
    Get.back();
    isLoading(true);
    appFirebase.updateStatus(status, auth.currentUser!.uid).then((value) {
      if (value != null) {
        isLoading(false);
        userModel.value.status = value;
      } else {
        showErrorSnackBar(context, 'Failed to update status', 'Status error', true);
      }
    });
  }

  void updateName(String name, BuildContext context) {
    controllerText.clear();
    Get.back();
    isLoading(true);
    appFirebase.updateStatus(name, auth.currentUser!.uid).then((value) {
      if (value != null) {
        isLoading(false);
        userModel.value.name = value;
      } else {
        showErrorSnackBar(context, 'Failed to update name', 'Name error', true);
      }
    });
  }

  void updateDialog(BuildContext context, String title, bool isName) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "$title",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controllerText,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        if (isName) {
                          updateName(value, context);
                        } else {
                          updateStatus(value, context);
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: isName ? 'name' : 'status',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          controllerText.clear();
                          Get.back();
                        },
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          if(controllerText.text.trim().isNotEmpty){
                            if(isName){
                              updateName(controllerText.text.trim(), context);
                            } else {
                              updateStatus(controllerText.text.trim(), context);
                            }
                          }
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imageFromCamera(true);
        isLoading(true);
        String imagePath = await appFirebase.uploadUserImage(
          'profile/image',
          auth.currentUser!.uid,
          file,
        );
        appFirebase.updateImage(imagePath, auth.currentUser!.uid).then((value) {
          if(value != null){
            isLoading(false);
            userModel.value.image=value;
          }
        });
        break;
      case ImageSource.gallery:
        File file = await imageFromGallery(true);
        isLoading(true);
        String imagePath = await appFirebase.uploadUserImage(
          'profile/image',
          auth.currentUser!.uid,
          file,
        );
        appFirebase.updateImage(imagePath, auth.currentUser!.uid).then((value) {
          if(value != null){
            isLoading(false);
            userModel.value.image=value;
          }
        });
        break;
    }
  }

  void showPicker(BuildContext context) {
    Get.bottomSheet(
        SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text("Photo Library"),
                  onTap: () async {
                    Navigator.pop(context);
                    var status = await appPermission.isStoragePermissionOk();
                    switch (status) {
                      case PermissionStatus.denied:
                        var status =
                            await Permission.storage.request().isDenied;
                        if (!status) {
                          getImage(ImageSource.gallery);
                        } else {
                          showErrorSnackBar(context, 'Storage Permission Denied', 'Permission Error', true);
                        }
                        break;
                      case PermissionStatus.granted:
                        getImage(ImageSource.gallery);
                        break;
                      case PermissionStatus.restricted:
                        showErrorSnackBar(context, 'Storage Permission Denied', 'Permission Error', true);
                        break;
                      case PermissionStatus.limited:
                        showErrorSnackBar(context, 'Storage Permission Denied', 'Permission Error', true);
                        break;
                      case PermissionStatus.permanentlyDenied:
                        await openAppSettings();
                        break;
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text("Camera"),
                  onTap: () async {
                    Navigator.pop(context);
                    var status = await appPermission.isCameraPermissionOk();
                    switch (status) {
                      case PermissionStatus.denied:
                        var status = await Permission.camera.request().isDenied;
                        if (!status) {
                          getImage(ImageSource.camera);
                        } else {
                          showErrorSnackBar(context, 'Camera Permission Denied', 'Permission Error', true);
                        }
                        break;
                      case PermissionStatus.granted:
                        getImage(ImageSource.camera);
                        break;
                      case PermissionStatus.restricted:
                        showErrorSnackBar(context, 'Camera Permission Denied', 'Permission Error', true);
                        break;
                      case PermissionStatus.limited:
                        showErrorSnackBar(context, 'Camera Permission Denied', 'Permission Error', true);
                        break;
                      case PermissionStatus.permanentlyDenied:
                        await openAppSettings();
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
  }
}
