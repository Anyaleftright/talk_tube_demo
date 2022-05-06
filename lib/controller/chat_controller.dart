import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talk_tube_1/models/user_model.dart';
import 'package:talk_tube_1/network/app_firebase.dart';
import 'package:talk_tube_1/others/app_permission.dart';

import '../others/app_util.dart';

class ChatController extends GetxController {
  final RxList<UserModel> _contactList = RxList();
  RxBool isLoading = RxBool(false);

  List<UserModel> get contacts => _contactList;
  AppPermission appPermission = AppPermission();
  AppFirebase appFirebase = AppFirebase();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String myNumber;

  @override
  void onInit() {
    super.onInit();
    myNumber = auth.currentUser!.phoneNumber!;
    getMobileContact();
  }

  Future<void> getMobileContact() async {
    var status = await appPermission.isContactPermissionOk();
    switch (status) {
      case PermissionStatus.denied:
        var status = await Permission.contacts.request().isDenied;
        if (status) {
          await getContact();
        } else {
          printError(info: "Contact Permission denied");
        }
        break;
      case PermissionStatus.granted:
        await getContact();
        break;
      case PermissionStatus.restricted:
        printError(info: "Contact Permission denied");
        break;
      case PermissionStatus.limited:
        printError(info: "Contact Permission denied");
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
    }
  }

  Future<void> getContact() async {
    _contactList.clear();
    isLoading(true);
    Iterable<Contact> result = await getMobileContacts();

    if (result.isNotEmpty) {
      List<UserModel> mobileContacts = [];

      for (var element in result) {
        String number = element.phones!.elementAt(0).value!;
        number = number.replaceAll(RegExp("\\s"), "");

        if (number[0] == "0") {
          number.replaceFirst(RegExp("(?:0)"), "+84");
          mobileContacts.add(UserModel(
              uid: element.identifier!,
              name: element.displayName!,
              image: element.avatar.toString(),
              number: number,
              status: "",
              typing: "",
              online: ""));
        }
      }
      appFirebase.getAppContacts().then((value) {
        if (value != null && value.isNotEmpty) {
          printInfo(info: value.length.toString());
          for (var app in value) {
            for (var mobile in mobileContacts) {
              if (app.number == mobile.number /*&& app.number != myNumber*/) {
                _contactList.add(UserModel(
                  uid: app.uid,
                  name: app.name,
                  image: app.image,
                  number: app.number,
                  status: app.status,
                  typing: app.typing,
                  online: app.online,
                ));
              }
            }
          }
          isLoading(false);
        } else {
          isLoading(false);
        }
      });
    } else {
      isLoading(false);
    }
  }
}
