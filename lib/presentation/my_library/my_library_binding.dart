import 'package:get/get.dart';
import 'my_library_controller.dart';

class MyLibraryBinding extends Bindings {
  MyLibraryBinding();

  @override
  void dependencies() {
    Get.lazyPut(
          () => MyLibraryController(),
    );
  }
}
