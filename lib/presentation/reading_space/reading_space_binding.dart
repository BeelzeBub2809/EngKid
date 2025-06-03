import 'package:get/get.dart';
import 'reading_space_controller.dart';

class ReadingSpaceBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(TopicController(topicUseCases: Get.find()));
    Get.lazyPut<ReadingSpaceController>(
      () => ReadingSpaceController(),
    );
  }
}
