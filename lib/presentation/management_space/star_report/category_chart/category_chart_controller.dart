import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/start_board/entities/learning_path_stars.dart';
import 'package:EngKid/domain/start_board/star_board_usecases.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';

class CategoryChartController extends GetxController {
  final StarBoardUseCases starBoardUseCases;
  final int learningPathId;

  CategoryChartController({
    required this.starBoardUseCases,
    required this.learningPathId,
  });

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final RxBool isLoading = false.obs;
  final Rxn<LearningPathStars> learningPathStars = Rxn<LearningPathStars>();
  final RxList<DayOf> categoriesData = <DayOf>[].obs;
  final RxDouble maxYValue = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint(
        "Init CategoryChart Controller for Learning Path: $learningPathId");

    if (learningPathId > 0) {
      await getLearningPathStarsHistory();
    }
  }

  Future<void> getLearningPathStarsHistory() async {
    if (!_networkService.networkConnection.value) {
      debugPrint("No network connection");
      return;
    }

    isLoading.value = true;
    try {
      final response = await starBoardUseCases.getLearningPathStars(
        studentId: _userService.currentUser.id,
        learningPathId: learningPathId,
      );

      learningPathStars.value = response;

      // Convert categories to DayOf objects for chart display
      categoriesData.clear();

      if (response.categories.isNotEmpty) {
        for (int i = 0; i < response.categories.length; i++) {
          final category = response.categories[i];

          // Calculate position for horizontal scrolling
          double leftPosition =
              i * (0.08 + 0.02); // 8% width per category + 2% spacing

          final dayOf = DayOf(
            text: category.categoryName.length > 8
                ? "${category.categoryName.substring(0, 8)}..."
                : category.categoryName,
            left: leftPosition,
            value: category.totalStars.toDouble(),
            isHighlight: category.itemsWithStars > 0,
          );

          categoriesData.add(dayOf);
        }
      }

      // Calculate max Y value for chart scaling
      if (categoriesData.isNotEmpty) {
        maxYValue.value = categoriesData
            .map((category) => category.value)
            .reduce((a, b) => a > b ? a : b);

        // Ensure maxY is at least 1 to avoid division by zero
        if (maxYValue.value == 0) maxYValue.value = 1;
        // Add some padding to make chart look better
        maxYValue.value = maxYValue.value + 2;
      }

      debugPrint("Loaded learning path stars: ${response.learningPathName}");
      debugPrint("Total categories: ${categoriesData.length}");
      debugPrint("Max Y value: ${maxYValue.value}");
    } catch (e) {
      debugPrint("Error loading learning path stars: $e");
      // Show error message to user
      Get.snackbar(
        'Error',
        'Failed to load learning path statistics',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get total width needed for horizontal scrolling
  double get totalChartWidth {
    if (categoriesData.isEmpty) return 1.0;
    return categoriesData.length * 0.1; // Each category takes 10% width
  }

  // Check if horizontal scrolling is needed
  bool get needsHorizontalScroll {
    return categoriesData.length > 6; // If more than 6 categories
  }

  @override
  void onClose() {
    debugPrint("Disposing CategoryChart Controller");
    super.onClose();
  }
}
