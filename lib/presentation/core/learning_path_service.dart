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

  final RxList<Map<String, dynamic>> learningPaths =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> currentCategoryItems =
      <Map<String, dynamic>>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final Rxn<Map<String, dynamic>> currentLearningPath =
      Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> overallProgress = Rxn<Map<String, dynamic>>();

  // Get list of all learning paths
  Future<void> fetchLearningPaths() async {
    try {
      isLoading.value = true;
      learningPaths.clear();

      if (!_networkService.networkConnection.value) {
        if (kDebugMode) {
          print("No network connection");
        }
        return;
      }

      final response = await learningPathUseCases.getListLearningPaths();
      learningPaths.value = response;

      if (kDebugMode) {
        print("Loaded ${learningPaths.length} learning paths from API");
      }
    } catch (e) {
      learningPaths.clear();
      if (kDebugMode) {
        print("Error fetching learning paths: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get categories and items for a learning path (merged API)
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

      final studentId = _userService.currentUser.id;
      final response =
          await learningPathUseCases.getLearningPathItems(pathId, studentId);

      // Extract learning path info
      currentLearningPath.value =
          response['learning_path'] as Map<String, dynamic>?;

      // Extract categories
      final categoriesList = response['categories'] as List;
      categories.value = List<Map<String, dynamic>>.from(categoriesList);

      // Extract overall progress
      overallProgress.value =
          response['overall_progress'] as Map<String, dynamic>?;

      // Set default to first unlocked category
      if (categories.isNotEmpty) {
        selectedCategoryIndex.value = 0;

        // Find first unlocked category
        for (int i = 0; i < categories.length; i++) {
          if (categories[i]['unlocked'] == true) {
            selectedCategoryIndex.value = i;
            break;
          }
        }

        // Load items for selected category
        await _loadItemsForSelectedCategory();
      }

      if (kDebugMode) {
        print("Loaded ${categories.length} categories from merged API");
        print("Overall progress: ${overallProgress.value}");
      }
    } catch (e) {
      categories.clear();
      currentCategoryItems.clear();
      if (kDebugMode) {
        print("Error fetching learning path categories and items: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get items for current selected category from already loaded data
  Future<void> fetchLearningPathItems(int pathId, int categoryId) async {
    await _loadItemsForSelectedCategory();
  }

  // Helper method to load items for selected category
  Future<void> _loadItemsForSelectedCategory() async {
    try {
      currentCategoryItems.clear();

      if (categories.isNotEmpty &&
          selectedCategoryIndex.value >= 0 &&
          selectedCategoryIndex.value < categories.length) {
        final selectedCategory = categories[selectedCategoryIndex.value];

        // Check if category is unlocked
        if (selectedCategory['unlocked'] != true) {
          if (kDebugMode) {
            print("Category ${selectedCategory['title']} is locked");
          }
          return;
        }

        final items = selectedCategory['items'] as List;
        currentCategoryItems.value = List<Map<String, dynamic>>.from(items);

        if (kDebugMode) {
          print(
              "Loaded ${currentCategoryItems.length} items for category: ${selectedCategory['title']}");
        }
      }
    } catch (e) {
      currentCategoryItems.clear();
      if (kDebugMode) {
        print("Error loading items for selected category: $e");
      }
    }
  }

  // Change selected category and load its items
  Future<void> changeCategory(int pathId, int categoryIndex) async {
    if (categoryIndex >= 0 && categoryIndex < categories.length) {
      final selectedCategory = categories[categoryIndex];

      // Check if category is unlocked
      if (selectedCategory['unlocked'] != true) {
        if (kDebugMode) {
          print("Cannot select locked category: ${selectedCategory['title']}");
        }
        return;
      }

      selectedCategoryIndex.value = categoryIndex;
      await _loadItemsForSelectedCategory();
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
