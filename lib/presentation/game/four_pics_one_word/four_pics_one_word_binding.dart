import 'package:get/get.dart';
import 'four_pics_one_word_controller.dart';

class FourPicsOneWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FourPicsOneWordController>(() => FourPicsOneWordController());
  }
}
