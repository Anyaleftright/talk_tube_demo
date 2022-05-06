import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_tube_1/models/user_model.dart';
import 'package:talk_tube_1/screens/verification_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class AppFirebase {
  Future<void> sendVerificationCode(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) {
          printInfo(info: "user verified");
        },
        verificationFailed: (FirebaseAuthException e) {
          printError(info: e.message!);
        },
        codeSent: (String verificationId, int? resendToken) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("code", verificationId);
          Get.to(const VerificationScreen());
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> verifyOTP(String otp) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? verificationId = pref.getString("code");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otp);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> createUser(UserModel userModel) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    await FirebaseAuth.instance.currentUser?.updateDisplayName(userModel.name);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(userModel.image);
    SharedPreferences.getInstance().then((value) {
      value.setString("number", userModel.number);
    });

    return await ref.doc(userModel.uid).set(userModel.toJson());
  }

  Future<String> uploadUserImage(String path, String uid, File file) async {
    Reference storage = FirebaseStorage.instance.ref(uid).child(path);
    UploadTask task = storage.putFile(file);
    TaskSnapshot snapshot = await task;
    String link = await snapshot.ref.getDownloadURL();
    return link;
  }

  Future<String?> updateName(String name, String uid) async {
    try{
      Map<String, Object> map = {};
      map['name'] = name;
      await FirebaseFirestore.instance.collection('users').doc(uid).update(map);
      return name;
    } on Exception catch(e){
      return Future.value(null);
    }
  }

  Future<String?> updateStatus(String status, String uid) async {
    try{
      Map<String, Object> map = {};
      map['status'] = status;
      await FirebaseFirestore.instance.collection('users').doc(uid).update(map);
      return status;
    } on Exception catch(e){
      return Future.value(null);
    }
  }

  Future<String?> updateImage(String imagePath, String uid) async {
    try{
      Map<String, Object> map = {};
      map['image'] = imagePath;
      await FirebaseFirestore.instance.collection('users').doc(uid).update(map);
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imagePath);
      return imagePath;
    } on Exception catch(e){
      return Future.value(null);
    }
  }

  Future<List<UserModel>?> getAppContacts() async {
    try{
      final data = await FirebaseFirestore.instance.collection('users').get();
      return data.docs.map((e) => UserModel.fromJson(e.data())).toList();
    } on Exception catch(e){
      return Future.value(null);
    }
  }

}
