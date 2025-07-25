import 'package:EngKid/presentation/home/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/auto_notification/auto_notification.dart';
import 'package:EngKid/presentation/core/user_service.dart';

class NotificationSystemController extends GetxController {
  NotificationSystemController();

  final UserService _userService = Get.find<UserService>();
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxList<AutoNotification> _systemNotifications =
      RxList<AutoNotification>.empty(growable: true);
  final RxBool _isLoading = true.obs;
  final RxString _textSearch = "".obs;
  final RxInt _tabActive = 0.obs;
  final RxList<int> _idShowMore = RxList<int>.empty(growable: true);

  String get textSearch => _textSearch.value;
  bool get isLoading => _isLoading.value;
  int get tabActive => _tabActive.value;
  List<int> get idShowMore => _idShowMore;
  List<AutoNotification> get systemNotifications => _systemNotifications;
  set textSearch(String value) {
    _textSearch.value = value;
  }

  set tabActive(int value) {
    _tabActive.value = value;
    handleReadNotifications();
  }

  set idShowMore(List<int> value) {
    _idShowMore.assignAll(value);
  }

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    handleGetPushNotifications();
    super.onInit();
  }

  Future<void> handleGetPushNotifications() async {
    try {
      // - Push noti: 1
      // + type = 0: Quan trọng
      // + type = 1: BTVN
      // - Auto Noti: 0
      // + type = 0: Tiến độ đọc
      // + type = 1: tương tác
      // final dynamic res = await _userService.handleGetPushNotifications();
      // final xx = List<AutoNotification>.from(res["push_notification"]);
      // for (var value in (res["push_notification"] as List<dynamic>)) {
      //   _systemNotifications.add(
      //     AutoNotification(
      //       id: value["id"] ?? -1,
      //       title: value["title"] ?? "",
      //       content: value["content"],
      //       createdAt: value["created_at"],
      //       type: value["type"],
      //       isRead: value["is_read"],
      //       notiType: value["notification_type"] ?? 0,
      //     ),
      //   );
      // }

      // for (var value in (res["auto_notification"] as List<dynamic>)) {
      //   _systemNotifications.add(
      //     AutoNotification(
      //       id: value["id"] ?? -1,
      //       title: value["title"] ?? "",
      //       content: value["content"],
      //       createdAt: value["created_at"],
      //       type: value["type"],
      //       isRead: value["is_read"],
      //       notiType: -1,
      //     ),
      //   );
      // }
      handleReadNotifications();
    } catch (e) {
      debugPrint("");
    }
    _isLoading.value = false;
  }

  void handleReadNotification(object) async {
    int index =
        systemNotifications.indexWhere((element) => element.id == object.id);

    if (index == -1) return; // Check nếu không tìm thấy

    final status = systemNotifications[index].isRead == 0 ? 1 : 0;

    // final dynamic res = await _userService.readNotification({
    //   "notification_id": object.id,
    //   "user_id": _userService.currentUser.id,
    //   "status": status,
    // });

    // if (res != null) {
    //   systemNotifications[index] =
    //       systemNotifications[index].copyWith(isRead: status);
    // }
  }

  List<AutoNotification> getListByTab(
      List<AutoNotification> list, String search) {
    return list.where((element) {
      bool check = false;
      if (tabActive == 0) {
        check = element.notiType == 0 && element.type == 2;
      } else if (tabActive == 1) {
        check = element.notiType == 1 && element.type == 2;
      } else if (tabActive == 2) {
        check = element.notiType == -1 && element.type == 1;
      } else if (tabActive == 3) {
        check = element.notiType == -1 && element.type == 2;
      } else {
        check = true;
      }
      if (search == "") {
        return check;
      }
      return (element.content.contains(search) && check);
    }).toList();
  }

  Future<void> handleReadNotifications() async {
    final list = getListByTab(_systemNotifications, "")
        .where((element) => element.isRead == 0);
    if (list.isEmpty) return;
    // if (tabActive == 0 || tabActive == 1) {
    //   await _userService.handleReadPushNotifications({
    //     "student_id": _userService.userLogin.id,
    //     "is_read": 1,
    //     "notifications": list.map((item) {
    //       return {"id": item.id};
    //     }).toList(),
    //   });
    // } else {
    //   await _userService.handleReadAutoNotifications({
    //     "is_read": 1,
    //     "notifications": list.map((item) {
    //       return {"id": item.id};
    //     }).toList(),
    //   });
    // }
  }

  void getNofiKidSpace() {
    final HomeScreenController kidSpaceController =
        Get.find<HomeScreenController>();
    // kidSpaceController.handleGetNotifications();
  }
}
