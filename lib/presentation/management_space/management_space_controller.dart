import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_route.dart';

class ManagementSpaceController extends GetxController {
  ManagementSpaceController();

  // final UserService _userService = Get.find<UserService>();
  final ScrollController scrollControllerNav = ScrollController();
  final ScrollController scrollControllerBoard = ScrollController();

  final Rx<String> _initiaChildPageRoute = AppRoute.report.obs;
  String get initialChildPageRoute => _initiaChildPageRoute.value;

  final List<Rx<NavItem>> _navBar = [
    const NavItem(title: 'report', isActive: true).obs,
    const NavItem(title: 'star_board', isActive: false).obs,
    const NavItem(title: 'report_personal_info', isActive: false).obs,
    const NavItem(title: 'settings', isActive: false).obs,
  ];
  List<Rx<NavItem>> get navBar => _navBar;

  @override
  Future<void> onInit() async {
    super.onInit();
    final defaultRoute = Get.arguments;

    if (defaultRoute == null) return;

    final int indexRouteActive =
        _navBar.indexWhere((element) => element.value.title == defaultRoute);
    if (indexRouteActive == -1) return;
    _initiaChildPageRoute.value = "/$defaultRoute";

    _navBar[0](
      navBar[0].value.copyWith(isActive: false),
    );
    _navBar[indexRouteActive](
      navBar[indexRouteActive].value.copyWith(isActive: true),
    );
  }

  Future<void> onChooseFeature(int index) async {
    final int activeIndex =
        navBar.indexWhere((element) => element.value.isActive == true);
    _navBar[activeIndex](
      navBar[activeIndex].value.copyWith(isActive: false),
    );
    _navBar[index](
      navBar[index].value.copyWith(isActive: true),
    );
    print("onChooseFeature: ${navBar[index].value.title}");
    Get.offNamed(
      '/${navBar[index].value.title}',
      id: AppRoute.managementSpaceNestedRouteKey,
    );
  }
}
