import 'dart:async';
import 'package:EngKid/domain/notificaiton/notification_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/auto_notification/auto_notification.dart';
import 'package:EngKid/presentation/core/user_service.dart';

class NotificationSystemController extends GetxController {
  NotificationSystemController();

  final NotificationUsecases _notificationUsecases =
      Get.find<NotificationUsecases>();
  final UserService _userService = Get.find<UserService>();

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
    // Reload data from API with new search term
    handleGetPushNotifications();
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
    handleGetPushNotifications();
    handleReadNotifications();
  }

  set currentPage(int value) {
    _currentPage.value = value;
  }

  set idShowMore(List<int> value) {
    _idShowMore.assignAll(value);
  }

  void _updateTotalPages() {
    // This method is now deprecated since total pages come from API response
    // Total pages are set directly in handleGetPushNotifications()
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
      _isLoading.value = true;

      final int studentId = _userService.currentUser.id;
      print("Getting notifications for student ID: $studentId");

      final response = await _notificationUsecases.getNotification(
        studentId: studentId,
        searchTerm: _textSearch.value,
        pageNumb: _currentPage.value,
        pageSize: _itemsPerPage.value,
      );

      print("Notification API response: $response");

      if (response is Map<String, dynamic> &&
          response.containsKey('notification_list')) {
        _systemNotifications.clear();

        final List<dynamic> notificationList =
            response['notification_list'] ?? [];
        final int totalRecord = response['total_record'] ?? 0;
        final int totalPage = response['total_page'] ?? 1;

        print("Total records: $totalRecord, Total pages: $totalPage");

        for (var item in notificationList) {
          _systemNotifications.add(
            AutoNotification(
              id: item['notify_id'] ?? -1,
              title: item['title'] ?? "",
              content: item['content'] ?? "",
              createdAt: item['send_date'] ?? "",
              type: 2,
              isRead: 0,
              notiType: 0,
            ),
          );
        }

        // Update total pages from API response
        _totalPages.value = totalPage;

        print(
            "Loaded ${_systemNotifications.length} notifications from page ${_currentPage.value} of $totalPage");
      }

      handleReadNotifications();
    } catch (e) {
      print("Error loading notifications: $e");

      // Fallback to sample data if API fails
      _systemNotifications.clear();
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
      ]);
      _totalPages.value = 1;
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
    // Since API handles pagination, return all loaded notifications
    return _systemNotifications;
  }

  void goToNextPage() {
    if (_currentPage.value < _totalPages.value) {
      _currentPage.value++;
      handleGetPushNotifications();
    }
  }

  void goToPreviousPage() {
    if (_currentPage.value > 1) {
      _currentPage.value--;
      handleGetPushNotifications();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages.value) {
      _currentPage.value = page;
      handleGetPushNotifications();
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
    try {
      // final homeScreenController = Get.find<HomeScreenController>();
      // homeScreenController.handleGetNotifications();
    } catch (e) {
      print("HomeScreenController not found: $e");
    }
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
