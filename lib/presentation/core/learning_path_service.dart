import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/learning_path/learning_path_usecases.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';

class LearningPathService extends GetxService {
  final LearningPathUseCases learningPathUseCases;

  LearningPathService({required this.learningPathUseCases});

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> currentCategoryItems =
      <Map<String, dynamic>>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;

  // Get categories for a learning path
  Future<void> fetchLearningPathCategories(int pathId) async {
    try {
      isLoading.value = true;
      categories.clear();
      currentCategoryItems.clear();

      if (!_networkService.networkConnection.value) {
        if (kDebugMode) {
          print("No network connection");
        }
        return;
      }

      final response =
          await learningPathUseCases.getLearningPathCategories(pathId);

      final categoriesList = response['categories'] as List;

      categories.value = List<Map<String, dynamic>>.from(categoriesList);

      // Load items for first category by default
      if (categories.isNotEmpty) {
        selectedCategoryIndex.value = 0;
        await fetchLearningPathItems(pathId, categories[0]['id']);
      }
    } catch (e) {
      categories.clear();
      currentCategoryItems.clear();
      if (kDebugMode) {
        print("Error fetching learning path categories: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get items for a specific category
  Future<void> fetchLearningPathItems(int pathId, int categoryId) async {
    try {
      currentCategoryItems.clear();

      if (!_networkService.networkConnection.value) {
        if (kDebugMode) {
          print("No network connection");
        }
        return;
      }

      final studentId = _userService.currentUser.id;
      final items = await learningPathUseCases.getLearningPathItems(
          pathId, categoryId, studentId);

      currentCategoryItems.value = items;
    } catch (e) {
      currentCategoryItems.clear();
      if (kDebugMode) {
        print("Error fetching learning path items: $e");
      }
    }
  }

  // Change selected category and load its items
  Future<void> changeCategory(int pathId, int categoryIndex) async {
    if (categoryIndex >= 0 && categoryIndex < categories.length) {
      selectedCategoryIndex.value = categoryIndex;
      final categoryId = categories[categoryIndex]['id'];
      await fetchLearningPathItems(pathId, categoryId);
    }
  }

  // Get current selected category
  Map<String, dynamic>? get currentCategory {
    if (categories.isNotEmpty &&
        selectedCategoryIndex.value >= 0 &&
        selectedCategoryIndex.value < categories.length) {
      return categories[selectedCategoryIndex.value];
    }
    return null;
  }
}
