import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:talk_tube/models/user_model.dart';

class SettingController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

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
}
