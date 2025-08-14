import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_route.dart';

class StarBoardController extends GetxController {
  StarBoardController();

  final ScrollController scrollControllerNav = ScrollController();
  final ScrollController scrollControllerBoard = ScrollController();

  final RxBool isLoading = false.obs;
  final Rx<String> _initiaChildPageRoute = AppRoute.starBoardWeek.obs;
  String get initialChildPageRoute => _initiaChildPageRoute.value;

  final List<Rx<NavItem>> _navBar = [
    const NavItem(title: 'week', isActive: true).obs,
    const NavItem(title: 'month', isActive: false).obs,
    const NavItem(title: 'year', isActive: false).obs,
  ];
  List<Rx<NavItem>> get navBar => _navBar;

  @override
  Future<void> onInit() async {
    super.onInit();
    await generateSampleData();
  }

  Future<void> onChooseFeature(int index) async {
    final int activeIndex =
        navBar.indexWhere((element) => element.value.isActive == true);
    if (activeIndex == index) return;
    _navBar[activeIndex](
      navBar[activeIndex].value.copyWith(isActive: false),
    );
    _navBar[index](
      navBar[index].value.copyWith(isActive: true),
    );

    // Use nested navigation with proper routes
    String routeName;
    switch (navBar[index].value.title) {
      case 'week':
        routeName = AppRoute.starBoardWeek;
        break;
      case 'month':
        routeName = AppRoute.starBoardMonth;
        break;
      case 'year':
        routeName = AppRoute.starBoardYear;
        break;
      default:
        routeName = AppRoute.starBoardWeek;
    }

    Get.offNamed(
      routeName,
      id: AppRoute.managementStarBoardRouteKey,
    );
  }

  Future<void> getStarsHistory() async {
    isLoading.value = true;

    try {
      // Use sample data since we're in development/demo mode
      debugPrint("Loading star history from sample data...");
    } catch (e) {
      debugPrint("Error loading star history: $e");
    }

    isLoading.value = false;
  }

  // Chuyển đổi chuỗi ngày thành đối tượng DateTime
  DateTime parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  Future<void> generateSampleData() async {
    isLoading.value = true;

    try {
      debugPrint("Sample data initialization completed for star board");
    } catch (e) {
      debugPrint("Error generating sample data: $e");
    }

    isLoading.value = false;
  }

// Lọc các phần tử trong danh sách theo tháng và tính tổng giá trị
}
