import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';

Future<File> imageFromCamera(bool isCropped) async {
  File? result;
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear,
    imageQuality: 85,
  );
  if (pickedFile != null) {
    result = File(pickedFile.path);
    // if (isCropped) result = await cropImage(result);
  }

  return result!;
}

Future<File> imageFromGallery(bool isCropped) async {
  File? result;
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );
  if (pickedFile != null) {
    result = File(pickedFile.path);
    // if (isCropped) result = await cropImage(result);
  }

  return result!;
}

Future<File> cropImage(File imageFile) async {
  late File result;
  File? croppedFile = (await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      )
    ],
  )) as File?;

  result = croppedFile!;
  return result;
}

void showErrorSnackBar(
    BuildContext ctx, String message, String title, bool isError) {
  Get.snackbar(
    title,
    message,
    titleText:
        Text(title, style: const TextStyle(fontSize: 20, color: Colors.white)),
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(message,
        style: const TextStyle(fontSize: 20, color: Colors.white)),
    icon: const Icon(Icons.error_outline, size: 32, color: Colors.white),
    backgroundColor: isError ? Colors.red : Colors.green,
    isDismissible: true,
    margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
    duration: const Duration(seconds: 2),
    borderRadius: 20,
    boxShadows: [
      BoxShadow(
        color: Theme.of(ctx).shadowColor.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(4, 4),
      )
    ],
  );
}

Future<Iterable<Contact>> getMobileContacts() async {
  return await ContactsService.getContacts();
}
