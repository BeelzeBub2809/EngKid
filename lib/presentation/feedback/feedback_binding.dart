import 'package:get/get.dart';
import 'package:EngKid/presentation/feedback/feedback_controller.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackController>(() => FeedbackController());
  }
}
