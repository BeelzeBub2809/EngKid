import 'package:get/get.dart';
import 'package:EngKid/presentation/home/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  HomeScreenBinding();

  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeScreenController(),
    );
  }
}
