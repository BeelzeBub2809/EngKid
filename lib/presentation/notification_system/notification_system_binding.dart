import 'package:get/get.dart';
import 'package:EngKid/presentation/notification_system/notification_system_controller.dart';

class NotificationSystemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationSystemController>(
      () => NotificationSystemController(),
    );
  }
}
