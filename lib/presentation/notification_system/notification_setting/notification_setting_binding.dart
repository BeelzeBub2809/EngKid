import 'package:get/get.dart';
import 'package:EngKid/presentation/notification_system/notification_setting/notification_setting_controller.dart';

class NotificationSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationSettingController>(
      () => NotificationSettingController(),
    );
  }
}
