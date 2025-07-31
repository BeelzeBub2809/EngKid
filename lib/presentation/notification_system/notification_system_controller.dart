import 'dart:async';
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

  // Debounce timer for search
  Timer? _searchDebounceTimer;

  final RxList<AutoNotification> _systemNotifications =
      RxList<AutoNotification>.empty(growable: true);
  final RxBool _isLoading = true.obs;
  final RxString _textSearch = "".obs;
  final RxInt _tabActive = 0.obs;
  final RxList<int> _idShowMore = RxList<int>.empty(growable: true);

  // Pagination properties
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 5.obs;
  final RxInt _totalPages = 1.obs;

  String get textSearch => _textSearch.value;
  bool get isLoading => _isLoading.value;
  int get tabActive => _tabActive.value;
  int get currentPage => _currentPage.value;
  int get itemsPerPage => _itemsPerPage.value;
  int get totalPages => _totalPages.value;
  List<int> get idShowMore => _idShowMore;
  List<AutoNotification> get systemNotifications => _systemNotifications;

  set textSearch(String value) {
    _textSearch.value = value;
    _currentPage.value = 1; // Reset to first page when searching
    _updateTotalPages();
  }

  // Debounce search method
  void debouncedSearch() {
    _searchDebounceTimer?.cancel();

    final searchText = textEditingController.text;

    if (searchText.isEmpty) {
      textSearch = searchText;
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      textSearch = searchText;
    });
  }

  set tabActive(int value) {
    _tabActive.value = value;
    _currentPage.value = 1; // Reset to first page when changing tab
    _updateTotalPages();
    handleReadNotifications();
  }

  set currentPage(int value) {
    _currentPage.value = value;
  }

  set idShowMore(List<int> value) {
    _idShowMore.assignAll(value);
  }

  void _updateTotalPages() {
    final filteredList = getListByTab(_systemNotifications, _textSearch.value);
    _totalPages.value = (filteredList.length / _itemsPerPage.value).ceil();
    if (_totalPages.value == 0) _totalPages.value = 1;
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
      // Create fake data for testing
      _systemNotifications.addAll([
        AutoNotification(
          id: 1,
          title: "Chúc mừng hoàn thành bài học!",
          content:
              "Bạn đã hoàn thành xuất sắc bài học 'Động vật trong rừng'. Hãy tiếp tục học tập để khám phá thêm nhiều kiến thức thú vị!",
          createdAt:
              DateTime.now().subtract(const Duration(hours: 2)).toString(),
          type: 2,
          isRead: 0,
          notiType: 0,
        ),
        AutoNotification(
          id: 2,
          title: "Bài tập về nhà mới",
          content:
              "Giáo viên đã giao bài tập về nhà mới cho môn Tiếng Anh. Hạn nộp: 25/07/2025",
          createdAt:
              DateTime.now().subtract(const Duration(days: 1)).toString(),
          type: 2,
          isRead: 1,
          notiType: 1,
        ),
        AutoNotification(
          id: 3,
          title: "Tiến độ học tập",
          content:
              "Bạn đã đọc được 15/20 truyện trong tuần này. Hãy cố gắng hoàn thành mục tiêu nhé!",
          createdAt:
              DateTime.now().subtract(const Duration(hours: 5)).toString(),
          type: 1,
          isRead: 0,
          notiType: -1,
        ),
        AutoNotification(
          id: 4,
          title: "Thời gian học hôm nay",
          content:
              "Bạn đã học được 45 phút hôm nay. Thật tuyệt vời! Hãy nghỉ ngơi và tiếp tục vào ngày mai.",
          createdAt:
              DateTime.now().subtract(const Duration(minutes: 30)).toString(),
          type: 2,
          isRead: 0,
          notiType: -1,
        ),
        AutoNotification(
          id: 5,
          title: "Kiểm tra định kỳ",
          content:
              "Nhắc nhở: Bài kiểm tra định kỳ môn Toán sẽ diễn ra vào ngày 28/07/2025. Hãy ôn tập kỹ nhé!",
          createdAt:
              DateTime.now().subtract(const Duration(days: 2)).toString(),
          type: 2,
          isRead: 1,
          notiType: 0,
        ),
        AutoNotification(
          id: 6,
          title: "Hoạt động mới",
          content:
              "Có hoạt động tô màu mới trong phần 'Sáng tạo'. Hãy thử sức với những bức tranh thú vị!",
          createdAt:
              DateTime.now().subtract(const Duration(hours: 8)).toString(),
          type: 2,
          isRead: 0,
          notiType: -1,
        ),
        AutoNotification(
          id: 7,
          title: "Chúc mừng sinh nhật!",
          content:
              "Chúc mừng sinh nhật bé yêu! Hôm nay là ngày đặc biệt của bạn. Chúc bạn luôn khỏe mạnh và học giỏi!",
          createdAt:
              DateTime.now().subtract(const Duration(hours: 12)).toString(),
          type: 2,
          isRead: 1,
          notiType: 0,
        ),
        AutoNotification(
          id: 8,
          title: "Bài học mới đã sẵn sàng",
          content:
              "Bài học 'Khám phá vũ trụ' đã được cập nhật. Hãy cùng tìm hiểu về các hành tinh và ngôi sao nhé!",
          createdAt:
              DateTime.now().subtract(const Duration(days: 3)).toString(),
          type: 1,
          isRead: 0,
          notiType: -1,
        ),
        AutoNotification(
          id: 9,
          title: "Thành tích xuất sắc",
          content:
              "Wow! Bạn đã đạt 100 điểm trong trò chơi ghép từ. Bạn thực sự rất giỏi!",
          createdAt:
              DateTime.now().subtract(const Duration(hours: 1)).toString(),
          type: 2,
          isRead: 0,
          notiType: -1,
        ),
        AutoNotification(
          id: 10,
          title: "Nhắc nhở uống nước",
          content:
              "Đã đến giờ uống nước rồi! Hãy uống đủ nước để cơ thể luôn khỏe mạnh nhé bé yêu.",
          createdAt:
              DateTime.now().subtract(const Duration(minutes: 15)).toString(),
          type: 2,
          isRead: 1,
          notiType: -1,
        ),
      ]);

      _updateTotalPages();
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

    // Status handling is currently commented out

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
      // Show all notifications regardless of type
      if (search.isEmpty) {
        return true;
      }
      // Filter by search text in title or content
      return element.title.toLowerCase().contains(search.toLowerCase()) ||
          element.content.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  List<AutoNotification> getPaginatedNotifications() {
    final filteredList = getListByTab(_systemNotifications, _textSearch.value);
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;

    if (startIndex >= filteredList.length) {
      return [];
    }

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  void goToNextPage() {
    if (_currentPage.value < _totalPages.value) {
      _currentPage.value++;
    }
  }

  void goToPreviousPage() {
    if (_currentPage.value > 1) {
      _currentPage.value--;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages.value) {
      _currentPage.value = page;
    }
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
    // Get notifications for kid space - currently commented out
    // final HomeScreenController kidSpaceController =
    //     Get.find<HomeScreenController>();
    // kidSpaceController.handleGetNotifications();
  }

  @override
  void onClose() {
    // Cancel debounce timer when controller is disposed
    _searchDebounceTimer?.cancel();
    textEditingController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
