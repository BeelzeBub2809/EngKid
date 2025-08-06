import 'package:get/get.dart';
import 'missing_word_controller.dart';

class MissingWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissingWordController>(() => MissingWordController());
  }
}
