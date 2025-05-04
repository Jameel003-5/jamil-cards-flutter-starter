import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/nfc_tag_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => NFCTagController());
  }
}
