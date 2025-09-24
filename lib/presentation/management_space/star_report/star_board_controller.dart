import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/domain/learning_path/learning_path_usecases.dart';

class StarBoardController extends GetxController {
  final LearningPathUseCases learningPathUseCases;

  StarBoardController({required this.learningPathUseCases});

  final ScrollController scrollControllerNav = ScrollController();
  final ScrollController scrollControllerBoard = ScrollController();

  final RxBool isLoading = false.obs;
  final Rx<String> _initiaChildPageRoute = AppRoute.starBoardWeek.obs;
  String get initialChildPageRoute => _initiaChildPageRoute.value;

  final RxInt _selectedLearningPathId = RxInt(-1);
  int get selectedLearningPathId => _selectedLearningPathId.value;

  final RxList<NavItem> _navBar = <NavItem>[].obs;
  List<NavItem> get navBar => _navBar;

  @override
  void onInit() {
    super.onInit();
    debugPrint("StarBoard Controller onInit");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLearningPaths();
    });
  }

  Future<void> fetchLearningPaths() async {
    try {
      isLoading.value = true;
      final learningPaths = await learningPathUseCases.getListLearningPaths();

      if (learningPaths.isEmpty) {
        debugPrint('No learning paths found');
        return;
      }

      _navBar.clear();
      for (var i = 0; i < learningPaths.length; i++) {
        final item = learningPaths[i];
        _navBar.add(
          NavItem(
            id: item['id'],
            title: item['name'],
            isActive: i == 0,
          ),
        );
      }

      // Set initial selected learning path id và navigate
      if (learningPaths.isNotEmpty) {
        final firstId = learningPaths[0]['id'];
        _selectedLearningPathId.value = firstId;
        debugPrint('Initial learning path ID: $firstId');
        final currentNavItem = _navBar[0];
        await Get.offNamed(
          AppRoute.starBoardCategoryChart,
          id: AppRoute.managementStarBoardRouteKey,
          arguments: {'learningPathId': currentNavItem.id},
          preventDuplicates: false,
        );
      }
    } catch (e) {
      debugPrint('Error fetching learning paths: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onChooseFeature(int index) async {
    if (index < 0 || index >= _navBar.length) return;

    final currentNavItem = _navBar[index];
    if (currentNavItem.id == null) return;

    // Update active states
    final oldIndex = _navBar.indexWhere((item) => item.isActive);
    if (oldIndex >= 0) {
      _navBar[oldIndex] = _navBar[oldIndex].copyWith(isActive: false);
    }
    _navBar[index] = currentNavItem.copyWith(isActive: true);

    // Set selected id và navigate
    final selectedId = currentNavItem.id!;
    _selectedLearningPathId.value = selectedId;
    debugPrint('Navigating to learning path ID: $selectedId');

    await Get.offNamed(
      AppRoute.starBoardCategoryChart,
      id: AppRoute.managementStarBoardRouteKey,
      arguments: {'learningPathId': selectedId},
      preventDuplicates: false,
    );
  }
}
