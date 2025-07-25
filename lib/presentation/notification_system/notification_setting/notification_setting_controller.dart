import 'package:get/get.dart';
import 'package:EngKid/presentation/core/user_service.dart';

class NotificationSettingController extends GetxController {
  NotificationSettingController();
  final UserService _userService = Get.find<UserService>();
  final RxBool _isEnableNotification = false.obs;
  bool get isEnableNotification => _isEnableNotification.value;

  set isEnableNotification(bool value) {
    _isEnableNotification.value = value;
    // _userService.handleNotificationStatus({
    //   "user_id": _userService.userLogin.id,
    //   "notification_status": value ? 1 : 0,
    // });
  }

  @override
  void onInit() {
    _isEnableNotification.value =
        _userService.notificationSetting["notification_status"] == 1;
    super.onInit();
  }
}
