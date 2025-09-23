import 'dart:async';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../core/network_service.dart';
import '../core/learning_path_service.dart';

class MyLibraryController extends GetxController {
  MyLibraryController();

  final NetworkService _networkService = Get.find<NetworkService>();
  final LearningPathService _learningPathService =
      Get.find<LearningPathService>();

  // Pagination variables
  final int itemsPerPage = 4; // Changed to 4 for 2x2 grid layout
  final RxInt _currentPage = 0.obs;
  final RxBool _isLoading = false.obs;

  int get currentPage => _currentPage.value;
  int get totalPages => (learningPaths.length / itemsPerPage).ceil();
  bool get hasNextPage => currentPage < totalPages - 1;
  bool get hasPreviousPage => currentPage > 0;
  bool get isLoading => _isLoading.value;

  // Use learning paths from service
  List<Map<String, dynamic>> get learningPaths =>
      _learningPathService.learningPaths;

  // Get current page items
  List<Map<String, dynamic>> get currentPageItems {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, learningPaths.length);
    return learningPaths.sublist(startIndex, endIndex);
  }

  // Pagination methods
  void nextPage() {
    if (hasNextPage) {
      _currentPage.value++;
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      _currentPage.value--;
    }
  }

  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < totalPages) {
      _currentPage.value = pageIndex;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _fetchLearningPaths();
    Future.delayed(const Duration(milliseconds: 1000), () {
      LibFunction.playAudioLocal(LocalAudio.chooseGrade);
    });
  }

  Future<void> _fetchLearningPaths() async {
    try {
      _isLoading.value = true;
      await _learningPathService.fetchLearningPaths();
    } catch (e) {
      print('Error fetching learning paths: $e');
      LibFunction.toast('Failed to load learning paths');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshLearningPaths() async {
    await _fetchLearningPaths();
  }

  void onBackPress() async {
    await LibFunction.effectExit();
    Get.back();
  }

  void onPressLearningPath(Map<String, dynamic> learningPath) async {
    await LibFunction.effectConfirmPop();
    if (_networkService.networkConnection.value) {
      Get.toNamed(AppRoute.readingSpace, arguments: learningPath);
    } else {
      LibFunction.toast('require_network_to_grade');
    }
  }
}
