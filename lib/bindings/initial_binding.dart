import 'package:get/get.dart';
import 'package:talk_tube/controller/login_controller.dart';

class InitialBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies\
    Get.lazyPut(() => LoginController());
  }
}