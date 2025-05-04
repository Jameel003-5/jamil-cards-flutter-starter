
import 'package:get/get.dart';
import 'package:jamil_web/userController.dart';


class Binding extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => UserController());


  }
}